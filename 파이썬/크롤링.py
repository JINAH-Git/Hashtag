from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import time
from bs4 import BeautifulSoup
import re
import pandas as pd

# 검색 결과 페이지 
def blog_searching(pageNo,word) :
    url = "https://section.blog.naver.com/Search/Post.naver?pageNo=" + str(200+pageNo) + "&rangeType=ALL&orderBy=sim&startDate=2021-08-01&endDate=2022-07-31&keyword=%23" + word
    return url

# 게시글의 주소 수집
def getUrl(count) :
    for i in range(1,count+1) :
        #검색 결과 페이지 열기
        driver.get(blog_searching(i, word))
        time.sleep(1)
        #HTML 페이지 소스를 받아온다.
        html = driver.page_source
        #주소를 파싱합니다.
        soup = BeautifulSoup(html,"html.parser")
        con = soup.select('div.desc')
        for j in range(len(con)) :
            url = con[j].find('a')['href']
            if url != None :
                item = {'url' : url , 'title' : '' , 'wdate' : '' , 'note' : '' , 'tag' : '' , 'like' : ''}
                data_list.append(item)
        print(str(i)+"페이지 주소 수집 완료!!")      

#불필요한 공백 제거
def no_space(text) :
    text1 = re.sub('&nbsp; | &nbsp; | \n|\t|\r','',text)
    text2 = re.sub('\n\n','',text1)
    return text2

# 게시글의 데이터 수집
def getData() :
    for item in data_list :
        driver.get(item["url"])
        driver.switch_to.frame("mainFrame")
        time.sleep(1)
        html = driver.page_source
        soup = BeautifulSoup(html,"html.parser")
        #제목
        title = soup.find("div",{"class": "se-title-text"})
        if title != None :
            item['title'] = title.text
        #작성일
        wdate = soup.find("span",{"class": "se_publishDate pcol2"})
        if wdate != None :
            item['wdate'] = wdate.text
        #내용
        note = soup.find("div",{"class": "se-main-container"})
        if note != None :
            note = no_space(note.text)
            item['note'] = note
        #해쉬태그
        content = soup.find("div",{"class": "wrap_tag"})
        if content != None :
            tag = re.findall(r'#[^\s#,\\]+',content.text)
            if tag != None :        
                item['tag'] = tag
        #공감
        like = soup.find("em",{"class": "u_cnt"})
        if like != None :
            item['like'] = like.text      
        print(item['title'] + " 데이터 수집 완료!!")        
        
#게시물을 조회할 검색 키워드 입력 요청
word = str(input("검색어를 입력하세요 : "))
count = int(input("수집할 페이지 수 : "))

#데이터를 담을 리스트 생성
data_list = []

#크롬 브라우저 네이버블로그 열기
options = webdriver.ChromeOptions()
user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
options.add_argument("user-agent=" + user_agent)
driver = webdriver.Chrome(service = Service(ChromeDriverManager().install()),options = options)
driver.execute_script('return navigator.userAgent')
#입력한 페이지만큼 주소 수집
getUrl(count)

#주소를 이용해서 데이터 파싱
getData()
 
#pandas를 이용하여 변환후 csv파일로 저장    
df = pd.DataFrame(data_list)
print(df)

saveFileName = word + " 데이터 " + str(count * 7) + "개 수집.csv"
df.to_csv(saveFileName,encoding='utf-8-sig',index=0)

driver.close()

