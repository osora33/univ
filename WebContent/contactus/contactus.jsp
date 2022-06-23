<%@page import="member.MemberBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="member.MemberDAO"%>
<%@page import="ripple.RippleDAO"%>
<%@page import="java.util.Date"%>
<%@page import="board.BoardBean"%>
<%@page import="java.util.List"%>
<%@page import="board.BoardDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/default.css" rel="stylesheet" type="text/css" media="all" />
<link href="../css/board.css" rel="stylesheet" type="text/css" media="all" />
<script src = "https://code.jquery.com/jquery-3.5.1.js"></script>
<title>Hanguk.in.hand</title>
</head>
<%
	String id = (String)session.getAttribute("id");
	String email = null;
	String name = null;
	if(id != null){
		MemberDAO dao = new MemberDAO();
		MemberBean bean = new MemberBean();
		bean = dao.getEmail(id);
		email = bean.getEmail();
		name = bean.getName();
	}
%>
<body>
	<div id="header-wrapper">
		<div id="header" class="container">
			<div id="login">
			<%-- 
			session영역에 값이 저장되어 있으면 로그인화면(logout<a>태그)으로 디자인, session영역에 값이 저장되어 있지 않으면 로그인 되지 않는 화면으로 디자인
			 --%>
			 <%
			 	if(id == null){		//세션값이 저장되지 않은 경우
			 %>
				 <div id="login">
					<a href="../member/login.jsp">Login</a> | 
					<a href="../member/register.jsp">Register</a>
				</div>
			 <%
			 }else{		//세션영역에 세션값이 저장되어 있는 경우, 로그인 된 화면으로 처리
			%>
				<div id="login">
					<a href = "../member/modify.jsp">반갑습니다! <%=id %>님</a> | 
					<a href = "../member/logout.jsp">Logout</a>
				</div>
			<%
			 }
			 %>
			</div>
			<div id="logo">
				<h1>
					<a href="../index.jsp" style="font-size: 0.8em">Hanguk.in.hand</a>
				</h1>
<!-- 		old			 -->
				<div id="menu">
					<ul id ="gnb">
						<li><a href="../hot/hot/hot.jsp" accesskey="1" title="">인기글</a>
						</li>
						<li><a href="../board/freeboard/freeboard.jsp" accesskey="2" title="">게시판</a>
							<ul class = "sub">
								<li><a href="../board/freeboard/freeboard.jsp">자유게시판</a></li>
								<li><a href="../board/anonymous/anonymous.jsp">익명게시판</a></li>
							</ul>
						</li>
						<li><a href="../market/sell/sell.jsp" accesskey="3" title="">장터</a>
							<ul class = "sub">
								<li><a href="../market/sell/sell.jsp">팝니다</a></li>
								<li><a href="../market/buy/buy.jsp">삽니다</a></li>
							</ul>
						</li>
						<li><a href="../reference/exam/exam.jsp"" accesskey="4" title="">자료실</a>
							<ul class = "sub">
								<li><a href="../reference/exam/exam.jsp">족보자료실</a></li>
								<li><a href="../reference/ect/ect.jsp">기타자료실</a></li>
							</ul>
						</li>
						<li><a href="contactus.jsp" accesskey="5" title="">문의</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	
	<div id="wrapper">
	<%--서브메뉴 --%>
	<nav id="sub_menu">
		<ul>
			<li class="upper"><a href="../hot/hot/hot.jsp">인기글</a></li>
			<li id="upper1" class="upper"><a href="../board/freeboard/freeboard.jsp">게시판</a>
				<ul id="lower1" style="display: none;" class="lower">
					<li><a href="../board/freeboard/freeboard.jsp">자유게시판</a></li>
					<li><a href="../board/anonymous/anonymous.jsp">익명게시판</a></li>
				</ul>
			</li>
			<li id="upper2" class="upper"><a href="../market/sell/sell.jsp">장터</a>
				<ul id="lower2" style="display: none;" class="lower">
					<li><a href="../market/sell/sell.jsp">팝니다</a></li>
					<li><a href="../market/buy/buy.jsp">삽니다</a></li>
				</ul>
			</li>
			<li id="upper3" class="upper"><a href="../../reference/exam/exam.jsp">자료실</a>
				<ul id="lower3" style="display: none;" class="lower">
					<li><a href="../reference/exam/exam.jsp">족보자료실</a></li>
					<li><a href="../reference/ect/ect.jsp">기타자료실</a></li>
				</ul>
			</li>
		</ul>
		</nav>
	<%--서브메뉴 끝 --%>
	
	<!-- 게시판 -->
	<article>
		<form action = "emailPro.jsp" method="post" >
			<table id="notice">
				<tr>
					<th colspan="2" style="border-radius: 5px;">이메일 문의</th>
				</tr>
				<tr>
					<td width="35%">응답받으실 메일</td>
					<td width="65%">
						<%
							if(id != null){
						%>
								<input type="email" name="email" style="width: 80%;" value="<%=email%>">
						<%
							}else{
						%>
								<input type="email" name="email" style="width: 80%;">
						<%	
							}
						%>
					</td>
				</tr>
				<tr>
					<td>이름</td>
					<td>
						<%
							if(id != null){
						%>
								<input type="text" name="name" style="width: 80%;" value="<%=name%>">
						<%
							}else{
						%>
								<input type="text" name="name" style="width: 80%;">
						<%	
							}
						%>
					</td>
				</tr>
				<tr>
					<td>제목</td>
					<td>
						<input type="text" name="subject" style="width: 80%;">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<textarea rows="10" cols="93" name="content"></textarea>
					</td>
				</tr>
			</table>
			<div id = "write-btns">
				<input type = "submit" value = "저장" class = "btn">
				<input type = "reset" value = "다시쓰기" class = "btn">
			</div>
		</form>
	</article>
	</div>
	
	<script>
		
		$("#upper1").mouseenter(function(){
			$("#lower1").css("display", "block");
		});
		$("#upper1").mouseleave(function(){
			$("#lower1").css("display", "none");
		});
	
		$("#upper2").mouseenter(function(){
			$("#lower2").css("display", "block");
		});
		$("#upper2").mouseleave(function(){
			$("#lower2").css("display", "none");
		});
		
		$("#upper3").mouseenter(function(){
			$("#lower3").css("display", "block");
		});
		$("#upper3").mouseleave(function(){
			$("#lower3").css("display", "none");
		});
		
	</script>
	
	<!-- 게시판 -->
	
	<jsp:include page="../inc/bottom.jsp"></jsp:include>
</body>
</html>