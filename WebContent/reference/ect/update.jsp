<%@page import="ect.EctBean"%>
<%@page import="ect.EctDAO"%>
<%@page import="java.sql.Timestamp"%>
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
<script type="text/javascript" src="../../js/jquery-1.10.2.min.js"></script>
 
 <%
	//notice.jsp페이지에서 글 하나를 클릭했을 때 num, pageNum 전달받기
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	
	//DB작업을 EctAO객체 생성
	EctDAO dao = new EctDAO();
	
	//글번호를 매개변수로 전달하여 글번호에 해당되는 글의 정보를 검Ect
	EctBean ectBean = dao.getEct(num);
	
	int DBnum = ectBean.getNum();		//검색한 글번호
	String DBSubject = ectBean.getSubject();		//검색한 글 제목
	String DBContent = "";		//검색한 글 내용
	String DBFile = ectBean.getFile();
	
	//검색한 글 내용이 존재한다면 엔터키를 사용해서 처리한 글 내용을 받아온다
	if(ectBean.getContent() != null){
		DBContent = ectBean.getContent().replace("\r\n", "<br>");
	}
 %>
</head>

<script>

</script>
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
				<ul id="lower3" class="lower">
					<li><a href="../../reference/exam/exam.jsp">족보자료실</a></li>
					<li><a href="../../reference/ect/ect.jsp" class="now">기타자료실</a></li>
				</ul>
			</li>
		</ul>
		</nav>
		<!-- 왼쪽메뉴 -->

		<!-- 게시판 -->
		<article>
			<h1>Notice Write</h1>
			<form action = "updatePro.jsp" method = "post" name="fr" enctype="multipart/form-data" accept-charset="utf-8">
				<table id = "notice">
						<input type="hidden" name="num" value="<%=num%>">
						<input type="hidden" name="pageNum" value="<%=pageNum%>">
					<tr>
						<td>이름</td>
						<td><input type = "text" name = "name" value = "<%=session.getAttribute("id")%>" readonly></td>
					</tr>
					<tr>
						<td>제목</td>
						<td><input type = "text" name = "subject" value="<%=DBSubject%>"></td>
					</tr>
					<tr>
						<td>첨부파일</td>
						<td><input type="file" name="upfile" class="file"></td>
					</tr>
					<tr>
						<td colspan="2">
							현재 업로드되어있는 파일 : <%=DBFile %>
							<br> ※새 파일 업데이트시 기존 파일은 삭제됩니다※
						</td>
					</tr>
					<tr>
						<td>내용</td>
						<td><textarea style="width: 100%" rows="10" name="content" id="textAreaContent" cols="80"><%=DBContent %></textarea></td>
					</tr>
				</table>
				<div id = "write-btns">
					<input type = "button" value = "저장" class = "btn" onclick="frck()">
					<input type = "reset" value = "다시쓰기" class = "btn">
					<input type = "button" value = "글목록" class = "btn" onclick = "location.href='ect.jsp'">
				</div>
			</form>
			<div class="clear"></div>
		</article>
		<!-- Naver Smart Editor 2 -->
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
	
	  var oEditors = [];
	  nhn.husky.EZCreator.createInIFrame({
	      oAppRef: oEditors,
	      elPlaceHolder: "textAreaContent",
	      sSkinURI: "<%=request.getContextPath()%>/editor/SmartEditor2Skin.html",
	      fCreator: "createSEditor2"
	  });

	  //‘저장’ 버튼을 누르는 등 저장을 위한 액션을 했을 때 submitContents가 호출된다고 가정한다.
	  function frck(elClickedObj) {
			var content = document.fr.content.value;
			
			if(content == ""){
				alert("내용을 입력해 주십시오")
			}else{
				// 에디터의 내용이 textarea에 적용된다.
			      oEditors.getById["textAreaContent"].exec("UPDATE_CONTENTS_FIELD", [ ]);
			   
			      // 에디터의 내용에 대한 값 검증은 이곳에서
			      // document.getElementById("textAreaContent").value를 이용해서 처리한다.
			    
				document.fr.submit();
			}
	      
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