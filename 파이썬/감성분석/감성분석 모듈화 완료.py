from konlpy.tag import Okt
import pandas as pd # 파일 데이터프레임으로 읽어오기
from sklearn.model_selection import train_test_split, StratifiedKFold, cross_val_score
from sklearn.naive_bayes import MultinomialNB # 다항분포 나이브 베이즈 모델
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score #정확도 계산
from joblib import dump # 모델 저장
from joblib import load
from sklearn.feature_extraction.text import TfidfVectorizer
import dbmanager as db
import adjfinal as ad
import logging


# 감성분석 훈련,테스트 전체 데이터 가져오기
def OpenFile(filename) :
    df = pd.read_csv(filename, encoding="cp949")
    data = df[['형용사','감성분류']].values.tolist()
    return data

#형태소 분석기 및 오타 수정
def GetWordList(text,foremotion, posname) :
    okt = Okt()    
    words = okt.pos(str(text), stem=True, norm=True) 
    wordword = list(words[0])
    word = str(wordword[0])  
    pos = str(wordword[1])  
    if pos in posname: 
        return [str(word),foremotion]
    return False

#형용사만 저장한다.
def GetAdjs(data):
    adjs = []
    for i in range(len(data)):
        word = data[i] 
        foradj = word[0]       #형용사
        foremotion = word[1]   #감성분석    
        adj = GetWordList(foradj,foremotion,"Adjective")
        if adj != False:    
            adjs.append(adj)
    return adjs

# 불용어 제거하기
def MakeStopWord(list_result, stop_word):
    final_result = []
    x = []
    y = []
    for i in list_result:
        a = i[0]    #형용사
        b = i[1]    #감성분류
        if a not in stop_word:
            final_result.append([a,b])
            x.append(a)
            y.append(b)
    return final_result , x, y

# 테스트셋 형용사 불용어
stop_word = ["설레", "있다", "미", "삐죽", "시르다", "안남다", "앙이다", 
             "이쁘", "희", "그럴", "무리다","어떠하다","없다","보얗다",
             "어느덧다","빨르다","번하","같다","밉다","이다","아니다","야하다",
             "그렇다","이렇다","안녕하다","더하다","스럽다","반갑다","다행하다",
             "건강하다","자리다","안되다","어느새다","딱하다","근접하다"]

#======================모델 학습 ====================
def VectoSplit(X,y) :
    # TF-IDF 벡터라이저 초기화
    vectorizer = TfidfVectorizer()
    # 형용사 데이터에 벡터라이저 적용
    X_tfidf = vectorizer.fit_transform(X)
    print("X_tfidf: ", X_tfidf.shape)
    
    # 데이터 분할: 훈련 세트와 테스트 세트로 나누기
    X_train, X_test, y_train, y_test = train_test_split(X_tfidf, y, 
                                            test_size=0.1, random_state=1234)
    
    print('X 훈련 데이터 shape:',X_train)
    print(X_train.shape)

    
    # 클래스 가중치 계산
    class_weights = {
        '부정': 1,
        '긍정': 624 / 443,
        '중립': 624 / 183
    }
    
    # 모델 선택 - 나이브 베이즈 모델
    model = MultinomialNB(alpha=0.5)
    
    # Logistic Regression 교차 검증( 머신러닝 모델의 성능을 평가)
    model = LogisticRegression(class_weight=class_weights, max_iter=1000)
    skfold = StratifiedKFold(n_splits=5, shuffle=True, random_state=1234)
    scores = cross_val_score(model, X_tfidf, y, cv=skfold, scoring='accuracy')
    
    print("교차 검증 점수:", scores)
    print("교차 검증 점수 평균 정확도: {:.4f}".format(scores.mean()))
    
    return X_train, X_test, y_train, y_test, model 

def ModelStudy(X_train, X_test, y_train, y_test, model):
    # 모델 학습
    model.fit(X_train, y_train)
    
    # 모델 검증
    print("테스트 데이터 점수: {:.4f}".format(model.score(X_test, y_test)))
    
    # 예측
    y_pred = model.predict(X_test)
    
    # 예측 정확도
    accuracy = accuracy_score(y_test, y_pred)
    print("예측 정확도: {:.2f}%".format(accuracy * 100))
    
    # 모델 저장
    model_filename = './data/logistic_regression_model.joblib'
    dump(model, model_filename)
    return accuracy

#실제 db에 있는 형용사 긍부정 예측하기
def PredictDB(filename):
    model_filename = filename
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
                return False
            elif():
                print("DB 업데이트 성공")
    return True

#====================== 함수 호출 ========================
data = OpenFile("./data/형용사_train_test.csv")
adjs = GetAdjs(data)
stopword_result,X, y = MakeStopWord(adjs,stop_word)

X_train, X_test, y_train, y_test, model = VectoSplit(X,y)
print(X_train)

X_train, X_test, y_train, y_test, model = VectoSplit(X,y)
accuracy = ModelStudy(X_train, X_test, y_train, y_test, model)

#===================== DB연결해서 실제 데이터 긍부정 분류========================
dbms = db.DBManager()
    
if not dbms.DBOpen("192.168.0.127","hashtag", "root", "ezen"):
    print("Error")
else :
    print("OK")
    #학습시킨 모델 불러와서 db 형용사 예측하기
    if PredictDB("./data/logistic_regression_model.joblib") == True:
        # DB에 업데이트가 잘 된 경우 업데이트 된 내용 확인
        check_sql = "select * from adjectivedict"
        check_result = dbms.OpenQuery(check_sql)
        for row in check_result:
            print(row)

dbms.CloseQuery()
dbms.DBClose()
