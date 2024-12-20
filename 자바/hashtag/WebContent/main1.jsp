<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="hashtag.dto.*" %>
<%@ page import="hashtag.vo.*" %>
<%@ page import="java.util.*" %> 
<%@ page import="org.json.simple.*" %>
<%
request.setCharacterEncoding("UTF-8");

String region = request.getParameter("region");
String hashtag = request.getParameter("hashtag");
if(region == null || hashtag == null)
{
	response.sendRedirect("index.jsp");
	return;
}	

String[] regiontag = {"#전주카페","#완주카페","#군산카페","#익산카페"};
List<String> newList = new ArrayList<>(Arrays.asList(regiontag));
for(int i = 0; i < newList.size(); i++)
{
	if(region.equals(newList.get(i)))
	{
		newList.remove(i);
	}
}
 
String date = request.getParameter("date");
if(date == null) date = "2023-07"; 
if(region.equals("#전주카페")) date = "2023-08";
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>분석 결과1</title>
		<link rel="stylesheet" type="text/css" href="/hashtag/style/main1.css" />
		<!--  head 로고 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Roboto+Slab&display=swap" rel="stylesheet">
		<!-- 포스트 수 카운드 글씨 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+KR:wght@600&display=swap" rel="stylesheet">
		<!-- 메인 글씨들(인기 포스트, 1년간 해시태그 언급량 추이, 해시트리 태그 등 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300&display=swap" rel="stylesheet">
		<!-- 실시간 인기 해시태그 리스트 글씨들, 다른 지역 카페 리스트 글씨들 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@700&display=swap" rel="stylesheet">
		<!-- 인기 포스트 블로그 글들 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+KR:wght@300&display=swap" rel="stylesheet">
		<!-- 인기 포스트 블로그 제목들 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<!-- 파비콘 안뜨게 하기 -->
		<link rel="icon" href="data:;base64,iVBORw0KGgo=">
		<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+KR&display=swap" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
		<script src="https://cdn.amcharts.com/lib/4/core.js"></script>
		<script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
		<script src="https://cdn.amcharts.com/lib/4/plugins/forceDirected.js"></script>
		<script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>
		<script src="js/jquery-3.7.0.js"></script>
		<script>
		var x = [];
		var y = [];
		var root = [];
		var child = [];		
		var grandchild = [];
		
		window.onload = function()
		{
			region = '<%= region %>';
			date = '<%= date %>';
			var last = document.lastModified;
			$(".phs_title2").text("마지막 업데이트 : " + last);		
				
			$('#ponword_note tr').hover(function(){
		        $(this).css('border','2px solid #9098E7');
		    }, function() {
		        $(this).css('border','none');
		    }); 
		}
		</script>
	</head>
	<body>
	<!-- 전체 메인 시작 -->
	<div class="main">
		<!-- head 부분 시작 -->
		<div class="head" style="margin:0px;width:1500px;height:81px;">
			<p style="position:absolute;left:850px;text-align:center;font-size:45px;margin:0px;"><b><a href="index.jsp" style="text-decoration-line:none;color:black;font-family: 'Roboto Slab', serif;">Cafe HashTags</a></b></p>
		</div>	
		<!-- head 부분 끝 -->
		<!-- head 밑 전체 틀 시작 -->
		<div class="wrap_body">
			<!-- 왼쪽 기둥 시작 -->
			<div class="bodybar1">
				<!-- 첫 번째 해시태그 이름, 포스트 수 시작 -->
				<%
				DataDTO dto = new DataDTO();
				int totalPost = dto.GetTotalPost(region, hashtag);
				%>
				<div class="bar1">
					<span class="hstitle" style="font-family: 'IBM Plex Sans KR', sans-serif;"><b><%= region %></b></span>
					<img class="blog" src="/hashtag/img/blog.png" width="40" height="40">
					<span class="hspostcount" style="font-family: 'IBM Plex Sans KR', sans-serif;"><b><%= totalPost %></b></span>
					<span class="hspost" style="font-family: 'IBM Plex Sans KR', sans-serif;">포스트 수</span>
				</div>
				<!-- 첫 번째 해시태그 이름, 포스트 수 끝 -->
				<!-- 두 번째 실시간 인기 해시태그 전체 틀 시작 -->
				<div class="bar2">
					<!-- 실시간 인기 해시태그 전체 틀 시작 -->
					<%
					ArrayList<CityhashtagVO> list = dto.GetNowTrend();
					%>
					<div class="phs">
						<div class="phs_title1" style="position:relative; left: 20px;font-family: 'IBM Plex Sans KR', sans-serif; text-align: center;"><b>실시간 인기 해시태그</b></div>
						<div class="phs_title2" style="position:relative; left: 20px;text-align: center;font-size:14px;"></div>
						<div class="phs_list">
						<%
						for(int i = 0; i < list.size(); i++)
						{
							%>
							<div class="phslistfrm<%= i +1 %>">
								<span class="phs_list<%= i +1 %>" style="font-family: 'IBM Plex Sans KR', sans-serif;"><b><%= i +1 %></b></span>
								<span class="phs_name<%= i +1 %>" style="font-family: 'IBM Plex Sans KR', sans-serif;">
									<b><%= list.get(i).getChregiontag() %><a href="main2.jsp?region=<%= list.get(i).getChregiontag().replace("#","%23") %>&hashtag=<%= list.get(i).getChreltag().replace("#","%23") %>"><%= list.get(i).getChreltag() %></a></b>
								</span>
							</div>
							<%
						}
						%>	
						</div>
					</div>
					<!-- 실시간 인기 해시태그 전체 틀 끝 -->
				</div>
				<!-- 두 번째 실시간 인기 해시태그 전체 틀 끝 -->			
				<!-- 세 번째 다른 지역 카페 전체 틀 시작 -->
				<div class="bar3">
					<span class="cafename" style="font-family: 'IBM Plex Sans KR', sans-serif;"><b>다른 지역 카페</b></span>
					<!-- 다른 지역 카페 해시태그 시작 -->
					<div class="cafename_list">
						<span class="cafe1" style="font-family: 'IBM Plex Sans KR', sans-serif;">
							<b><a href="main1.jsp?region=<%= newList.get(0).replace("#","%23") %>&hashtag=<%= newList.get(0).replace("#","%23") %>" style="text-decoration: none;"><%= newList.get(0) %></a></b>
						</span>
						<br>
						<span class="cafe2" style="font-family: 'IBM Plex Sans KR', sans-serif;">
							<b><a href="main1.jsp?region=<%= newList.get(1).replace("#","%23") %>&hashtag=<%= newList.get(1).replace("#","%23") %>" style="text-decoration: none;"><%= newList.get(1) %></a></b>
						</span>
						<br>
						<span class="cafe3" style="font-family: 'IBM Plex Sans KR', sans-serif;">
							<b><a href="main1.jsp?region=<%= newList.get(2).replace("#","%23") %>&hashtag=<%= newList.get(2).replace("#","%23") %>" style="text-decoration: none;"><%= newList.get(2) %></a></b>
						</span>
					</div>
					<!-- 다른 지역 카페 해시태그 끝 -->
				</div>
				<!-- 세 번째 다른 지역 카페 전체 틀 끝 -->
			</div>
			<!-- 왼쪽 기둥 끝 -->
			<!-- 왼쪽 두 번째 기둥 시작 -->
			<div class="tag">
				<!-- 연관 태그 시작 -->
				<span class="tagname" style="font-family: 'Noto Sans KR', sans-serif;"><b>연관 태그</b></span>
				<div class="tag_body">
				<%
				ArrayList<CityhashtagVO> rtlist = dto.GetRelatedTag(region);
				for(CityhashtagVO cvo : rtlist)
				{
					%>
					<span id="tag_name<%= cvo.getChno() %>" class="tag_name" style="font-family: 'IBM Plex Sans KR', sans-serif;">
						<a href="nowtrend.jsp?no=<%= cvo.getChno() %>&region=<%= region.replace("#","%23") %>&hashtag=<%= cvo.getChreltag().replace("#","%23") %>" style="text-decoration-line: none;"><b><%= cvo.getChreltag() %></b></a>
					</span>
					<%
				}
				%>
				</div>
				<!-- 연관 태그 끝 -->
			<!-- 2년간 해시태그 언급량 추이 시작 -->
			<%
			ArrayList<RefinehashtagVO> mlist = dto.GetMention(region,hashtag); 
			for(RefinehashtagVO rvo : mlist)
			{
				%>
				<script>
					x.push('<%= rvo.getYearmonth() %>');
					y.push('<%= rvo.getMetionamount() %>');
				</script>
				<%
			}
			%>
			<div class="graph">
				<span class="graphname" style="font-family: 'Noto Sans KR', sans-serif;"><b>2년간 <span style="color: red;"><%= hashtag %></span> 언급량 추이</b></span>
				<div class="graph_body"></div>
			</div>
			<!-- 2년간 해시태그 언급량 추이 끝 -->
			<!-- 해시태그 트리 시작 -->
			<script>root.push('<%= hashtag %>');</script>
				<%
				Map<String,ArrayList<String>> list2 = dto.GetRelTags(region,hashtag);
				for(HashMap.Entry<String,ArrayList<String>> entry : list2.entrySet())
				{
					%>
					<script>
						child.push('<%= entry.getKey() %>');
						grandchild.push('<%= entry.getValue() %>');
					</script>
					<%
				}
				%>
				<div class="hstree">
					<span class="hstreename" style="font-family: 'Noto Sans KR', sans-serif;"><b>해시태그 트리</b></span>
					<div id="hstree_tree"></div>
				</div>
			<!-- 해시태그 트리 끝 -->
			<!-- 긍·부정 단어 순위 변화 시작-->
			<div class="ponword">
				<span class="ponwordname" style="font-family: 'Noto Sans KR', sans-serif;"><b>긍·부정 단어 TOP 10 ( <span id="date" style="color: red;"><%= date %></span><span style="color: red;"> 기준</span> )</b><span id="msg"></span></span>
				<!-- 표 시작 -->
				<div class="ponword_body">
					<!-- 긍·부정 단어 순위 제목들 시작 -->
					<div class="ponword_frm">
						<table class="ponword_title" align="center">
							<tr height="50px;">
								<th style="width:124px;"><b>순위</b></th>
								<th style="width:280px;"><b>단어</b></th>
								<th style="width:170px;"><b>긍·부정</b></th>
								<th><b>건수</b></th>
							</tr>
						</table>
						<!-- 긍·부정 단어 순위 제목들 끝 -->
						<!-- 긍·부정 단어 순위 내용 시작 -->
						<table id="ponword_note" class="ponword_note" align="center" style="border: 2px solid #FFF;">
							<%
							ArrayList<RefineadjectiveVO> pwlist = dto.GetSentimentAnalysis(region,date);
							int index = 1;
							for(RefineadjectiveVO rvo : pwlist)
							{
								%>
								<tr height="50px;">
									<td style="border-color:#E4E4E7; width:124px;"><%= index %></td>
									<td style="border-color:#E4E4E7; width:280px;"><%= rvo.getRaadj() %></td>
									<% 
									if(rvo.getAdsort().equals("긍정"))
									{
										%>
										<td style="border-color:#E4E4E7; color: #9588F2; font-weight: bold; width:170px;"><%= rvo.getAdsort() %></td>
										<%
									}
									else if(rvo.getAdsort().equals("부정"))
									{
										%>
										<td style="border-color:#E4E4E7; color: #F98885; font-weight: bold;"><%= rvo.getAdsort() %></td>
										<%
									}else
									{
										%>
										<td style="border-color:#E4E4E7; color: #F7D566; font-weight: bold;"><%= rvo.getAdsort() %></td>
										<%
									
									}
									%>
									<td style="border-color:#E4E4E7; "><%= rvo.getRacount() %></td>
								</tr>
								<%
								index++;
							}
							%>	
							<!-- 긍·부정 단어 순위 내용 끝 -->
						</table>
					</div>
					<!-- 왼쪽, 오른쪽 방향 버튼 시작 -->
					<span class="left">
						<img src="/hashtag/img/left.png" width="35" height="35">	
					</span>
					<span class="right">
						<img src="/hashtag/img/right.png" width="35" height="35">
					</span>
					<!-- 왼쪽, 오른쪽 방향 버튼 끝 -->
				</div>
				<script>	
				$(".left").click(function(){
					$.ajax({
		                type:"get",
		                url:"emotion.jsp",
		                dataType:"json",
		                data: {
		                	region : region,
		                	date : date,
		                	direction : "L"
		                },
		                success: function(data){
	                        $.each(data.word,function(i,item){	 	           
	                        	document.getElementById("ponword_note").getElementsByTagName("tr")[i].getElementsByTagName("td")[0].innerHTML = item.no;
	                        	document.getElementById("ponword_note").getElementsByTagName("tr")[i].getElementsByTagName("td")[1].innerHTML = item.name;
	                        	document.getElementById("ponword_note").getElementsByTagName("tr")[i].getElementsByTagName("td")[2].innerHTML = item.emot;
	                        	document.getElementById("ponword_note").getElementsByTagName("tr")[i].getElementsByTagName("td")[3].innerHTML = item.cnt;
	                        });
	                        $.each(data.date,function(i,item){
	                        	date = item;
	                        	document.getElementById("date").innerHTML = item;
	                        	document.getElementById("msg").innerHTML = "";
	                        });
		                },
		                error:function(){
		                	document.getElementById("msg").innerHTML = " 2021년 8월부터 2023년 7월까지 데이터만 확인 할 수 있습니다.";	       
		                }
					})
				});
				
				$(".right").click(function(){
					$.ajax({
		                type:"get",
		                url:"emotion.jsp",
		                dataType:"json",
		                data: {
		                	region : region,
		                	date : date,
		                	direction : "R"
		                },
		                success: function(data){
	                        $.each(data.word,function(i,item){	 	           
	                        	document.getElementById("ponword_note").getElementsByTagName("tr")[i].getElementsByTagName("td")[0].innerHTML = item.no;
	                        	document.getElementById("ponword_note").getElementsByTagName("tr")[i].getElementsByTagName("td")[1].innerHTML = item.name;
	                        	document.getElementById("ponword_note").getElementsByTagName("tr")[i].getElementsByTagName("td")[2].innerHTML = item.emot;
	                        	document.getElementById("ponword_note").getElementsByTagName("tr")[i].getElementsByTagName("td")[3].innerHTML = item.cnt;
	                        });
	                        $.each(data.date,function(i,item){
	                        	date = item;
	                        	document.getElementById("date").innerHTML = item;
	                        	document.getElementById("msg").innerHTML = "";
	                        });
		                },
		                error:function(){
		                	document.getElementById("msg").innerHTML = " 2021년 8월부터 2023년 7월까지 데이터만 확인 할 수 있습니다.(전주는 2023년 8월까지)";	       
		                }
					})
				});
				</script>
			</div>
			<!-- 긍·부정 단어 순위 변화 끝-->
			</div>	
			<!-- 왼쪽 두 번째 기둥 끝 -->
		</div>
		<!-- head 밑 전체 틀 끝 -->
		<!-- tail 시작 -->
		<div class="tail" style="width:100%;height:150px;">
			<p style="text-align:center;position:relative;font-size:25px;right:200px;">Company Info</p>
			<span style="text-align:center;position:relative;font-size:15px;left:700px;">HashTags Co.Ltd | 전북 전주시 덕진구 백제대로 572 5층 | T.063)276-2380 | F.063)276-2384</span>
		</div>	
		<!-- tail 끝 -->
	</div>
	<!-- 전체 메인 끝 -->
	</body>
	<script src="js/trend.js"></script>
	<script src="js/tree.js"></script>
</html>