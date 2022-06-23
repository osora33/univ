<%@page import="anonymous.AnonymousDAO"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="board.BoardDAO"%>
<%@page import="java.sql.Timestamp"%>
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
		//reWrite.jsp에서 전송된 데이터 한글처리
		request.setCharacterEncoding("utf-8");
	
		String id = (String)session.getAttribute("id");
	
		//reWrite.jsp에서 입력한 답글정보 + 주글정보를 request내장객체영역에서 꺼내어 BoardBean객체의 각 변수에 저장
	%>
	<jsp:useBean id = "aBean" class = "anonymous.AnonymousBean"/>
	<jsp:setProperty property = "*" name = "aBean"/>
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
		
		//답글을 작성한 날짜와 시간정보를 추가로 BoardBean객체의 data 변수에 저장\
		//System.currentTimeMillis();		//현재 시스템 컴퓨터 시간을 long값으로 반환
		aBean.setDate(new Timestamp(System.currentTimeMillis()));
		//답글을 작성하는 클라이언트의 ip주소를 추가로 BoardBean객체의 ip변수에 저장
		//request.getRemoteAddr()		//요청한 클라이언트의 ip주소를 반환
		aBean.setIp(request.getRemoteAddr());
		
		//작성한 답글 정보를 DB에 insert하기위해 BoardDAO객체의 reInsertBoard(BoardBean bBean)메소드 호출시 BoardBean객체 전달
		new AnonymousDAO().reInsertAnonymous(aBean);
		
		//DB에 답글을 추가했다면 notice.jsp게시판 목록화면을 재요청해 이동
		response.sendRedirect("anonymous.jsp");
	%>
</body>
</html>