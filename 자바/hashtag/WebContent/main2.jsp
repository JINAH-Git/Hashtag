<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="hashtag.dto.*" %>
<%@ page import="hashtag.vo.*" %>
<%@ page import="java.util.*" %> 
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
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>분석 결과2</title>
		<link rel="stylesheet" type="text/css" href="/hashtag/style/main2.css" />
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
			window.onload = function()
			{
				var last = document.lastModified;
				$(".phs_title2").text("마지막 업데이트 : " + last);			
			}

			var x = [];
			var y = [];
			var root = [];
			var child = [];		
			var grandchild = [];
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
		
		<!-- 하단 바 시작 -->
		<div class="wrap_body">
			<!-- 왼쪽 기둥 시작 -->
			<div class="bodybar1">
				<%
				DataDTO dto = new DataDTO();
				int totalPost = dto.GetTotalPost(region, hashtag);
				%>
				<!-- 첫 번째 해시태그 이름, 포스트 수 시작 -->
				<div class="bar1">
					<span class="hstitle"><a style="text-decoration-line: none;font-family: 'IBM Plex Sans KR', sans-serif;" href="main1.jsp?region=<%= region.replace("#","%23") %>&hashtag=<%= region.replace("#","%23") %>"><b><%= region %></b></a></span>
					<img class="right" src="/hashtag/img/right.png" alt="" width="30" height="30">
					<span class="hstitle2" style="font-family: 'IBM Plex Sans KR', sans-serif;"><b><%= hashtag %></b></span>
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
						<div class="phs_title2" style="position:relative; left: 20px;font-size: 14px; text-align: center;"></div>
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
				<!-- 인기 포스트 시작 -->
				<span class="postname" style="font-family: 'Noto Sans KR', sans-serif;"><b>인기 포스트</b></span>
				<div class="post">	
				<%
				ArrayList<CrawlingdataVO> post = dto.GetHeartCnt(region,hashtag);	
				if(post.size() != 0)
				{
					%>
					<div class="post_1">
						<div class="blogname1" style="font-family: 'IBM Plex Sans KR', sans-serif; overflow: hidden;"><b><%= post.get(0).getCdtitle() %></b></div>
						<p class="blognote1" style="font-family: 'IBM Plex Sans KR', sans-serif; overflow: hidden;">
							<%= post.get(0).getCdnote().replace("<","&lt;").replace(">","&gt;") %>
						</p>
						<span class="blogaddress1" style="font-family: 'IBM Plex Sans KR', sans-serif;"><a href="<%= post.get(0).getCdblogaddress() %>" style="text-decoration: none;"><%= post.get(0).getCdblogaddress() %></a></span>
						<span class="blogcount1" style="font-family: 'IBM Plex Sans KR', sans-serif;">공감수♥ <%= post.get(0).getCdheart() %></span>
					</div>
					<%
				}
				if(post.size() != 0 && post.size() != 1)
				{
					%>
					<div class="post_2">
						<div class="blogname2" style="font-family: 'IBM Plex Sans KR', sans-serif;"><b><%= post.get(1).getCdtitle() %></b></div>
						<p class="blognote2" style="font-family: 'IBM Plex Sans KR', sans-serif; overflow: hidden;">
							<%= post.get(1).getCdnote().replace("<","&lt;").replace(">","&gt;") %>
						</p>
						<span class="blogaddress2" style="font-family: 'IBM Plex Sans KR', sans-serif;"><a href="<%= post.get(1).getCdblogaddress() %>" style="text-decoration: none;"><%= post.get(1).getCdblogaddress() %></a></span>
						<span class="blogcount2" style="font-family: 'IBM Plex Sans KR', sans-serif;">공감수♥<%= post.get(1).getCdheart() %></span>
					</div>
					<%
				}
				%>
				</div>
				<!-- 인기 포스트 끝 -->
				<!-- 2년간 해시태그 언급량 추이 시작 -->
				<%
				ArrayList<RefinehashtagVO> mlist = dto.GetMention(region,hashtag); 
				for(RefinehashtagVO vo : mlist)
				{
					%>
					<script>
						x.push('<%= vo.getYearmonth() %>');
						y.push('<%= vo.getMetionamount() %>');
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
				Map<String,LinkedList<String>> list2 = dto.GetRelTags(region,hashtag);
				for(HashMap.Entry<String,LinkedList<String>> entry : list2.entrySet())
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
			</div>		
			<!-- 왼쪽 두 번째 기둥 끝 -->
		</div>
		<!-- 하단 바 끝 -->
		<!-- tail 시작 -->
		<div class="tail" style="width:100%; height:150px;">
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