//형용사정제  데이터의 자료를 담기위한 VO(Value Object)클래스
package hashtag.vo;

public class RefineadjectiveVO 
{
	String ratagno;		//블로그별형용사일련번호      
	String rarefine;	//정제차수                      
	String rano;		//게시글관리번호            
	String raadj;		//형용사                       
	String raregiontag;	//지역해시태그명           
	String rawdate;		//작성일                         
	String racount;		//게시글별건수     
	String adsort;      //감성분석
	

	public String getRatagno() 						{ return ratagno;				  	  }
	public String getRarefine() 					{ return rarefine;				  	  }
	public String getRano() 						{ return rano;					  	  }
	public String getRaadj() 						{ return raadj;					  	  }
	public String getRaregiontag() 					{ return raregiontag;			  	  }
	public String getRawdate() 						{ return rawdate;				  	  }
	public String getRacount() 						{ return racount;				  	  }
	public String getAdsort() 						{ return adsort;					  }
	
	
	public void setRatagno(String ratagno) 			{ this.ratagno 	   = ratagno; 		  }
	public void setRarefine(String rarefine) 		{ this.rarefine    = rarefine;		  }
	public void setRano(String rano) 				{ this.rano 	   = rano;			  }
	public void setRaadj(String raadj) 				{ this.raadj 	   = raadj;			  }
	public void setRaregiontag(String raregiontag) 	{ this.raregiontag = raregiontag; 	  }
	public void setRawdate(String rawdate) 			{ this.rawdate 	   = rawdate;		  }
	public void setRacount(String racount) 			{ this.racount 	   = racount;		  }
	public void setAdsort(String adsort) 			{ this.adsort 	   = adsort;		  }	

		
}
