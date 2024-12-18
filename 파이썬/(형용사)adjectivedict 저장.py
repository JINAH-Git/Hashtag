import dbmanager as db

#db에 연결
dbms = db.DBManager()
if dbms.DBOpen("192.168.0.127", "hashtag", "root", "ezen") == True :
    sql = "select raadj from refineadjective where rarefine = 3"
    result = dbms.OpenQuery(sql)
    print(result)
    print("-" * 100)
    for i in result:
        word = i[0]
        sql = "insert into adjectivedict (adadjective) values ('" + word +"')"
        #dbms.RunSQL(sql)
        print(word,"의 처리결과는 ",dbms.RunSQL(sql)," 입니다.")
        
        '''
        sql = "select adadjective from adjectivedict"
        dictionary = dbms.OpenQuery(sql)
        print(dictionary)
        print("=" * 100)
        if word not in dictionary:
            sql = "insert into adjectivedict (adadjective) values ('" + i[0] +"')"
            print(sql)
            #dbms.RunSQL(sql) 
            #print(dbms.RunSQL(sql))
        '''

dbms.DBClose()
#print(total_page[10][0])