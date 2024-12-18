import pandas as pd


#태그가 비어있는 행 제거
def delete_nulltag(data) :
    idx = data[data['tag'] == "[]"].index
    data.drop(idx,inplace=True)
    return data

#제목에서 결측치(null값)인 행 제거
def delete_nulltitle(data) :
    data = data.dropna(subset='title')
    return data

#광고성이나 관련없는 게시글 제거
def delete_ad(data) :
    for i in range(len(ad_word)) :
        idx = data[data['tag'].str.contains(ad_word[i])].index
        data.drop(idx,inplace=True)
    return data


file_path = '익산카페 데이터 22,23년.csv'
cafe_data = pd.read_csv(file_path,encoding='cp949',thousands = ',')
cafe_data.info()
print("=" * 40)

#태그가 비어있는 행 제거
cafe_data = delete_nulltag(cafe_data)

#제목이 비어있는 행 제거
cafe_data = delete_nulltitle(cafe_data)

#중복된 행 제거
cafe_data = cafe_data.drop_duplicates()

cafe_data.info()
print("=" * 40)

#광고성이나 관련없는 게시글 제거,프랜차이즈 카페 글 제거
ad_word = ['카페창업kyc','카페창업KYC','전주커피머신스케일큐어','주간일기챌린지','전주커피바리스타학원kyc','카페매출올리는방법','전주바리스타학원MBA','자판기',
           '카페창업컨설팅','전주커피바리스타학원KYC','전주꿈공스터디카페','꿈꾸는공간스터디카페','전북대스파르타','소자본카페창업','샌드위치클래스','포엠코퍼레이션',
           '쿠키클래스','카페폐업','전주바리스타자격증교육','카페컨설팅','픽스잇커피','전주카페임대','전주카페창업','가스난로','다비드컴퍼니','체험단','전북투어패스',
           '매매','순위','캠핑장','미스터션샤인','식기세척기','서귀포','임대','자격증','#익산포스업체','광한루','네일','창업컨설팅','창업일기','목수','에어비앤비',
           '스타벅스','이디야','빽다방','메가커피','투썸플레이스','커피빈','파스쿠찌','더벤티','할리스','엔제리너스','카페베네','플루800',"FLUE800",'달콤커피',
           '드롭탑','더카페','커피에반하다','컴포즈커피','폴바셋','감성커피','하삼동커피','탐앤탐스','매머드커피','커피명가','커피로드뷰','캔버스','커피스미스',
           '커피나무','셀렉토커피','커피마마','만랩커피','빈스빈스','토프레소','더착한커피','전광수커피','그라찌에','카페보니또','옐로우팜','와플대학','커피니']
cafe_data = delete_ad(cafe_data)

cafe_data.info()
print("=" * 40)

saveFileName = "(정제)" + file_path
cafe_data.to_csv(saveFileName,encoding='cp949',index=0)


import pymysql

#데이터베이스 연결
con = pymysql.connect(host="192.168.0.127", port=3306, 
                      user="root", passwd="ezen",
                      db="hashtag", charset="utf8")
cursor = con.cursor()
con.commit()


df = pd.read_csv(saveFileName,encoding="cp949",thousands=",");

#중복된 url 제거
df = df.drop_duplicates(subset='url',keep='first',ignore_index=True)
#print(df)

#nan을 none로 바꾼다.(python의 nan을 mysql에서 못 읽기 때문..)
df = df.where(pd.notnull(df), None)

#공감수가 비어있을때 0으로 설정한다.
df = df.fillna(0)

df['like'] = df['like'].astype("int64")
#지역이름만 추출
regiontag = "#" + file_path[:4] 

for i in range(len(df)) :
    url = df['url'][i]
    title = df['title'][i]
    wdate = df['wdate'][i]
    note = df['note'][i]
    tag = df['tag'][i]
    like = df['like'][i]

    sql = "insert into crawlingdata(cdblogaddress,cdtitle,cdwdate,cdnote,cdhashtag,cdheart,cdregion) values "
    sql = sql + "(%s,%s,%s,%s,%s,%s,%s)"
    cursor.execute(sql,(url,title,wdate,note,tag,like,regiontag))

con.commit()
con.close()

print(saveFileName,"db에 저장 완료",sep=":")
