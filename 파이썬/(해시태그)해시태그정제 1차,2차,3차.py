import dbmanager as db

#튜플을 리스트로 변환하기
def TupletoList(result):
    hashtags = []
    for data in result:
        hashtags.append(list(data))
    return hashtags

per_page = 5000 #데이터를 5000개씩 잘라서 메모리에 올린다.


#데이터를 페이징한다. 원본데이터에서 전체 페이지수를 가져온다.
def GetSliceTotalPage(dbms) :
    global per_page
    sql = "select count(*) as count from crawlingdata"
    result = dbms.OpenQuery(sql)
    total = int(dbms.GetValue(0,"count"))
    total_page =  total // per_page
    if(total % per_page != 0) :
        total_page = total_page + 1
    return total_page

#1차정제(게시글의 모든 해시태그가 문자열로 저장되어있는 상태 => 게시글 별로 모든 해시태그를 하나씩 분리)
def SliceHash(dbms,pageNo,total_page) :
    global per_page
    startNo = pageNo * per_page
    endNo   = per_page
    
    job_total = 1
    
    #불러오는 데이터에 개수 제한을 준다.
    sql = "select cdno,cdhashtag,cdregion,cdwdate from crawlingdata limit %d,%d" % (startNo,endNo)
    print(sql)
    result = dbms.OpenQuery(sql)       #튜플안의 튜플 형식으로 반환됨.
    hashtags = TupletoList(result)
    #print(hashtags)
    
    #게시글별로 모든 해시태그를 하나씩 분리한다.
    for i in hashtags:
        print("%d/%d페이지의 %d번째 작업 처리중..." % ((pageNo+1),total_page,job_total))
        job_total = job_total + 1        
        
        a = i[0]  #게시글관리번호  cdno 
        b = i[1]  #해시태그명     cdhashtag
        c = i[2]  #지역해시태그명 cdregion
        d = i[3]  #작성일        cdwdate
        
        if a == None :  continue
        if b == None :  continue
        if c == None :  continue
        if d == None :  continue
        
        #해시태그 쪼개주기
        tags = b.replace("[","").replace("]","").replace("'","").replace(" ","")
        tags = tags.split(",")        
        
        #1행1해시태그 형태로 해시태그 정제 테이블에(refinehashtag)에 저장
        for j in range(len(tags)):
            sql  = "insert into refinehashtag (rhrefine,rhno,rhhashtag,rhregiontag,rhwdate) values "
            sql += "(1," + str(a) + ",'" + tags[j] + "','" + c + "','" + d + "')"
            #print(sql)
            dbms.RunSQL(sql)
            #print(dbms.RunSQL(sql))    

#데이터를 페이징한다. 1차 정제 데이터에서 전체 페이지수를 가져온다.        
def GetSecondTotalPage(dbms) :
    global per_page
    sql = "select count(*) as count from refinehashtag where rhrefine = 1"
    result = dbms.OpenQuery(sql)
    total = int(dbms.GetValue(0,"count"))
    total_page =  total // per_page
    if(total % per_page != 0) :
        total_page = total_page + 1
    return total_page

#2차정제(상위12개 태그에 걸리면 안되는 태그들을 제거)
def DelStopword(dbms,pageNo,total_page) :
    global per_page
    startNo = pageNo * per_page
    endNo   = per_page
    job_total = 1
    
    #불러오는 데이터에 개수 제한을 준다.
    sql = "select rhno,rhhashtag,rhregiontag,rhwdate from refinehashtag where rhrefine = 1 limit %d,%d" % (startNo,endNo)
    result = dbms.OpenQuery(sql)       #튜플안의 튜플 형식으로 반환됨.
    hashtags = TupletoList(result)
    
    #해시태그 불용어 사전
    stop_words = ["#전주","#익산","#완주","#군산","#카페","#내돈내산","#서이추","#서로이웃","#소통","#서이추환영","#체크인챌린지","#일상","#주간일기챌린지","#체크인챌린지","#서로이웃환영","#공감","#이웃환영","#이웃","#댓글","#답방","#이웃추가","#좋아요"]
    
    #모든 1차 정제 데이터에서 해시태그 불용어를 제거
    for i in hashtags :
        print("%d/%d페이지의 %d번째 작업 처리중..." % ((pageNo+1),total_page,job_total))
        job_total = job_total + 1   
        
        a = i[0]  #게시글관리번호  rhno 
        b = i[1]  #해시태그명     rhhashtag
        c = i[2]  #지역해시태그명 rhregiontag
        d = i[3]  #작성일        rhwdate
        if b not in stop_words:
            sql  = "insert into refinehashtag (rhrefine,rhno,rhhashtag,rhregiontag,rhwdate) values "
            sql += "(2," + str(a) + ",'" + b + "','" + c + "','" + d + "')"
            #print(sql)
            dbms.RunSQL(sql)
            #print(dbms.RunSQL(sql))

