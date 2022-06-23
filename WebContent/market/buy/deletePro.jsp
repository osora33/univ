<%@page import="buy.BuyDAO"%>
<%@page import="sell.SellDAO"%>
<%@page import="board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>deletePro.jsp</h1>
	<%
		request.setCharacterEncoding("utf-8");
	
		//deletePro.jsp(글을 삭제하기 위해 비밀번호 입력하는 화면)에서 글을 삭제하기 위해 비밀번호를 입력하고 삭제버튼 클릭했을 때 요청한 값 얻기
		int num = Integer.parseInt(request.getParameter("num"));
		String pageNum = request.getParameter("pageNum");
		
		BuyDAO sdao = new BuyDAO();
		
		sdao.deleteBuy(num);
		
	%>
	<script>
		alert("삭제 성공");
		location.href = "buy.jsp?pageNum=<%=pageNum%>";
	</script>

</body>
</html>