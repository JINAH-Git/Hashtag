//ũ�Ѹ��� �������� �ڷḦ ������� VO(Value Object)Ŭ����
//���� ���� ���� ����:1��, 2�� �����ϰ� DB�� �ø�
package hashtag.vo;

public class DataVO 
{
	int    dno;          //�Խñ۰�����ȣ
	String blogaddress;  //��α� �ּ�
	String title;		 //����
	String wdate;		 //�ۼ���
	String note;		 //����
	String hashtag;	     //�ؽ��±׸�
	String heart;	     //������
	String region;	     //�����ؽ��±׸� 
	
	
	public int getDno() 							{ return dno;         }
	public String getBlogaddress() 					{ return blogaddress; }
	public String getTitle() 						{ return title;       }
	public String getWdate() 						{ return wdate;       }
	public String getNote() 						{ return note;        }
	public String getHashtag() 						{ return hashtag;     }
	public String getHeart() 						{ return heart;       }
	public String getRegion() 						{ return region;      }
	
	
	public void setDno(int dno) 					{ this.dno 		   = dno;		  }
	public void setBlogaddress(String blogaddress) 	{ this.blogaddress = blogaddress; }
	public void setTitle(String title) 				{ this.title 	   = title;       }
	public void setWdate(String wdate) 				{ this.wdate 	   = wdate;       }
	public void setNote(String note) 				{ this.note 	   = note;        }
	public void setHashtag(String hashtag) 			{ this.hashtag 	   = hashtag;     }
	public void setHeart(String heart) 				{ this.heart 	   = heart;       }
	public void setRegion(String region) 			{ this.region 	   = region;      }
	
	
	
}