#데이터를 페이징한다. 2차 정제 데이터에서 전체 페이지수를 가져온다.    
def GetThirdTotalPage(dbms) :
    global per_page
    sql = "select count(*) as count from refinehashtag where rhrefine = 2"
    result = dbms.OpenQuery(sql)
    total = int(dbms.GetValue(0,"count"))
    total_page =  total // per_page
    if(total % per_page != 0) :
        total_page = total_page + 1
    return total_page

#3차정제(지역이 안맞는 경우 제거 ex)완주카페에서 #전주카페 걸리는경우 삭제
def DelDuplicate(dbms,pageNo,total_page) :
    global per_page
    startNo = pageNo * per_page
    endNo   = per_page
    job_total = 1
    
    #불러오는 데이터에 개수 제한을 준다.
    sql = "select rhno,rhhashtag,rhregiontag,rhwdate from refinehashtag where rhrefine = 2 limit %d,%d" % (startNo,endNo)
    result = dbms.OpenQuery(sql)       #튜플안의 튜플 형식으로 반환됨.
    hashtags = TupletoList(result)
    
    #지역이 안맞는 경우 제거
    for i in hashtags :
        print("%d/%d페이지의 %d번째 작업 처리중..." % ((pageNo+1),total_page,job_total))
        job_total = job_total + 1   
        
        a = i[0]  #게시글관리번호  rhno 
        b = i[1]  #해시태그명     rhhashtag
        c = i[2]  #지역해시태그명 rhregiontag
        d = i[3]  #작성일        rhwdate
        e = c[1:3] #지역명
        
        if e == "전주":
            #익산,군산,완주가 해시태그명에 들어있으면 지나가게한다.    
            if  "군산" in b or "완주" in b or "익산" in b:
                continue
            
            sql  = "insert into refinehashtag (rhrefine,rhno,rhhashtag,rhregiontag,rhwdate) values "
            sql += "(3," + str(a) + ",'" + b + "','" + c + "','" + d + "')"
            #print(sql)
            dbms.RunSQL(sql)
            #print(dbms.RunSQL(sql))
        elif e == "완주":
            #전주,군산,익산이 해시태그명에 들어있으면 지나가게한다.    
            if  "전주" in b or "군산" in b or "익산" in b:
                continue
            
            sql  = "insert into refinehashtag (rhrefine,rhno,rhhashtag,rhregiontag,rhwdate) values "
            sql += "(3," + str(a) + ",'" + b + "','" + c + "','" + d + "')"
            #print(sql)
            dbms.RunSQL(sql)
            #print(dbms.RunSQL(sql))
        elif e == "익산":
            #전주,군산,완주가 해시태그명에 들어있으면 지나가게한다.    
            if  "전주" in b or "군산" in b or "완주" in b:
                continue
            
            sql  = "insert into refinehashtag (rhrefine,rhno,rhhashtag,rhregiontag,rhwdate) values "
            sql += "(3," + str(a) + ",'" + b + "','" + c + "','" + d + "')"
            #print(sql)
            dbms.RunSQL(sql)
            #print(dbms.RunSQL(sql))
        elif e == "군산":
            #전주,완주,익산이 해시태그명에 들어있으면 지나가게한다.    
            if  "전주" in b or "완주" in b or "익산" in b:
                continue
            
            sql  = "insert into refinehashtag (rhrefine,rhno,rhhashtag,rhregiontag,rhwdate) values "
            sql += "(3," + str(a) + ",'" + b + "','" + c + "','" + d + "')"
            #print(sql)
            dbms.RunSQL(sql)
            #print(dbms.RunSQL(sql))
        
'''
#1차 정제 db에 연결     
#1차정제(게시글의 모든 해시태그가 문자열로 저장되어있는 상태 => 게시글 별로 모든 해시태그를 하나씩 분리)   
dbms = db.DBManager()
if dbms.DBOpen("192.168.0.127", "hashtag", "root", "ezen") == True :
    total_page = GetSliceTotalPage(dbms)
    for page in range(total_page) :
        SliceHash(dbms,page,total_page)
    dbms.CloseQuery()
    #dbms.DBClose()
'''
'''
#2차 정제 db에 연결      
#2차정제(상위12개 태그에 걸리면 안되는 태그들을 제거)  
dbms = db.DBManager()
if dbms.DBOpen("192.168.0.127", "hashtag", "root", "ezen") == True :
    total_page = GetSecondTotalPage(dbms)
    for page in range(total_page) :
        DelStopword(dbms,page,total_page)
    dbms.CloseQuery()
'''
'''
#3차 정제 db에 연결  
#3차정제(지역이 안맞는 경우 제거)      
dbms = db.DBManager()
if dbms.DBOpen("192.168.0.127", "hashtag", "root", "ezen") == True :
    total_page = GetThirdTotalPage(dbms)
    for page in range(total_page) :
        DelDuplicate(dbms,page,total_page)
    dbms.CloseQuery()   
'''
dbms.DBClose()