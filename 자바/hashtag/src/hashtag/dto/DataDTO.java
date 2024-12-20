//크롤링한 데이터 정보를 모델(Model)로 부터 처리하기 위한 DTO클래스(Data Transfer Object)
package hashtag.dto;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Map;

import hashtag.dao.*;
import hashtag.vo.*;

public class DataDTO extends DBManager
{	
	//조건에 맞는 포스터 개수 구하기
	public int GetTotalPost(String region,String hashtag)
	{
		int totalPost = 0;
		this.DBOpen();
		String sql = "";
		sql  = "select count(*) as total from crawlingdata ";
		sql += "where cdregion = '" + region + "' ";
		sql += "and cdhashtag like '%''" + hashtag + "''%' ";
		this.RunSelect(sql);
		//System.out.println(sql);
		if(this.Next() == true)
		{
			totalPost = Integer.parseInt(this.getValue("total"));
		}
		this.DBClose();
		
		return totalPost;		
	}
	
	//작성일에 해당하는 언급량 수 구하기
	public ArrayList<RefinehashtagVO> GetMention(String region,String hashtag)
	{
		ArrayList<RefinehashtagVO> list = new ArrayList<RefinehashtagVO>();
		RefinehashtagVO vo = null;
		
		this.DBOpen();
		String sql = "";
		sql  = "select count(*) as mentionamount,date_format(str_to_date(Replace(substr(rhwdate,1,12),'.',''),'%Y%m%d'),'%Y-%m') as rhwdate ";
		sql += "from refinehashtag where rhrefine = '3' and rhregiontag = '" + region + "' and rhhashtag = '" + hashtag + "' ";
		sql += "group by date_format(str_to_date(Replace(substr(rhwdate,1,12),'.',''),'%Y%m%d'),'%Y-%m') ";
		sql += "order by rhwdate ";
		this.RunSelect(sql);
		//System.out.println(sql);
		while(this.Next() == true)
		{
			vo = new RefinehashtagVO();
			vo.setRhregiontag(region);
			vo.setRhhashtag(hashtag);
			vo.setMetionamount(this.getValue("mentionamount"));
			vo.setYearmonth(this.getValue("rhwdate").replace(".","").replace(" ","-"));
			list.add(vo);
		}				
		this.DBClose();
		
		return list;	
	}
	
	//공감수 높은 글 2개 출력하기
	public ArrayList<CrawlingdataVO> GetHeartCnt(String region,String hashtag)
	{
		ArrayList<CrawlingdataVO> list = new ArrayList<CrawlingdataVO>();
		CrawlingdataVO vo = null;
		
		this.DBOpen();
		String sql = "";
		sql  = "select cdno,cdtitle,cdnote,cdblogaddress,cdheart from crawlingdata ";
		sql += "where cdregion = '" + region + "' ";
		sql += "and cdhashtag like '%''" + hashtag + "''%' ";
		sql += "order by cdheart * 1 desc ";
		sql += "limit 0,2 ";
		this.RunSelect(sql);
		//System.out.println(sql);
		while(this.Next() == true)
		{
			vo = new CrawlingdataVO();
			vo.setCdno(Integer.parseInt(this.getValue("cdno")));
			vo.setCdtitle(this.getValue("cdtitle"));
			vo.setCdnote(this.getValue("cdnote"));
			vo.setCdblogaddress(this.getValue("cdblogaddress"));
			vo.setCdheart(this.getValue("cdheart"));
			list.add(vo);
		}
		this.DBClose();
		
		return list;		
	}
	
	//#(지역명)카페에 관한 연관태그 12개 출력하기
	public ArrayList<CityhashtagVO> GetRelatedTag(String region)
	{
		ArrayList<CityhashtagVO> list = new ArrayList<CityhashtagVO>();
		CityhashtagVO vo = null;
		this.DBOpen();
		String sql = "";
		sql  = "select chno,chreltag from cityhashtag ";
		sql += "where chregiontag = '" + region + "' ";
		sql += "order by chcount * 1 desc limit 1,12 ";
		this.RunSelect(sql);
		//System.out.println(sql);
		while(this.Next() == true)
		{
			vo = new CityhashtagVO();
			vo.setChno(this.getValue("chno"));
			vo.setChreltag(this.getValue("chreltag"));
			list.add(vo);
		}	
		this.DBClose();
		
		return list;
	}
	
