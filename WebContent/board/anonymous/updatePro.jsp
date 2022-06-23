<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
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
		//1. 한글처리
		request.setCharacterEncoding("utf-8");
		String id = (String)session.getAttribute("id");
	
		//2. updqte.jsp페이지에서 수정을 위해 입력한 정보들을 request에서 꺼내오기
		//3. BoardBean객체의 각 변수에 저장(자바코드 또는 Action 태그 이용)
		//int num = Integer.parseInt(request.getParameter("num"));
		//int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	%>
		<jsp:useBean id = "aBean" class = "anonymous.AnonymousBean"/>
		<jsp:setProperty property = "*" name = "aBean"/>
		<jsp:useBean id="adao" class = "anonymous.AnonymousDAO"/>
		
	<%
		Pattern pattern  =  Pattern.compile("<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>");
		String content = request.getParameter("content");
		
		Matcher match = pattern.matcher(content);
		String imgPath = null;
	
	if(match.find()){ // 이미지 태그를 찾았다면,,
	    imgPath = match.group(0); // 글 내용 중에 첫번째 이미지 태그를 뽑아옴.
	}
	
	System.out.println("imgPath : " + imgPath);
	
	aBean.setImgPath(imgPath);
	aBean.setName(id);
	%>
	<%
	//4. 수정을 위해 입력한 정보가 담긴 BoardBean 객체를 BoardDAO객체의 updatBoard()메소드 호출시 매개변수로 전달 후 update작업 명령 
	//수정에 성공하면 1을 반환받고 수정에 실패하면 0반환받아 int check변수에 저장
	adao.updateAnonymous(aBean);
	
	String pageNum = request.getParameter("pageNum");
	%>
	<script type="text/javascript">
		window.alert("수정 성공");
		location.href="anonymous.jsp?pageNum=<%=pageNum%>";
	</script>

</body>
</html>