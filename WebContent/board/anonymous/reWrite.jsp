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
<%--네이버 스마트에디터 --%>
<script type="text/javascript" src="<%=request.getContextPath()%>/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/editor/photo_uploader/plugin/hp_SE2M_AttachQuickPhoto.js" charset="utf-8"></script>
<script src = "https://code.jquery.com/jquery-3.5.1.js"></script>

</head>
<%
	//주 글에 대한 답글 정보를 입력하여 요청하는 곳
	
	//한글처리
	request.setCharacterEncoding("utf-8");
	
	//content.jsp페이지에서 주 글에 대한 답글 쓰기 버튼을 클릭했을 때
	//전달받는 요청값은 ?가 4개
	int num = Integer.parseInt(request.getParameter("num"));		//주 글 글번호
	int re_ref = Integer.parseInt(request.getParameter("re_ref"));		//주 글 그룹번호
	int re_lev = Integer.parseInt(request.getParameter("re_lev"));		//주 글의 들여쓰기 정도값
	int re_seq = Integer.parseInt(request.getParameter("re_seq"));		//주 글들 내의 순서값
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
%>
<body>
	<div id="wrap">
		<!-- 헤더들어가는 곳 -->
		<jsp:include page="../../inc/top.jsp"></jsp:include>
		<!-- 헤더들어가는 곳 -->

		<!-- 본문들어가는 곳 -->
		<!-- 왼쪽메뉴 -->
		<div id="wrapper">
		<nav id="sub_menu">
		<ul>
			<li class="upper"><a href="../../hot/hot.jsp">인기글</a></li>
			<li id="upper1" class="upper"><a href="freeboard.jsp">게시판</a>
				<ul id="lower1" class="lower">
					<li><a href="../freeboard/freeboard.jsp">자유게시판</a></li>
					<li><a href="../anonymous/anonymous.jsp" class="now">익명게시판</a></li>
				</ul>
			</li>
			<li id="upper2" class="upper"><a href="../../market/sell/sell.jsp">장터</a>
				<ul id="lower2" style="display: none;"class="lower">
					<li><a href="../../market/sell/sell.jsp">팝니다</a></li>
					<li><a href="../../market/buy/buy.jsp">삽니다</a></li>
				</ul>
			</li>
			<li id="upper3" class="upper"><a href="../../reference/exam/exam.jsp">자료실</a>
				<ul id="lower3" style="display: none;"class="lower">
					<li><a href="../../reference/exam/exam.jsp">족보자료실</a></li>
					<li><a href="../../reference/ect/ect.jsp">기타자료실</a></li>
				</ul>
			</li>
		</ul>
	</nav>
		<!-- 왼쪽메뉴 -->

		<!-- 게시판 -->
		<article>
			<form action = "reWritePro.jsp" method = "post" name="fr">
				<input type = "hidden" name = "num" value = "<%=num %>">
				<input type = "hidden" name = "re_ref" value = "<%=re_ref %>">
				<input type = "hidden" name = "re_lev" value = "<%=re_lev %>">
				<input type = "hidden" name = "re_seq" value = "<%=re_seq %>">
				<input type = "hidden" name = "pageNum" value = "<%=pageNum %>">
				<table id="notice">
					<tr>
						<td>답글제목</td>
						<td><input type = "text" name = "subject" value = "[답글]"></td>
					</tr>
					<tr>
						<td>글내용</td>
						<td><textarea style="width: 100%" rows="10" name="content" id="textAreaContent" cols="80"></textarea></td>
					</tr>
				</table>
				<div id = "write-btns">
					<input type = "button" value = "저장" class = "btn" onclick="submitContents()">
					<input type = "reset" value = "다시쓰기" class = "btn">
					<input type = "button" value = "글목록" class = "btn" onclick = "location.href='freeboard.jsp?pageNum=<%=pageNum%>'">
				</div>
			</form>
			<div class="clear"></div>
		</article>
		<!-- Naver Smart Editor 2 -->
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
	
	  var oEditors = [];
	  nhn.husky.EZCreator.createInIFrame({
	      oAppRef: oEditors,
	      elPlaceHolder: "textAreaContent",
	      sSkinURI: "<%=request.getContextPath()%>/editor/SmartEditor2Skin.html",
	      fCreator: "createSEditor2"
	  });
	   
	  //‘저장’ 버튼을 누르는 등 저장을 위한 액션을 했을 때 submitContents가 호출된다고 가정한다.
	  function submitContents(elClickedObj) {
	      // 에디터의 내용이 textarea에 적용된다.
	      oEditors.getById["textAreaContent"].exec("UPDATE_CONTENTS_FIELD", [ ]);
	   
	      // 에디터의 내용에 대한 값 검증은 이곳에서
	      // document.getElementById("textAreaContent").value를 이용해서 처리한다.
	    
	      try {
	    	  document.fr.submit();
	      } catch(e) {
	       
	      }
	  }
	   
	  // textArea에 이미지 첨부
	  function pasteHTML(filepath){
	      var sHTML = '<img src="<%=request.getContextPath()%>/editor/upload/'+filepath+'">';
	      oEditors.getById["textAreaContent"].exec("PASTE_HTML", [sHTML]);
	  }
	</script>
		<!-- 게시판 -->
		<!-- 본문들어가는 곳 -->
		<div class="clear"></div>
		</div>
		<!-- 푸터들어가는 곳 -->
		<jsp:include page="../../inc/bottom.jsp"></jsp:include>
		<!-- 푸터들어가는 곳 -->
	</div>
</body>
</html>