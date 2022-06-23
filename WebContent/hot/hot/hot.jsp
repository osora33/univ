<%@page import="hot.HotBean"%>
<%@page import="hot.HotDAO"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../../css/board.css" rel="stylesheet" type="text/css" media="all" />
<script src = "https://code.jquery.com/jquery-3.5.1.js"></script>
<title>Hanguk.in.hand</title>
</head>
<%
	String recentURI = request.getRequestURI();
	//DB작업할 객체 생성
	HotDAO boardDAO = new HotDAO();

	//DB에 저장된 전체 글 개수 검색해오는 메소드 호출
	int count = boardDAO.getBoardCount();
	
	//한 페이지당 보여줄 글 개수 10개로 설정
	int pageSize = 10;
	
	//notice.jsp 페이지에서 클릭한 페이지 번호 얻기
	String pageNum = request.getParameter("pageNum");
	
	//현재 클릭한 페이지 번호가 없으면(notice.jsp페이지를 처음 요청했을 때)
	//현재 화면에 나타나는 페이지를 1로 설정
	if(pageNum == null){
		pageNum = "1";
	}
	
	//현재 화면에서 클릭한 페이지 번호를 정수로 변환해서 저장
	int currentPage = Integer.parseInt(pageNum);
	
	//각 페이지마다 가장 첫번째로 보여질 시작 글 번호 구하기
	//(현재 보여지는 화면에서 클릭한 페이지 번호 -1) * 한 페이지당 보여줄 글 개수 
	int startRow = (currentPage-1)*pageSize;
	
	//DB에 저장된 전체 글 정보들을 담을 변수 선언
	List<HotBean> list = null;
	
	if(count > 0){		//DB에 글이 존재하면
		//글목록 검색해서 가져오기
		//getBoardList(각 페이지마다 첫번째로 보여질 시작 글번호, 한페이지당 보여줄 글 개수)
		list = boardDAO.getBoardList(startRow, pageSize);
	}
	
	//날짜 포맷 형식을 개발자가 지정할 수 잇는 객체 생성
	SimpleDateFormat sdf = new SimpleDateFormat("MM월 dd일");
	SimpleDateFormat sdf2 = new SimpleDateFormat("HH:mm");
	SimpleDateFormat now = new SimpleDateFormat("yyyy.MM.dd");
	Date time = new Date();
	
	//------------------------------------덧글개수-----------------------------------
	
%>

