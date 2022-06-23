<%@page import="ripple.RippleDAO"%>
<%@page import="ripple.RippleBean"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board.BoardBean"%>
<%@page import="java.util.List"%>
<%@page import="board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="../../css/default.css" rel="stylesheet" type="text/css">
<link href="../../css/board.css" rel="stylesheet" type="text/css">
<script src = "https://code.jquery.com/jquery-3.5.1.js"></script>

</head>
<%
	//글 하나의 정보를 보여주는 페이지
	
	//한글처리
	request.setCharacterEncoding("utf-8");
	String recentURI = request.getRequestURI();
	String id = (String)session.getAttribute("id");
	
	//notice.jsp페이지에서 글 하나를 클릭했을 때 num, pageNum 전달받기
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	
	//DB작업을 위한 DAO객체 생성
	BoardDAO dao = new BoardDAO();
	
	//DB에 존재하는 글의 조회수 1 증가시키기 위해 메소드 호출
	dao.updateReadCount(num);
	
	//글번호를 매개변수로 전달하여 글번호에 해당되는 글의 정보를 검색하기
	BoardBean boardBean = dao.getBoard(num);
	
	int DBnum = boardBean.getNum();		//검색한 글번호
	int DBReadcount = boardBean.getReadcount();		//검색한 글의 조회수
	String DBName = boardBean.getName();		//검색한 글의 작성자명
	Timestamp DBDate = boardBean.getDate();		//검색한 글 작성일
	String DBSubject = boardBean.getSubject();		//검색한 글 제목
	String DBContent = "";		//검색한 글 내용
	
	//검색한 글 내용이 존재한다면 엔터키를 사용해서 처리한 글 내용을 받아온다
	if(boardBean.getContent() != null){
		DBContent = boardBean.getContent().replace("\r\n", "<br>");
	}
	//답변글 처리 관련 검색한 필드의 정보 얻기
	int DBRe_ref = boardBean.getRe_ref();		//주 글의 그룹번호
	int DBRe_lev = boardBean.getRe_lev();		//주 글의 들여쓰기 정도값
	int DBRe_seq = boardBean.getRe_seq();		//주 글들 내의 순서값
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
	
	//-------------------------------덧글 DB작업-------------------------------------
	RippleDAO rippledao = new RippleDAO();
	RippleBean ripplebean = new RippleBean();
	rippledao.getRipple(num);
	
// 	int rnum = ripplebean.getNum();
	String rid = ripplebean.getId();
	String rcontent = "";
	int re_ref = ripplebean.getRe_ref();
	int re_lev = ripplebean.getRe_lev();
	int re_seq = ripplebean.getRe_seq();
	Timestamp rdate = ripplebean.getDate();
	
	if(ripplebean.getContent() != null){
		rcontent = ripplebean.getContent().replace("\r\n", "<br>");
	}
	
	int count = rippledao.getRippleCount(num);
	
	//한 페이지당 보여줄 글 개수 10개로 설정
	int pageSize = 10;
	
	//notice.jsp 페이지에서 클릭한 페이지 번호 얻기
	String rpageNum = request.getParameter("rpageNum");
		
	//현재 클릭한 페이지 번호가 없으면(content.jsp페이지를 처음 요청했을 때)
	//현재 화면에 나타나는 페이지를 1로 설정
	if(rpageNum == null){
		rpageNum = "1";
	}
	
	//현재 화면에서 클릭한 페이지 번호를 정수로 변환해서 저장
	int currentPage = Integer.parseInt(rpageNum);
	
	//각 페이지마다 가장 첫번째로 보여질 시작 글 번호 구하기
	//(현재 보여지는 화면에서 클릭한 페이지 번호 -1) * 한 페이지당 보여줄 글 개수 
	int startRow = (currentPage-1)*pageSize;
	
	List<RippleBean> list = null;
	
	if(count > 0){		//DB에 글이 존재하면
		//덧글목록 검색해서 가져오기
		//getBoardList(각 페이지마다 첫번째로 보여질 시작 글번호, 한페이지당 보여줄 글 개수)
		list = rippledao.getRippleList(startRow, pageSize, num);
	}
%>


