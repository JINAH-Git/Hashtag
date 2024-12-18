//지역별해시태그 데이터의 자료를 담기위한 VO(Value Object)클래스
package hashtag.vo;

public class CityhashtagVO 
{
	String chno;		//해시고유번호               
	String chregiontag;	//지역해시태그명             
	String chreltag;	//관련해시태그명              
	String chcount;		//빈도수     
	
	public String getChno() 						{ return chno;					  }
	public String getChregiontag() 					{ return chregiontag;			  }
	public String getChreltag() 					{ return chreltag;				  }
	public String getChcount() 						{ return chcount; 				  }
	public void setChno(String chno) 				{ this.chno 	   = chno;		  }
	public void setChregiontag(String chregiontag) 	{ this.chregiontag = chregiontag; }
	public void setChreltag(String chreltag) 		{ this.chreltag    = chreltag;	  }
	public void setChcount(String chcount) 			{ this.chcount     = chcount;	  }
	
	
}
