<%@page import="sell.SellBean"%>
<%@page import="sell.SellDAO"%>
<%@page import="board.BoardBean"%>
<%@page import="board.BoardDAO"%>
<%@page import="hot.HotBean"%>
<%@page import="java.util.List"%>
<%@page import="hot.HotDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Hanguk.in.hand</title>
<meta name="keywords" content="" />
<meta name="description" content="" />
<link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900|Quicksand:400,700|Questrial" rel="stylesheet" />
<link href="css/default.css" rel="stylesheet" type="text/css" media="all" />
<link href="css/fonts.css" rel="stylesheet" type="text/css" media="all" />

<script type="text/javascript" src="js/common.js"></script>
<%
	
	HotDAO hdao = new HotDAO();
	int count = hdao.getBoardCount();
	List<HotBean> hlist = null;
	if(count > 0){		//DB에 글이 존재하면
		//글목록 검색해서 가져오기
		//getBoardList(각 페이지마다 첫번째로 보여질 시작 글번호, 한페이지당 보여줄 글 개수)
		hlist = hdao.getMainList();
	}
	
	BoardDAO bdao = new BoardDAO();
	int bcount = hdao.getBoardCount();
	List<BoardBean> blist = null;
	if(count > 0){		//DB에 글이 존재하면
		//글목록 검색해서 가져오기
		//getBoardList(각 페이지마다 첫번째로 보여질 시작 글번호, 한페이지당 보여줄 글 개수)
		blist = bdao.getMainList();
	}
	
	SellDAO sdao = new SellDAO();
	int scount = sdao.getSellCount();
	List<SellBean> slist = null;
	if(scount > 0){		//DB에 글이 존재하면
		//글목록 검색해서 가져오기
		//getBoardList(각 페이지마다 첫번째로 보여질 시작 글번호, 한페이지당 보여줄 글 개수)
		slist = sdao.getMainList();
	}

%>

</head>
<body>
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
					<a href="member/login.jsp">Login</a> | 
					<a href="member/register.jsp">Register</a>
				</div>
			 <%
			 }else{		//세션영역에 세션값이 저장되어 있는 경우, 로그인 된 화면으로 처리
			%>
				<div id="login">
					<a href = "member/modify.jsp">반갑습니다! <%=id %>님</a> | 
					<a href = "member/logout.jsp">Logout</a>
				</div>
			<%
			 }
			 %>
<!-- 				<a href="member/login.jsp">login</a> | <a href="member/register.jsp">Register</a> -->
			</div>
			<div id="logo">
				<h1>
					<a href="index.jsp">Hanguk.in.hand</a>
				</h1>
<!-- 		old			 -->
				<div id="menu">
					<ul id ="gnb">
						<li><a href="hot/hot/hot.jsp" accesskey="1" title="">인기글</a>
						</li>
						<li><a href="board/freeboard/freeboard.jsp" accesskey="2" title="">게시판</a>
							<ul class = "sub">
								<li><a href="board/freeboard/freeboard.jsp">자유게시판</a></li>
								<li><a href="board/anonymous/anonymous.jsp">익명게시판</a></li>
							</ul>
						</li>
						<li><a href="market/sell/sell.jsp" accesskey="3" title="">장터</a>
							<ul class = "sub">
								<li><a href="market/sell/sell.jsp">팝니다</a></li>
								<li><a href="market/buy/buy.jsp">삽니다</a></li>
							</ul>
						</li>
						<li><a href="reference/exam/exam.jsp"" accesskey="4" title="">자료실</a>
							<ul class = "sub">
								<li><a href="reference/exam/exam.jsp">족보자료실</a></li>
								<li><a href="reference/ect/ect.jsp">기타자료실</a></li>
							</ul>
						</li>
						<li><a href="contactus/contactus.jsp" accesskey="5" title="">문의</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div id="page-wrapper" style="clear: both;">
		<div id="welcome" class="container">
			<div class="title">
				<h2>Welcome to Hanguk.in.hand!</h2>
			</div>
			<p>
				이곳은 <strong>한국대학교</strong> 커뮤니티로서, 한국대학교 학생들의 편리한 대학생활을 위하여 개설되었습니다.<br>
				Hanguk.in.hand는 학생 간의 <strong>커뮤니케이션</strong>의 장이기도 하며, 쓰지 않는 물건을 사고 팔 수 있는 <strong>장터</strong>이고, <br>
				여러 자료를 공유받을 수 있는 <strong>자료실</strong> 이기도 합니다. <br> 
				Hanguk.in.hand에서 즐거운 시간 보내세요 :) 
			</p>
