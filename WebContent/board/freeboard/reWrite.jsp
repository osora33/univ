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
<link href="../css/default.css" rel="stylesheet" type="text/css">
<link href="../css/board.css" rel="stylesheet" type="text/css">
<%--네이버 스마트에디터 --%>
<script type="text/javascript" src="<%=request.getContextPath()%>/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/editor/photo_uploader/plugin/hp_SE2M_AttachQuickPhoto.js" charset="utf-8"></script>
<!--[if lt IE 9]>
<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js" type="text/javascript"></script>
<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/ie7-squish.js" type="text/javascript"></script>
<script src="http://html5shim.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script>
<![endif]-->
<!--[if IE 6]>
 <script src="../script/DD_belatedPNG_0.0.8a.js"></script>
 <script>
   /* EXAMPLE */
   DD_belatedPNG.fix('#wrap');
   DD_belatedPNG.fix('#main_img');   

 </script>
 <![endif]-->
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
				<li><a href="#">자유게시판</a></li>
				<li><a href="#">인기글</a></li>
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
						<td>이름</td>
						<td><input type = "text" name = "name" value = "<%=session.getAttribute("id")%>" readonly></td>
					</tr>
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