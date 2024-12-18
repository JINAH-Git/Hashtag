import pandas as pd # 파일 데이터프레임으로 읽어오기
from konlpy.tag import Okt

# 감성분류 훈련,테스트 할 데이터 가져오기
df = pd.read_csv("./data/형용사_train_test.csv", encoding="cp949")

# 형용사, 감성분류 list 변환
test1 = df[['형용사','감성분류']].values.tolist()

# 형태소 추출 객체화하기
okt = Okt()

#형태소 분석기 및 오타 수
def GetWordList(text,foremotion, posname) :
    words = okt.pos(str(text), stem=True, norm=True) #어간 추출
    wordword = list(words[0])
    word = str(wordword[0])   
    pos = str(wordword[1])    
    
    if pos in posname: 
        return [str(word),foremotion]
    return False

adjs = []
for i in range(len(test1)):
    word = test1[i] 
    foradj = word[0]       #형용사
    foremotion = word[1]   #감성분석    
    adj = GetWordList(foradj,foremotion,"Adjective")
    if adj != False:    
        #print(adj)
        adjs.append(adj)
    
# 불용어 제거하기
def MakeStopWord(list_result, stop_word):
    final_result = []
    x = []
    y = []
    for i in list_result:
        a = i[0] #형용사
        b = i[1] #감성분류
        if a not in stop_word:
            final_result.append([a,b])
            x.append(a)
            y.append(b)
    return final_result , x, y
  

# 불용어 제거해주기 
stop_word = ["설레", "있다", "미", "삐죽", "시르다", "안남다", 
             "앙이다", "이쁘", "희", "그럴", "무리다","어떠하다","없다",
             "보얗다","어느덧다","빨르다","번하","같다","밉다","이다","아니다",
             "야하다","그렇다","이렇다","안녕하다","더하다","스럽다","반갑다",
             "다행하다","건강하다","자리다","안되다","어느새다","딱하다","근접하다"]

# ==================== 함수 호출 ===========================================
stopword_result,X, y = MakeStopWord(adjs,stop_word )

# 최종 정제된 형용사 저장
df = pd.DataFrame(stopword_result,columns=["형용사", "감성분류"])       
df = df.sort_values(by="형용사")
df = df.drop_duplicates(subset="형용사", ignore_index=True)
df.to_csv("./data/형용사_최종정제된데이터.csv",encoding="cp949", index=0) 