<body>
	<jsp:include page="../../inc/top.jsp"></jsp:include>
	
	<div id="wrapper">
	<%--서브메뉴 --%>
	<nav id="sub_menu">
		<ul>
			<li class="upper"><a href="../../hot/hot/hot.jsp">인기글</a></li>
			<li id="upper1" class="upper"><a href="../../board/freeboard/freeboard.jsp">게시판</a>
				<ul id="lower1" style="display: none;" class="lower">
					<li><a href="../../board/freeboard/freeboard.jsp">자유게시판</a></li>
					<li><a href="../../board/anonymous/anonymous.jsp">익명게시판</a></li>
				</ul>
			</li>
			<li id="upper2" class="upper"><a href="../../market/sell/sell.jsp">장터</a>
				<ul id="lower2" style="display: none;" class="lower">
					<li><a href="../../market/sell/sell.jsp">팝니다</a></li>
					<li><a href="../../market/buy/buy.jsp">삽니다</a></li>
				</ul>
			</li>
			<li id="upper3" class="upper"><a href="../../reference/exam/exam.jsp">자료실</a>
				<ul id="lower3" style="display: none;" class="lower">
					<li><a href="../../reference/exam/exam.jsp">족보자료실</a></li>
					<li><a href="../../reference/ect/ect.jsp">기타자료실</a></li>
				</ul>
			</li>
		</ul>
		</nav>
	<%--서브메뉴 끝 --%>
	
	<!-- 게시판 -->
	<article>
		<table id="notice">
			<tr style="border-radius: 5px !important;">
				<th width="10%" style="border-top-left-radius:5px; border-bottom-left-radius:5px;">No.</th>
				<th width="60%">Title</th>
				<th width="15%">From</th>
				<th width="15%" style="border-top-right-radius:5px; border-bottom-right-radius:5px;">Date</th>
			</tr>
		<%
			if(count >0){		//DB에 글이 존재할 경우
				for(int i = 0; i<list.size(); i++){
					HotBean bean = list.get(i);
		%>
					<tr onclick = "location.href='content.jsp?num=<%=bean.getNum()%>&pageNum=<%=pageNum%>'">
						<td><%=bean.getNum() %></td>
						<td class = "left">
		<%
							int rcount = boardDAO.getRippleCount(bean.getOriginNum(), bean.getTable());
		%>
							<%=bean.getSubject() %> 
							
		<%					
								String ImgPath = boardDAO.getImgPath(bean.getOriginNum(), bean.getTable());
								if(ImgPath != null){
		%>
									<img src = "../../images/board/image.png" width="12px">
		<%
								}
								if(rcount!=0){
		%>
									<label style="color: orange ; font-size: 0.8em;"><%=rcount%></label>
		<%						
								}
		
		%>
						</td>
						<td>
		<%
							if(bean.getTable().equals("board")){
		%>
								자유게시판
		<%
							}else if(bean.getTable().equals("anonymous")){
		%>
								익명게시판
		<%
							}else if(bean.getTable().equals("sell")){
		%>
								팝니다
		<%
							}else if(bean.getTable().equals("buy")){
		%>
								삽니다
		<%
							}else if(bean.getTable().equals("exam")){
		%>
								족보자료실
		<%
							}else if(bean.getTable().equals("ect")){
		%>
								기타자료실
		<%
							}
		%>
						</td>
						<td id="sdf">
<%-- 						<%=sdf.format(bean.getDate()) %> --%>
		<% 
						if(now.format(bean.getDate()).toString().equals(now.format(time).toString())){			
		%>
							<%=sdf2.format(bean.getDate())%>
		<%
						}else{
		%>
							<%=sdf.format(bean.getDate())%>
		<%
						}
		%>
						</td>
					</tr>
<!-- 					<tr> -->
<%-- 						<td id="sdf2"><%=sdf2.format(bean.getDate()) %></td> --%>
<!-- 					</tr> -->
		<%
				}
			}else{		//DB에 글이 존재하지 않으면 
		%>
				<tr>
					<td colspan = "5">글이 존재하지 않습니다</td>
				</tr>
		<%
			}
		%>
		</table>
		<div id="undermenu">
			<form action="search.jsp" method="get" name="fr">
				<div id="table_search">
					<select name="frselect" id="frselect" class="frselect">
						<option id="subncon">제목/내용</option>
						<option id="writer">작성자</option>
					</select>
					<input type="text" name="search" id="search" class="input_box"> 
					<input type="submit" value="글검색" id="search_btn" name="search_btn" class="btn">
				</div>
			</form>
		</div>
		<div class="clear"></div>
		<div id="page_control">
			<%
				if(count > 0){
					//전체 페이지수 구하기. 글 20개 한페이지당 보여줄 글 개수 10개 => 2개의 페이지
					//							 글 25개 한페이지당 보여줄 글 개수 10개 => 3개의 페이지
					//조건삼항연산자 사용 : 조건식?참일경우실행문:거짓일경우실행문
					//전체페이지수 = 전체 글 개수 / 한페이지당 보여줄 글 개수 + (전체 글 수를 한페이지에 보여질 글 수로 나눈 나머지값)
					int pageCount = count/pageSize+(count%pageSize==0?0:1);
					
					//한 화면(한 블럭)에 보여줄 페이지 개수 설정
					int pageBlock = 5;
						
					//시작 페이지 번호 구하기
					//1~10 = 1		11~20 = 11		21~30 = 21
					//(현재 클릭한 페이지번호/한 블럭에 보여줄 페이지 개수) - (현재 클릭한 번호를 한 블럭에 보여줄 페이지 개수로 나눈 나머지값)
					int startPage = ((currentPage / pageBlock) - (currentPage % pageBlock == 0 ? 1 : 0)) * pageBlock + 1;
						
					//끝 페이지 번호 구하기
					//1~10 = 10		11~20 = 20		21~30 = 30
					//끝페이지번호 = 시작페이지번호+한 블럭에 보여줄 글 개수
					int endPage = startPage+pageBlock-1;
					
					//[이전] 시작페이지번호가 한 블럭에 보여줄 페이지 개수보다 클 때
					if(currentPage>1){
			%>
						<a href = "hot.jsp?pageNum=<%=currentPage-1%>">[이전]</a>
			<%
					}
					//[1][2]... 페이지 번호 나타내기
					for(int i = startPage; i<=endPage; i++){
						if(endPage>pageCount){
							endPage=pageCount;
						}
			%>
						<a id= "a<%=i%>" href = "hot.jsp?pageNum=<%=i%>">[<%=i %>]</a>
			<%
					}//안쪽 for문
					//[다음] 끝페이지번호가 전체 페이지 개수보다 작을 때
					if(currentPage<pageCount){
			%>
						<a href="hot.jsp?pageNum=<%=currentPage+1%>">[다음]</a>
			<%
					}
				}//바깥 if문
			%>
		</div>
	</article>
	</div>
	
	<script>
		document.getElementById("a"+<%=pageNum%>).setAttribute("class", "selected");
		
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
	
	<jsp:include page="../../inc/bottom.jsp"></jsp:include>
</body>
</html>