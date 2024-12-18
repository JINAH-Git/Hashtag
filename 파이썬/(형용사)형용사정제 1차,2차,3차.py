import dbmanager as db
import pymysql
from konlpy.tag import Okt

okt = Okt()

per_page = 5000 #데이터를 500개씩 잘라서 메모리에 올린다.

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

#형태소 분석기 및 오타 수정
def GetWordList(text, posname) :
    words = okt.pos(str(text), stem=True, norm=True) #어간 추출
    word_list = []
    for word_tuple in words :
        word = str(word_tuple[0])  #단어
        pos = str(word_tuple[1])  #품사
        if pos in posname: 
            #품사가 형용사이면...
            word_list.append(str(word))
    return word_list

#1차 형용사를 추출한다.
def AdjSelect(dbms,pageNo,total_page):
    global per_page
    startNo = pageNo * per_page
    endNo   = per_page
    
    job_total = 1
    #데이터를 불러온다.
    sql = "select cdno,cdnote,cdregion,cdwdate from crawlingdata limit %d,%d" % (startNo,endNo)
    try:
        result = dbms.OpenQuery(sql)
    except Exception as e:
        print("SQL 쿼리 실행 오류:", str(e))
        return
    
    adjs = []
    for cdnote in result :
        #print(sql)
        adj   = GetWordList(cdnote,"Adjective")
        adjs.append(adj)
    k = 0
    for i in result :
        print("%d/%d페이지의 %d번째 작업 처리중..." % ((pageNo + 1),total_page,job_total))
        job_total = job_total + 1
        a = i[0]  #게시글관리번호  rano 
        c = i[2]  #지역해시태그명  raregiontag
        d = i[3]  #작성일          rawdate
        test = adjs[k]
        for j in range(len(test)):
            sql  = "insert into refineadjective (rarefine,rano,raadj,raregiontag,rawdate) values "
            sql += "(1,'" + str(a) + "','" + test[j] + "','" + str(c) + "','" + str(d) + "')"
            adjs[0 + 1]
            #print(sql)
            dbms.RunSQL(sql)
        k = k + 1 

#1차 정제 데이터에서 전체 페이지수를 가져온다.        
def GetSecondTotalPage(dbms) :
    global per_page
    sql = "select count(*) as count from refineadjective where rarefine = 1"
    result = dbms.OpenQuery(sql)
    total = int(dbms.GetValue(0,"count"))
    total_page =  total // per_page
    if(total % per_page != 0) :
        total_page = total_page + 1
    return total_page

#2차 불용어를 제거한다.
def Stop_Word(dbms,pageNo,total_page):
    global per_page
    startNo = pageNo * per_page
    endNo   = per_page
    job_total = 1
    sql = "select rano,raadj,raregiontag,rawdate from refineadjective where rarefine = 1 limit %d,%d" % (startNo,endNo)
    result = dbms.OpenQuery(sql)
    #형용사 불용어 사전
    stop_words = ["있다","무리다","어떠하다","없다","보얗다","어느덧다","빨르다","번하"," 같다","밉다","이다","아니다","야하다","그렇다","이렇다","안녕하다","더하다","스럽다","반갑다","다행하다","건강하다","자리다","안되다","이다","같다","어느새다","딱하다","근접하다"]
    words = []
    for adjs in result:
        words.append(list(adjs))
    #형용사 불용어를 제거
    x = 0
    for x in words :
        print("%d/%d페이지의 %d번째 작업 처리중..." % ((pageNo+1),total_page,job_total))
        job_total = job_total + 1
        a = x[0]  #게시글관리번호  rano 
        b = x[1]  #형용사          raadj
        c = x[2]  #지역해시태그명  raregiontag
        d = x[3]  #작성일          rawdate
        #rarefine 정제차수 not in으로 stop_words에 있는 단어들이 포함 된 형용사들은 빼고 불러온다.
        if b not in stop_words:
            try:
                sql  = "insert into refineadjective (rarefine,rano,raadj,raregiontag,rawdate) values "
                sql += "(2," + str(a) + ",'" + b + "','" + c + "','" + d + "')"
                dbms.RunSQL(sql)
            except Exception as e:
                print("오류 발생: {str(e)}")

#2차 정제 데이터에서 전체 페이지수를 가져온다.    
def GetThirdTotalPage(dbms) :
    global per_page
    sql = "select count(*) as count from (select rano,raadj from refineadjective where rarefine = 2 group by rano, raadj) as a"   #42002개..
    #sql = "select count(*) as count from refineadjective where rarefine = 2"
    result = dbms.OpenQuery(sql)
    total = int(dbms.GetValue(0,"count"))
    total_page =  total // per_page
    if(total % per_page != 0) :
        total_page = total_page + 1
    print("total : " ,total)
    print("total_page : ",total_page)
    return total_page

#3차 형용사를 카운트해준다.
def AdjCount(dbms,pageNo,total_page):
    global per_page
    startNo = pageNo * per_page
    endNo   = per_page
    job_total = 1
    
    count_sql  = "select rano, raadj, raregiontag, rawdate, count(*) as racount from refineadjective "
    count_sql += "where rarefine = 2 group by rano, raadj,raregiontag,rawdate limit %d,%d" % (startNo,endNo)
    #SQL실행한다.
    result = dbms.OpenQuery(count_sql)
    for m in result :
        print("%d/%d페이지의 %d번째 작업 처리중..." % ((pageNo + 1),total_page,job_total))
        job_total = job_total + 1
        
        a = m[0]  #게시글관리번호  rano 
        b = m[1]  #형용사          raadj
        c = m[2]  #지역해시태그명  raregiontag
        d = m[3]  #작성일          rawdate
        e = m[4]  #빈도수
        try:
            sql  = "insert into refineadjective (rarefine,rano,raadj,raregiontag,rawdate,racount) values "
            sql += "(3," + str(a) + ",'" + b + "','" + c + "','" + d + "','" + str(e) +"')"
            #print(sql)
            dbms.RunSQL(sql)
        except Exception as e:
            print("오류 발생: {str(e)}")
            return False


'''
#1차 정제 형용사 추출
dbms = db.DBManager()
if dbms.DBOpen("192.168.0.127", "hashtag", "root", "ezen") == True :
    total_page = GetSliceTotalPage(dbms)
    for page in range(total_page) :
        AdjSelect(dbms,page,total_page)
    dbms.CloseQuery()
'''
'''
#2차 정제 불용어 제거
dbms = db.DBManager()
if dbms.DBOpen("192.168.0.127", "hashtag", "root", "ezen") == True :
    total_page = GetSecondTotalPage(dbms)
    for page in range(total_page) :
        Stop_Word(dbms,page,total_page)
    dbms.CloseQuery()
'''

#3차 정제 형용사 빈도수 계산, 반복글 X
dbms = db.DBManager()
if dbms.DBOpen("192.168.0.127", "hashtag", "root", "ezen") == True :
    total_page = GetThirdTotalPage(dbms)
    for page in range(total_page) :
        AdjCount(dbms,page,total_page)
    dbms.CloseQuery()



dbms.DBClose()