	//해시태그 트리 연관 5개 뽑기 
	public Map<String,ArrayList<String>> GetRelTags(String region,String hashtag1)
	{
		Map<String,ArrayList<String>> listMap = new HashMap<>();
		ArrayList<String> valueList = new ArrayList<>();
		
		this.DBOpen();
		String sql = "";
		//해당하는 태그(root)에 맞는 가장 높은 연관태그 5개 선정(child)
		sql  = "select hashtag2 from hashtagtree ";
		sql += "where htregiontag = '" + region + "' ";
		sql += "and hashtag1 = '" + hashtag1 + "' ";
		sql += "order by htweight desc ";
		sql += "limit 5";
		System.out.println(sql);
		this.RunSelect(sql);

		while(this.Next() == true)
		{
			listMap.put(this.getValue("hashtag2"),valueList);
		}
		System.out.println(valueList);
		for(HashMap.Entry<String,ArrayList<String>> entry : listMap.entrySet())
		{
			System.out.println(entry.getKey());
			System.out.println("===============================");
			//child의 하위 연관태그 5개선정 (grandchild)
			sql  = "select hashtag1 from hashtagtree ";
			sql += "where htregiontag = '" + region + "' ";
			sql += "and hashtag2 = '" + entry.getKey() + "' ";
			sql += "order by htweight desc ";
			sql += "limit 5";
			System.out.println(sql);
			this.RunSelect(sql);		
			valueList = new ArrayList<String>();
			while(this.Next() == true)
			{
				System.out.println(this.getValue("hashtag1"));
				valueList.add(this.getValue("hashtag1"));
				listMap.put(entry.getKey(),valueList);
			}			
			System.out.println("===============================");
		}	
		
		return listMap;
	}
	
	//실시간 인기해시태그 5개 출력하기
	public ArrayList<CityhashtagVO> GetNowTrend()
	{
		ArrayList<CityhashtagVO> list = new ArrayList<CityhashtagVO>();
		CityhashtagVO vo = null;
		this.DBOpen();
		String sql = "";
		sql  = "select count(ntno) as clickcnt,(select chregiontag from cityhashtag where chno = ntno) as region ";
		sql += ",(select chreltag from cityhashtag where chno = ntno) as hashtag from nowtrend ";
		sql += "where ntclick BETWEEN DATE_ADD(NOW(), INTERVAL -1 hour ) AND NOW() ";
		sql += "group by ntno order by clickcnt desc limit 0,5 ";
		this.RunSelect(sql);
		//System.out.println(sql);
		while(this.Next() == true)
		{
			vo = new CityhashtagVO();
			vo.setChcount(this.getValue("clickcnt"));
			vo.setChregiontag(this.getValue("region"));
			vo.setChreltag(this.getValue("hashtag"));
			list.add(vo);
		}
		this.DBClose();
		
		return list;
	}
	
	//감성분석(긍,부정 확인)
	public ArrayList<RefineadjectiveVO> GetSentimentAnalysis(String region,String date)
	{
		ArrayList<RefineadjectiveVO> list = new ArrayList<RefineadjectiveVO>();
		RefineadjectiveVO vo = null;
		this.DBOpen();
		String sql = "";
		sql  = "select raadj,sum(racount) as total,(select adsort from adjectivedict where adadjective = raadj) as adsort from refineadjective ";
		sql += "where rarefine = '3' and raregiontag = '" + region + "' ";
		sql += "and str_to_date(Replace(substr(rawdate,1,12),'.',''),'%Y%m%d') like '%" + date + "%' ";
		sql += "group by raadj order by total desc limit 0,10 ";
		this.RunSelect(sql);
		//System.out.println(sql);
		while(this.Next() == true)
		{
			vo = new RefineadjectiveVO();
			vo.setRaadj(this.getValue("raadj"));
			vo.setRacount(this.getValue("total").replace(".0",""));
			if(this.getValue("adsort").equals("P"))
			{
				vo.setAdsort("긍정");
			}else if(this.getValue("adsort").equals("N"))
			{
				vo.setAdsort("부정");
			}else
			{
				vo.setAdsort("중립");
			}
		
			list.add(vo);
		}
		this.DBClose();
		
		return list;	
	}
}
