<%@page import="java.time.LocalDate"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%@ page import="hashtag.dao.*" %>
<%@ page import="hashtag.dto.*" %>
<%@ page import="hashtag.vo.*" %>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("UTF-8");

String no = request.getParameter("no");
String region = request.getParameter("region");
String hashtag = request.getParameter("hashtag");
if(no == null || region == null || hashtag == null)
{
	response.sendRedirect("index.jsp");
	return;
}
DBManager db = new DBManager();
InetAddress local = InetAddress.getLocalHost();
db.DBOpen();
String sql = "";
sql  = "select * from nowtrend ";
sql += "where (ntclick BETWEEN DATE_ADD(NOW(), INTERVAL -30 hour ) AND NOW()) and ntno = '" + no + "' ";
sql += "and ntip = '" + local.getHostAddress() + "' ";
db.RunSelect(sql);
//System.out.println(sql);
if(db.Next() == true)
{
	db.DBOpen();
	sql = "delete from nowtrend where ntno = '" + no + "' and ntip = '" + local.getHostAddress() + "' ";
	db.RunSQL(sql);
	//System.out.println(sql);
	db.DBClose();
}
db.DBClose();

db.DBOpen();
sql = "";
sql  = "insert into nowtrend(ntno,ntip)";
sql += "values('" + no + "','" + local.getHostAddress() + "')";
db.RunSQL(sql);
//System.out.println(sql);

String encodedregion = URLEncoder.encode(region,"UTF-8");
String encodedhashtag = URLEncoder.encode(hashtag,"UTF-8");

response.sendRedirect("main2.jsp?region=" + encodedregion + "&hashtag=" + encodedhashtag);
db.DBClose();
%>