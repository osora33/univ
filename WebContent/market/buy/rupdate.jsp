<%@page import="bripple.BRippleDAO"%>
<%@page import="bripple.BRippleBean"%>
<%@page import="sripple.SRippleDAO"%>
<%@page import="sripple.SRippleBean"%>
<%@page import="ripple.RippleDAO"%>
<%@page import="ripple.RippleBean"%>
<%@page import="board.BoardBean"%>
<%@page import="board.BoardDAO"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	//세션영역에 저장된 값 얻기(로그인 하지 않고 글쓰기 작업시 로그인창으로 이동시키기 위해)
	String id = (String)session.getAttribute("id");

	//세션영역에 값이 저장되어 있지 않을 경우
	if(id == null){
		response.sendRedirect("../member/login.jsp");
	}
	
	//1. 인코딩 방식 utf-8 설정
	request.setCharacterEncoding("utf-8");
	
	//2. 요청한 값 전달 받기(쓴 글의 내용 얻기)
	int postnum = Integer.parseInt(request.getParameter("postnum"));
	int num = Integer.parseInt(request.getParameter("rnum"));
	int i = Integer.parseInt(request.getParameter("i"));
	String content = request.getParameter("ucontent"+i);
	
	System.out.println(content);
	
	//3. Boardean객체를 생성하여 DB에 추가할 글 내용 저장
	BRippleBean ripplebean = new BRippleBean();
    //set으로 시작하는 메소드들을 호출하여 각 변수에 저장
    ripplebean.setPostnum(postnum);
    ripplebean.setNum(num);
    ripplebean.setId(id);
    ripplebean.setContent(content);
    
    //4. BoardDAO 객체를 생성하여 새로운 글 내용을 추가할 insertBoard 메소드 호출시 BoardBean 객체를 전달
    BRippleDAO dao = new BRippleDAO();
    dao.updateRipple(ripplebean);
    
//     //5. DB에 글 추가가 성공되었다면 notice.jsp 게시판 목록 화면을 재요청해 이동
//     response.sendRedirect("freeboard.jsp");
 %>
 
<script>
	location.href = document.referrer; 
</script>