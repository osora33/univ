<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	//1. 한글처리(인코딩방식 utf-8로 request객체에 설정)
	request.setCharacterEncoding("utf-8");
	
	//2. login.jsp에서 입력한 아이디 비밀번호 얻기(요청한 값 얻기)
	String id = request.getParameter("id");
	String pass = request.getParameter("pass");
	
	//3. 입력한 아이디와 비밀번호가 DB에 존재하는지 비교하는 DB작업을 위해 MemberDAO객체 생성 후
	//userCheck(String id, String passwd)메소드 호출하여 입력한 아이디와 비밀번호 전달
	MemberDAO memberdao = new MemberDAO();
	
	//check = 1 : 아이디 비밀번호 일치	/	0 : 아이디 일치, 비밀번호 불일치
	int check = memberdao.passCheck(id, pass);
	
	if(check == 1){
		//리다이렉트 방식으로 메인페이지 index.jsp 재요청(포워딩)하여 이동
		response.sendRedirect("modify2.jsp");
	}else if(check == 0){
%>
		<script>
		alert("비밀번호를 잘못 입력하셨습니다");
		history.back();
		</script>
<%
	}
%>