<body>
	<div id="wrap">
		<!-- 헤더들어가는 곳 -->
		<jsp:include page="../../inc/top.jsp"></jsp:include>
		<!-- 헤더들어가는 곳 -->

		<!-- 본문들어가는 곳 -->
		<div id="wrapper">
		<!-- 왼쪽메뉴 -->
		<nav id="sub_menu">
		<ul>
			<li class="upper"><a href="../../hot/hot/hot.jsp">인기글</a></li>
			<li id="upper1" class="upper"><a href="../../board/freeboard/freeboard.jsp">게시판</a>
				<ul id="lower1" class="lower">
					<li><a href="../../board/freeboard/freeboard.jsp" class="now">자유게시판</a></li>
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
		<!-- 왼쪽메뉴 -->

		<!-- 게시판 -->
		<article>
			<table id="notice">
				<tr>
					<td>글번호</td>
					<td><%=DBnum %></td>
					<Td>조회수</Td>
					<td><%=DBReadcount %></td>
				</tr>
				<tr>
					<td>작성자</td>
					<td><%=DBName %></td>
					<td>작성일</td>
					<td><%=sdf.format(DBDate) %></td>
				</tr>
				<tr>
					<td>글제목</td>
					<td colspan = "3"><%=DBSubject %></td>
				</tr>
				<tr class="contenttd">
					<td>글내용</td>
					<td colspan = "3" id="dbcontent"><%=DBContent %></td>
				</tr>
			</table>
			<%
				if(id != null){
			%>
			<form class = "rp" action="ripple.jsp" method="post">
				<input type ="hidden" name="postnum" value="<%=num %>">
				<table>
					<tr>
						<td class="rpid">ID : <%=id%></td>
					</tr>
					<tr>
						<td><textarea cols="90" rows="3" class="content" name="content"></textarea></td>
					</tr>
					<tr>
						<td align="right" class="rpsm">
							<input type="submit" class="btn" value="저장">
						</td>
					</tr>
				</table>
				</form>
			<%
				}
			%>
			<table id="ripple">
			<%
			if(count >0){		//DB에 글이 존재할 경우
				
				for(int i = 0; i<list.size(); i++){
					RippleBean bean = list.get(i);
// 					int rnum = bean.getNum();
			%>
				<form action="rripple.jsp" method="post" name="fr">
					<tr>
					<%		
						int wid = 0;		//답변글에 대한 들여쓰기 정도값 저장
							
							if(bean.getRe_lev()>0){
								wid = bean.getRe_lev()*10;
			%>
								
						<td class="rpid" style="margin-left: <%=wid%>px">
<%-- 						<img src = "../images/board/level.gif" width = <%=wid%> height = "15"> --%>
						<img src = "../../images/board/re.png">
			<%
							}else{
			%>
								<td class="rpid">
			<%
							}
			%>
						<%=bean.getNum()%> : <%=bean.getId()%>
						</td>
						<td class="rdate"><%=sdf.format(bean.getDate())%></td>
					</tr>
					<tr id="ripple<%=i%>">
						<td class="rcontent" style="padding-left: <%=wid+20%>px !important;"><%=bean.getContent()%></td>
						<td class="rbtns">
			<%
							if(id != null){
			%>
								<input type="button" value="답글" class="rbtn" id="rrdp<%=i%>">
			<%
							}
							if(bean.getId().equals(id)){
			%>
								<input type="button" value="수정" class="rbtn" id="rupdate<%=i%>">
								<input type="button" value="삭제" class="rbtn" onclick="rdelete(<%=bean.getNum()%>)">
								<script>
									function rdelete(a){
										var rdelete = confirm("정말 덧글을 삭제하시겠습니까?");
										if(rdelete){
											location.href = "rdelete.jsp?pageNum=<%=pageNum%>&postnum=<%=bean.getPostnum()%>&num="+a;
										}
									}
								</script>
			<%
							}
			%>
							
						</td>
					</tr>
					<tr class="rrtr" style="display: none;" id="rrtr<%=i%>">
						<td class="rrtd">
							<textarea rows="3" class = "rrcontent" name="rrcontent<%=i%>"></textarea>
						</td>
						<td class="rrsm">
<%-- 							<a href="rripple.jsp?postnum=<%=num%>&num=<%=bean.getNum()%>"> --%>
								<input type="hidden" name="postnum" value="<%=num%>">
								<input type="hidden" name="rnum" value="<%=bean.getNum()%>">
								<input type="hidden" name="re_ref" value="<%=bean.getRe_ref() %>">
								<input type="hidden" name="re_lev" value="<%=bean.getRe_lev() %>">
								<input type="hidden" name="re_seq" value="<%=bean.getRe_seq() %>">
								<input type="hidden" name="i" value="<%=i%>">
								<input type="submit" value="저장" class="rrbt">
							
						</td>
					</tr>
					</form>
					<form action="rupdate.jsp" method="post">
					<tr id="uripple<%=i%>" style="display: none;">
						<td class="rrtd">
							<textarea rows="3" class = "rrcontent" name="ucontent<%=i%>"><%=bean.getContent()%></textarea>
						</td>
						<td class="rrsm">
								<input type="button" value="취소" class="ubt" id="urc<%=i%>"><br>
								<input type="hidden" name="i" value="<%=i%>">
								<input type="hidden" name="postnum" value="<%=num%>">
								<input type="hidden" name="rnum" value="<%=bean.getNum()%>">
								<input type="submit" value="저장" class="ubt">
						</td>
					</tr>
					</form>
					<script>
						$("#rrdp"+<%=i%>).click(function(){
							$("#rrtr"+<%=i%>).toggle();
						});
						
						
						$("#rupdate"+<%=i%>).click(function(){
							$("#ripple"+<%=i%>).css("display", "none");
							$("#uripple"+<%=i%>).toggle();
						});
						
						$("#urc"+<%=i%>).click(function(){
							$("#ripple"+<%=i%>).css("display", "");
							$("#uripple"+<%=i%>).toggle();
						});
					</script>
			<% 
					
				}
			}else{		//DB에 글이 존재하지 않으면 
			%>
				<tr>
					<td>덧글이 존재하지 않습니다</td>
				</tr>
			<%
			}
			%>
			</table>
			
			<div id = "write-btns">
			<%
				if(id != null){		//로그인 되어있다면
					//글쓰기 버튼을 보이게 하기
					if(DBName.equals(id)){
			%>
						<input type = "button" value = "글수정" onclick = "update();" class = "btn">
						<input type = "button" value = "글삭제" onclick = "cdelete()" class = "btn">
			<%
					}
			%>
					<input type = "button" value = "답글작성" onclick = "location.href = 'reWrite.jsp?num=<%=DBnum %>&re_ref=<%=DBRe_ref %>&re_lev=<%=DBRe_lev %>&re_seq=<%=DBRe_seq %>&pageNum=<%=pageNum %>'" class = "btn">
			<%
				}
			%>
				<input type="button" value="글목록" class="btn" onclick = "location.href='freeboard.jsp?pageNum=<%=pageNum %>'">
			</div>
			<div class="clear"></div>
		</article>
		<script>
			function update(){
				var update = confirm("글을 수정하시겠습니까?");
				if(update){
					location.href = "update.jsp?num=<%=DBnum%>&pageNum=<%=pageNum%>";
				}
			}
			
			function cdelete(){
				var cdelete = confirm("정말 글을 삭제하시겠습니까?");
				if(cdelete){
					location.href="deletePro.jsp?num=<%=DBnum %>&pageNum=<%=pageNum %>"
				}
			}
		</script>
		<!-- 게시판 -->
		<!-- 본문들어가는 곳 -->
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
<%-- 						<a href = "freeboard.jsp?pageNum=<%=startPage-pageBlock %>">[이전]</a> --%>
						<a href = "content.jsp?num=<%=num %>&rpageNum=<%=currentPage-1%>&pageNum=<%=pageNum%>">[이전]</a>
			<%
					}
					//[1][2]... 페이지 번호 나타내기
					for(int i = startPage; i<=endPage; i++){
						if(endPage>pageCount){
							endPage=pageCount;
						}
			%>
						<a id= "a<%=i%>" href = "content.jsp?num=<%=num %>&rpageNum=<%=i%>&pageNum=<%=pageNum%>">[<%=i %>]</a>
			<%
					}//안쪽 for문
					//[다음] 끝페이지번호가 전체 페이지 개수보다 작을 때
					if(currentPage<pageCount){
			%>
						<a href="content.jsp?num=<%=num %>&rpageNum=<%=currentPage+1%>&pageNum=<%=pageNum%>">[다음]</a>
			<%
					}
				}//바깥 if문
			%>
		</div>
		</div>
		<script>
		
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
		
		document.getElementById("a"+<%=rpageNum%>).setAttribute("class", "selected");
		
		</script>
		<!-- 푸터들어가는 곳 -->
		<jsp:include page="../../inc/bottom.jsp"></jsp:include>
		<!-- 푸터들어가는 곳 -->
	</div>
</body>
</html>