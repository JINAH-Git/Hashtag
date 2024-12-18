<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="hashtag.dto.*" %>
<%@ page import="hashtag.vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%
String region = request.getParameter("region");
String date   = request.getParameter("date");
String direct = request.getParameter("direction");

if(region == null || date == null)
{
	response.sendRedirect("index.jsp");
	return;
}

String[] datas = {"2021-08","2021-09","2021-10","2021-11","2021-12",
				  "2022-01","2022-02","2022-03","2022-04","2022-05","2022-06","2022-07","2022-08","2022-09","2022-10","2022-11","2022-12",
				  "2023-01","2023-02","2023-03","2023-04","2023-05","2023-06","2023-07","2023-08"};
List<String> dateList = new ArrayList<>(Arrays.asList(datas));
if(!region.equals("#전주카페")) dateList.remove("2023-08");
int arrListSize = dateList.size();
datas = dateList.toArray(new String[arrListSize]);

DataDTO dto = null;
String json = null;
ArrayList<RefineadjectiveVO> list = null;
JSONArray arr = null;
JSONObject data = null;
JSONObject data2 = null;
JSONObject word = null;

try
{
	for(int i = 0; i < datas.length; i++)
	{
		//왼쪽 화살표일때 
		if(datas[i].equals(date)  && direct.equals("L"))
		{
			date = datas[i-1];
			direct = "end";
			dto = new DataDTO();
			list = dto.GetSentimentAnalysis(region,date);
			arr = new JSONArray();
			for(int j = 0; j < list.size(); j++)
			{
				data = new JSONObject();
				data.put("no",j+1);
				data.put("name",list.get(j).getRaadj());
				data.put("emot",list.get(j).getAdsort());
				data.put("cnt",list.get(j).getRacount());
				arr.add(data);
			}
			//최종적으로 word오브젝트에 JSON배열 저장
			word = new JSONObject();
			word.put("word",arr);

			data2 = new JSONObject();
			data2.put("date", date);
			word.put("date",data2);
			//파싱할 데이터 저장
			json = word.toJSONString();
			//테스트용 출력
			out.println(json);	
		}
		if(datas[i].equals(date) && direct.equals("R"))
		{
			date = datas[i+1];
			direct = "end";
			dto = new DataDTO();
			list = dto.GetSentimentAnalysis(region,date);
			arr = new JSONArray();
			for(int j = 0; j < list.size(); j++)
			{
				data = new JSONObject();
				data.put("no",j+1);
				data.put("name",list.get(j).getRaadj());
				data.put("emot",list.get(j).getAdsort());
				data.put("cnt",list.get(j).getRacount());
				arr.add(data);
			}
			//최종적으로 word오브젝트에 JSON배열 저장
			word = new JSONObject();
			word.put("word",arr);

			data2 = new JSONObject();
			data2.put("date", date);
			word.put("date",data2);
			//파싱할 데이터 저장
			json = word.toJSONString();
			//테스트용 출력
			out.println(json);
		}
	}
}catch(Exception e)
{
	System.out.println("오류발생");
}
%>
