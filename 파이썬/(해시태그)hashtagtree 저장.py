import dbmanager as db
import pandas as pd

#문서들을 분석하여 문서내 단어에 대한 데이터프레임을 생성한다.
def BuildWordOfDocs(dbms,keyword) :
    sql  = ""
    sql += "select rhno,rhhashtag,count(rhno) as count "
    sql += "from refinehashtag "
    sql += "where rhregiontag = '" + keyword + "' "
    sql += "and rhrefine = 3 "
    sql += "and rhwdate like '2023.%'"
    sql += "group by rhno,rhhashtag "
    sql += "order by rhno,rhhashtag "
    print(sql)
    
    result    = dbms.OpenQuery(sql)
    prev_rhno = -1
    
    #컬럼 이름 목록을 만든다.
    column_list  = []
    count_list   = []    
    docs_no = 0
    for i in range(len(result)) : 
        print("%d / %d 번째 작업 처리중..." % (i,len(result)))
        token   = result[i]
        rhno    = int(token[0])        
        hashtag = str(token[1])
        count   = float(token[2])         
        if prev_rhno == -1 :
            prev_rhno = rhno 
        #print("%d/%d : %s" % (prev_rhno,rhno,hashtag))
        if prev_rhno != rhno :
            #새로운 문서임                        
            #단어-문서번호 행열을 만든다.
            df = pd.DataFrame([count_list],columns = column_list)            
            #print(df)
            #print("docs_no=>" , docs_no)                            
            #print("-" * 40)            
            if docs_no == 0 :
                all_words =  df
            else:
                all_words = pd.concat([all_words,df])                            
            #print(all_words)
            #print("=" * 40)                            
            docs_no = docs_no + 1
            prev_rhno = rhno
            column_list  = []
            count_list   = []  
        column_list.append(hashtag)  #단어
        count_list.append(count)     #빈도수              
        
    #문서번호로 index를 생성한다.
    all_words.reset_index(inplace=True)
    del all_words["index"]
    
    #NaN을 0으로 변경한다.
    all_words = all_words.fillna(0)
    
    return all_words

#단어간의 상관관계를 구축한다
def BuildCorr(all_words,keyword) :
    print("상관관계 계산중...")
    corr_word = all_words.corr()
    print(corr_word)
    #corr_word.to_csv(keyword + ".csv",encoding="euc-kr")
    
    print("상관관계 계산 완료")
    row_total = corr_word[corr_word.columns[0]].count()
    
    for wordA in corr_word :        
        for row in range(row_total) :
            wordB =  corr_word.index[row]
            if wordA == wordB :
                continue
            Weight = corr_word.iloc[row][wordA]
            sql = "insert into hashtagtree (htregiontag,hashtag1,hashtag2,htweight) values ('" + keyword +"','%s','%s','%f');" % (wordA,wordB,Weight)
            print(sql)
            print(dbms.RunSQL(sql))
    
    return corr_word

#db에 연결
dbms = db.DBManager()
if dbms.DBOpen("192.168.0.127", "hashtag", "root", "ezen") == True :
    #cities = ["#군산카페","#익산카페","#완주카페","#전주카페"] 
    cities = ["#군산카페"] 
    for keyword in cities:
        print(keyword)
        #게시글들을 분석하여 문서내 단어에 대한 데이터프레임을 생성한다.
        all_words = BuildWordOfDocs(dbms,keyword)
        print(all_words)
        #단어간의 상관관계를 구축한다
        corr_word  = BuildCorr(all_words,keyword)

    dbms.CloseQuery()
    dbms.DBClose()
    