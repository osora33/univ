<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	//1. 한글처리(인코딩방식 utf-8로 request객체에 설정)
	request.setCharacterEncoding("utf-8");
	
	//2. login.jsp에서 입력한 아이디 비밀번호 얻기(요청한 값 얻기)
	String id = request.getParameter("id");
	String pass = request.getParameter("pass");
	String recentURI = request.getParameter("from");
	System.out.println(id+", " + pass);
	
	//3. 입력한 아이디와 비밀번호가 DB에 존재하는지 비교하는 DB작업을 위해 MemberDAO객체 생성 후
	//userCheck(String id, String passwd)메소드 호출하여 입력한 아이디와 비밀번호 전달
	MemberDAO memberdao = new MemberDAO();
	
	//check = 1 : 아이디 비밀번호 일치	/	0 : 아이디 일치, 비밀번호 불일치	/	-1 : 아이디 불일치
	int check = memberdao.userCheck(id, pass);
	
	if(check == 1){
		//세션영역에 입력한 아이디를 세션값으로 저장
		session.setAttribute("id", id);
%>
		<script>
			location.href="<%=recentURI%>";
		</script>
<%
	}else if(check == 0){
%>
		<script>
		alert("비밀번호를 잘못 입력하셨습니다");
		history.back();
		</script>
<%
	}else{
%>
		<script>
			alert("아이디를 잘못 입력하셨습니다");
			history.go(-1);
		</script>
<%
	}
%>