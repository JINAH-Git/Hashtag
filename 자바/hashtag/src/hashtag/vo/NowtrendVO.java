//실시간 인기 데이터의 자료를 담기위한 VO(Value Object)클래스
package hashtag.vo;

public class NowtrendVO 
{
	String nthashtag;  //해시태그
	String clicktime;  //클릭시간
	String ip;         //아이피
	
	public String getNthashtag() 				{ return nthashtag;           }
	public String getClicktime() 				{ return clicktime; 		  }
	public String getIp()  		 				{ return ip;        		  }
	
	public void setNthashtag(String nthashtag)  { this.nthashtag = nthashtag; }
	public void setClicktime(String clicktime)  { this.clicktime = clicktime; }
	public void setIp(String ip) 			    { this.ip 		 = ip;        }
	
	
}
