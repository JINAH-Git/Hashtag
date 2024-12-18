import dbmanager as db

per_page = 5000 #데이터를 5000개씩 잘라서 메모리에 올린다.

#튜플을 리스트로 변환하기
def TupletoList(result):
    hashtags = []
    for data in result:
        hashtags.append(list(data))
    return hashtags

#데이터를 페이징한다. refinehashtag의 정제차수가 3이고, keyword에 해당하는 해시태그별로 groupby를 해서 각각 해시태그별로 개수를 센다
#Group by로 묶인 해시태그의 개수를 센다.(전제 데이터 개수를 센다.)
def GetSliceTotalPage(dbms,keyword) :
    global per_page
    sql = "select count(*) as count from (select rhhashtag from refinehashtag where rhregiontag = '" + keyword + "' and rhrefine = 3 group by rhhashtag) A"
    print(sql)
    result = dbms.OpenQuery(sql)
    total = int(dbms.GetValue(0,"count"))
    total_page =  total // per_page
    if(total % per_page != 0) :
        total_page = total_page + 1
    return total_page

#refinehashtag의 정제차수가 3이고, keyword에 해당하는 해시태그별로 groupby를 해서 각각 해시태그별로 개수를 센다
#해시태그별로 빈도수를 센뒤에 cityhashtag에 저장한다.
def CheckOption(dbms,pageNo,total_page,keyword) : 
    global per_page
    startNo = pageNo * per_page
    endNo   = per_page
    job_total = 1
    
    #불러오는 데이터에 개수 제한을 준다.
    sql = "select rhregiontag,rhhashtag,count(*) as count from refinehashtag where rhregiontag = '" + keyword + "' and rhrefine = 3 group by rhhashtag order by count(*) desc limit %d,%d" % (startNo,endNo)
    result = dbms.OpenQuery(sql)       #튜플안의 튜플 형식으로 반환됨.
    hashtags = TupletoList(result)
    
    #cityhashtag에 데이터를 저장한다.
    for i in hashtags :
        print("%d/%d페이지의 %d번째 작업 처리중..." % ((pageNo+1),total_page,job_total))
        job_total = job_total + 1   
        
        a = i[0]  #지역해시태그명  rhregiontag 
        b = i[1]  #해시태그명     rhhashtag
        c = i[2]  #빈도수         count

        sql  = "insert into cityhashtag (chregiontag,chreltag,chcount) values "
        sql += "('" + a + "','" + b + "','" + str(c) + "')"
        #print(sql)
        dbms.RunSQL(sql)

#db에 연결
dbms = db.DBManager()
if dbms.DBOpen("192.168.0.127", "hashtag", "root", "ezen") == True :
    keyword = "#익산카페"
    total_page = GetSliceTotalPage(dbms,keyword)
    for page in range(total_page) :
        CheckOption(dbms,page,total_page,keyword)
    dbms.CloseQuery()
    #dbms.DBClose()
