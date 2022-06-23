<%@page import="sell.SellBean"%>
<%@page import="sell.SellDAO"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="board.BoardBean"%>
<%@page import="board.BoardDAO"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<h1>writePro.jsp</h1>

<%
	//세션영역에 저장된 값 얻기(로그인 하지 않고 글쓰기 작업시 로그인창으로 이동시키기 위해)
	String id = (String)session.getAttribute("id");

	//세션영역에 값이 저장되어 있지 않을 경우
	if(id == null){
		response.sendRedirect("../member/login.jsp");
	}
	
	//1. 인코딩 방식 utf-8 설정
	request.setCharacterEncoding("utf-8");
	
	Pattern pattern  =  Pattern.compile("<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>");
	
	
	//2. 요청한 값 전달 받기(쓴 글의 내용 얻기)
	String name = request.getParameter("name");
	String subject = request.getParameter("subject");
	String content = request.getParameter("content");
	String price = request.getParameter("price");
	String status = request.getParameter("status");
	
	Matcher match = pattern.matcher(content);
	String imgPath = null;
	
	if(match.find()){ // 이미지 태그를 찾았다면,,
	    imgPath = match.group(0); // 글 내용 중에 첫번째 이미지 태그를 뽑아옴.
	}
	
	System.out.println("imgPath : " + imgPath);
	
	//현재글을 작성한 날짜
	Timestamp timestamp = new Timestamp(System.currentTimeMillis());
	//현재 글을 작성하는 사람의 ip주소 얻기
	String ip = request.getRemoteAddr();
	
	//3. Boardean객체를 생성하여 DB에 추가할 글 내용 저장
	SellBean sellbean = new SellBean();
    //set으로 시작하는 메소드들을 호출하여 각 변수에 저장
    sellbean.setContent(content);
    sellbean.setSubject(subject);
    sellbean.setName(name);
    sellbean.setDate(timestamp);
    sellbean.setIp(ip);
    sellbean.setImgPath(imgPath);
    sellbean.setPrice(price);
    sellbean.setStatus(status);
    
    //4. galaryDAO 객체를 생성하여 새로운 글 내용을 추가할 insertgalary 메소드 호출시 galaryBean 객체를 전달
    SellDAO dao = new SellDAO();
    dao.insertSell(sellbean);
    
    //5. DB에 글 추가가 성공되었다면 notice.jsp 게시판 목록 화면을 재요청해 이동
    response.sendRedirect("sell.jsp");
 %>