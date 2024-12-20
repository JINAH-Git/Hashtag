//크롤링한 데이터의 자료를 담기위한 VO(Value Object)클래스
//정제 차수 없는 이유:1차, 2차 정제하고 DB에 올림
package hashtag.vo;

public class CrawlingdataVO 
{
	int cdno;              //게시글관리번호
	String cdblogaddress;  //블로그 주소
	String cdtitle;		   //제목
	String cdwdate;		   //작성일
	String cdnote;		   //내용
	String cdhashtag;	   //해시태그명
	String cdheart;	       //공감수
	String cdregion;	   //지역해시태그명 
	
	public int    getCdno() 							{ return cdno;                        }
	public String getCdblogaddress() 					{ return cdblogaddress;               }
	public String getCdtitle() 							{ return cdtitle;                     }
	public String getCdwdate() 							{ return cdwdate;                     }
	public String getCdnote() 							{ return cdnote;                      }
	public String getCdhashtag() 						{ return cdhashtag;                   }
	public String getCdheart() 							{ return cdheart;                     }
	public String getCdregion() 						{ return cdregion;                    }
	
	public void setCdno(int cdno) 					    { this.cdno 		 = cdno;		  }
	public void setCdblogaddress(String cdblogaddress) 	{ this.cdblogaddress = cdblogaddress; }
	public void setCdtitle(String cdtitle) 				{ this.cdtitle 		 = cdtitle;       }
	public void setCdwdate(String cdwdate) 				{ this.cdwdate 		 = cdwdate;       }
	public void setCdnote(String cdnote) 				{ this.cdnote 		 = cdnote;        }
	public void setCdhashtag(String cdhashtag) 			{ this.cdhashtag 	 = cdhashtag;     }
	public void setCdheart(String cdheart) 				{ this.cdheart 		 = cdheart;       }
	public void setCdregion(String cdregion) 			{ this.cdregion 	 = cdregion;      }
	
	
	
}
