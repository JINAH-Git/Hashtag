<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="hashtag.dto.*" %>
<%@ page import="hashtag.vo.*" %>
<%@ page import="java.util.*" %> 
<!DOCTYPE html>
<html style="scroll-behavior:smooth;">
	<head>
		<meta charset="UTF-8">
		<title>HashTags</title>
		<link rel="stylesheet" type="text/css" href="/hashtag/style/index.css" />
		<!--  head 로고 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Roboto+Slab&display=swap" rel="stylesheet">
				<!-- 인기 포스트 블로그 글들 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+KR:wght@300&display=swap" rel="stylesheet">
		<!-- 인기 포스트 블로그 제목들 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+KR&display=swap" rel="stylesheet">
		<!-- 포스트 수 카운드 글씨 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+KR:wght@600&display=swap" rel="stylesheet">
		<!-- 메인 글 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500&display=swap" rel="stylesheet">
		<!-- 메인 설명 밑에 글 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@200&display=swap" rel="stylesheet">
		<!-- 파비콘 안뜨게 하기 -->
		<link rel="icon" href="data:;base64,iVBORw0KGgo=">
		<script src="js/jquery-3.7.0.js"></script>
		<script>
		window.onload = function()
		{
			var last = document.lastModified;
			$(".phs_title2").text("마지막 업데이트 : " + last);			
		}
		</script>
	</head>
	<body style="margin: 0px;">
	<!-- 전체 메인 시작 -->
	<div class="main" style="margin:0px">
		<!-- head 부분 시작 -->
		<div class="head" style="margin:0px;min-width:1500px;height:81px;">
			<p style="position:absolute;left:850px;text-align:center;font-size:45px;margin:0px;"><b><a href="index.html" style="text-decoration-line:none;color:black;font-family: 'Roboto Slab', serif; white-space: nowrap;">Cafe HashTags</a></b></p>
		</div>	
		<!-- head 부분 끝 -->
		<!-- head 밑 전체 틀 시작 -->
		<div class="wrap_body">
			<div class="sub1" id="sub1" style="min-width:1903px; height:844px;">
				<img src="/hashtag/img/indeximg.jpg" style="width:1903px;height:844px"></img>
				<div style="background:linear-gradient(to right, #9C70C6, transparent);position:relative;bottom:850px;width:1903px;height:844px;"></div>
				<p style="position:absolute;top:350px;left:100px; text-align:left;font-size:45px;margin:0px;color:white;font-family: 'Noto Sans KR', sans-serif;">
					<b>해시태그 분석으로 <br>카페 탐방은 HashTags 에서 한눈에!</b>
				</p>
				<!-- 설명 글 틀 시작 -->
			<div class="inner">
			<!-- 설명 글 시작 -->
			<div class="sub1_info">
				<p style="position:relative;width:800px;bottom:1000px;left:630px;text-align:middle;font-size:30px;margin:0px;color:white;font-family: 'Noto Sans KR', sans-serif;">
					아래로 스크롤 해서 HashTags와 함께 시작해보세요
				</p>
				<button style="position:relative;bottom:980px;left:850px;text-align:middle;width:200px;height:50px;border-radius:20px;font-size:30px;background-color:#F2F4FD;border:none;">
				<a href="#sub2" style="text-decoration-line: none;color:black">▽</a>
				</button>
			</div>
				<!-- 설명 글 끝 -->
			</div>
				<!-- 설명 글 틀 끝 -->
			</div>
		</div>
		<!-- head 밑 전체 틀 끝 -->
			<div class="sub2" id="sub2" style="min-width:1903px;min-height:925px;background:#FFFFFF;">
				<!-- 실시간 인기 해시태그 전체 틀 시작 -->
				<%
				DataDTO dto = new DataDTO();
				ArrayList<CityhashtagVO> list = dto.GetNowTrend();
				%>
				<div class="phs">
					<div class="phs_title1" style="font-family: 'IBM Plex Sans KR', sans-serif;"><b>실시간 인기 해시태그</b></div>
					<div class="phs_title2"></div>
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
				<!-- 지도  -->
				<p style="position:relative;width:400px;top:180px;font-size:35px;left:1140px;margin:0px;font-family: 'IBM Plex Sans KR', sans-serif;"><b>전라북도 내 카페</b></p>
				<img src="/hashtag/img/indexmap.png" style="position:relative;top:230px;left:1000px;width:500px"></img>
				<a href="main1.jsp?region=%23익산카페&hashtag=%23익산카페"><img src="/hashtag/img/pin.png" style="position:relative;left:735px;bottom:60px;width:50px"></img></a> <!-- 익산 -->
				<a href="main1.jsp?region=%23군산카페&hashtag=%23군산카페"><img src="/hashtag/img/pin.png" style="position:relative;left:560px;bottom:18px;width:50px"></img></a> <!-- 군산 -->
				<a href="main1.jsp?region=%23완주카페&hashtag=%23완주카페"><img src="/hashtag/img/pin.png" style="position:relative;left:735px;bottom:20px;width:50px"></img></a> <!-- 완주 -->
				<a href="main1.jsp?region=%23전주카페&hashtag=%23전주카페"><img src="/hashtag/img/pin.png" style="position:relative;left:630px;top:65px;width:50px"></img></a> <!-- 전주 -->
			</div>
			<!-- tail 시작 -->
			<div class="tail" style="min-width:1903px;height:150px;background-color:#EDEDED;">
				<p style="text-align:center;position:relative;font-size:25px;right:200px;">Company Info</p>
				<span style="text-align:center;position:relative;font-size:15px;left:700px;">HashTags Co.Ltd | 전북 전주시 덕진구 백제대로 572 5층 | T.063)276-2380 | F.063)276-2384</span>
			</div>	
			<!-- tail 끝 -->
	</div>
	<!-- 전체 메인 끝 -->
	</body>
</html>