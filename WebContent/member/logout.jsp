<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<%
		String recentURI = (String)request.getHeader("REFERER");
	
		//세선영역에 접근해서 세션영역에 저장된 모든 값들을 제거(단, 세션메모리영역은 유지)
		session.invalidate();
		//세션영역에 저장된 값 모두 제거 후 index.jsp(메인페이지)를 재요청(포워딩)해 이동
		//response.sendRedirect("../index.jsp");
	%>
	
	<script>
		alert("로그아웃 되었습니다");
		//자바스크립트 재요청기술
		location.href="<%=recentURI%>";
	</script>

</body>
</html>