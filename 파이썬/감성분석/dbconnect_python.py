import dbmanager as db
from joblib import load
import adjfinal as ad
import logging


dbms = db.DBManager()
    
if not dbms.DBOpen("192.168.0.127","hashtag", "root", "ezen"):
    print("Error")
else :
    print("OK")
    
    # 모델 학습시킨 파일 불러오기
    model_filename = './data/logistic_regression_model.joblib'
    model = load(model_filename)
    
    # DB에서 형용사 사전 읽어오기
    sql = "select * from adjectivedict"
    sql_result = dbms.OpenQuery(sql)
    
    # sqlresult가 tuple 타입, 형용사만 list로 변환하기 
    adjective_list = [i[0].lower() for i in sql_result]
    
    # 예측
    adjective_vetor = ad.vectorizer.transform(adjective_list) # 형용사 vetor화 시키기
    prediction_result = model.predict(adjective_vetor) # 변환된 형용사로 예측하여 결과 감성분류
    
    # 감성분류를 "P", "N", "M"으로 매핑
    mapping = {
        "긍정": "P",
        "부정": "N",
        "중립": "M"
    }
    
    # 감성분류 정해진 값으로 변환
    mapped_prediction = [mapping[pred] for pred in prediction_result]
    logging.debug(mapped_prediction)
    print(mapped_prediction)
    
    # DB에 업데이트 하기
    for adj, adsort in zip(adjective_list, mapped_prediction):
        if adsort != 'M':
            update_sql = "update adjectivedict set adsort = '{}' where adadjective = '{}'".format(adsort, adj)
            print(update_sql)
            if not dbms.RunSQL(update_sql):
                print(f'Failed to upadate: {adj}, {adsort}')
                #logging.error(f'Failed to upadate: {adj}, {adsort}')
    print("DB 업데이트 성공")
        
    #  DB에서 업데이트 된 내용 확인
    check_sql = "select * from adjectivedict"
    check_result = dbms.OpenQuery(check_sql)
    for row in check_result:
        print(row)
        #logging.info(row)

    dbms.CloseQuery()
dbms.DBClose()