<!-- 			<img src="images/banner.jpg" class="image image-full" alt="" /> -->
		</div>
	</div>
	<div class="wrapper">
		<div id="three-column" class="container">
			<div>
				<span class="arrow-down"></span>
			</div>
			<div id="tbox1">
				<div class="title">
					<h2>인기글</h2>
				</div>
					<div>
					<ul class = "mainList">
						<%
						if(count >0){
							for(int i = 0; i<5; i++){
								HotBean bean = hlist.get(i);
						%>
									<li><a href = "hot/hot/content.jsp?num=<%=bean.getNum()%>&pageNum=1"><b>&#10007; </b> <%=bean.getSubject() %></a></li>
						<%
							}
						}
						%>
					</ul>
					<a href="hot/hot/hot.jsp" class="button">인기글로 이동</a>
				</div>
			</div>
			<div id="tbox2">
				<div class="title">
					<h2>자유게시판</h2>
				</div>
					<div>
					<ul class = "mainList">
						<%
						if(bcount >0){
							for(int i = 0; i<5; i++){
								BoardBean bean = blist.get(i);
						%>
									<li><a href = "board/freeboard/content.jsp?num=<%=bean.getNum()%>&pageNum=1"><b>&#10007; </b> <%=bean.getSubject() %></a></li>
						<%
							}
						}
						%>
					</ul>
					<a href="board/freeboard/freeboard.jsp" class="button">자유게시판으로 이동</a>
				</div>
			</div>
			<div id="tbox3">
				<div class="title">
					<h2>팝니다</h2>
				</div>
					<div>
					<ul class = "mainList">
						<%
						if(scount >0){
							for(int i = 0; i<5; i++){
								SellBean bean = slist.get(i);
						%>
									<li><a href = "market/sell/content.jsp?num=<%=bean.getNum()%>&pageNum=1"><b>&#10007; </b> <%=bean.getSubject() %></a></li>
						<%
							}
						}
						%>
					</ul>
					<a href="market/sell/sell.jsp" class="button">팝니다로 이동</a>
				</div>
			</div>
		</div>
		<div class = "sites">
			<h1>Family Sites</h1>
		</div>
		<div id="portfolio" class="container">
			<div class="column1">
				<div class="box">
					<a href="https://www.hanguk.ac.kr"><img src="images/scr01.jpg" alt="" class="image image-full" /></a>
					<h3>한국대학교</h3>
					<p>학사일정, 공지사항 등 제공하는 한국대학교 대표 공식 홈페이지</p>
					<a href="https://www.hanguk.ac.kr" class="button button-small">바로가기</a>
				</div>
			</div>
			<div class="column2">
				<div class="box">
					<a href="https://portal.hanguk.ac.kr"><img src="images/scr02.jpg" alt="" class="image image-full" /></a>
					<h3>한국대학교 포털</h3>
					<p>학적조회, 수강신청, 학사현황 변경 조회 등 전산처리, 조회</p>
					<a href="https://portal.hanguk.ac.kr" class="button button-small">바로가기</a>
				</div>
			</div>
			<div class="column3">
				<div class="box">
					<a href="https://libweb.hanguk.ac.kr"><img src="images/scr03.jpg" alt="" class="image image-full" /></a>
					<h3>한국대학교 도서관</h3>
					<p>도서관 보유도서 목록, 도서 현황 조회, 논문검색 등 도서업무 지원</p>
					<a href="https://libweb.hanguk.ac.kr" class="button button-small">바로가기</a>
				</div>
			</div>
			<div class="column4">
				<div class="box">
					<a href="https://lms.hanguk.ac.kr""><img src="images/scr04.jpg" alt="" class="image image-full" /></a>
					<h3>한국대학교 LMS</h3>
					<p>온라인 강의 수강, 강의 자료, 온라인 시험 등 강의 지원</p>
					<a href="https://lms.hanguk.ac.kr" class="button button-small">바로가기</a>
				</div>
			</div>
		</div>
	</div>
	<div id="copyright" class="container">
	<p>
		&copy; Hanguk.in.hand All rights reserved. | Photos by <a
		href="http://fotogrph.com/">Fotogrph</a> | Design by <a
		href="http://templated.co" rel="nofollow">TEMPLATED</a>.
	</p>
</div>
</body>
</html>
