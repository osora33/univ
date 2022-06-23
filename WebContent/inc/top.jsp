<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="../css/fonts.css" rel="stylesheet" type="text/css" media="all" />
<link href="../../css/default.css" rel="stylesheet" type="text/css" media="all" />

<div id="header-wrapper">
		<div id="header" class="container">
			<div id="login">
			<%-- 
			session영역에 값이 저장되어 있으면 로그인화면(logout<a>태그)으로 디자인, session영역에 값이 저장되어 있지 않으면 로그인 되지 않는 화면으로 디자인
			 --%>
			 <%
			 	String id = (String)session.getAttribute("id");
			 	if(id == null){		//세션값이 저장되지 않은 경우
			 %>
				 <div id="login">
					<a href="../../member/login.jsp">Login</a> | 
					<a href="../../member/register.jsp">Register</a>
				</div>
			 <%
			 }else{		//세션영역에 세션값이 저장되어 있는 경우, 로그인 된 화면으로 처리
			%>
				<div id="login">
					<a href = "../../member/modify.jsp">반갑습니다! <%=id %>님</a> | 
					<a href = "../../member/logout.jsp">Logout</a>
				</div>
			<%
			 }
			 %>
<!-- 				<a href="member/login.jsp">login</a> | <a href="member/register.jsp">Register</a> -->
			</div>
			<div id="logo">
				<h1>
					<a href="../../index.jsp" style="font-size: 0.8em">Hanguk.in.hand</a>
				</h1>
<!-- 		old			 -->
				<div id="menu">
					<ul id ="gnb">
						<li><a href="../../hot/hot/hot.jsp" accesskey="1" title="">인기글</a>
						</li>
						<li><a href="../../board/freeboard/freeboard.jsp" accesskey="2" title="">게시판</a>
							<ul class = "sub">
								<li><a href="../../board/freeboard/freeboard.jsp">자유게시판</a></li>
								<li><a href="../../board/anonymous/anonymous.jsp">익명게시판</a></li>
							</ul>
						</li>
						<li><a href="../../market/sell/sell.jsp" accesskey="3" title="">장터</a>
							<ul class = "sub">
								<li><a href="../../market/sell/sell.jsp">팝니다</a></li>
								<li><a href="../../market/buy/buy.jsp">삽니다</a></li>
							</ul>
						</li>
						<li><a href="../../reference/exam/exam.jsp"" accesskey="4" title="">자료실</a>
							<ul class = "sub">
								<li><a href="../../reference/exam/exam.jsp">족보자료실</a></li>
								<li><a href="../../reference/ect/ect.jsp">기타자료실</a></li>
							</ul>
						</li>
						<li><a href="../../contactus/contactus.jsp" accesskey="5" title="">문의</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>