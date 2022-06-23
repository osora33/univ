<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	//1. join.jsp(회원가입 페이지)에서 입력한 가입할 내용은 모두 request내장객체에 저장되어 있음
	//저장된 데이터들 중 한글이 존재하면 request 내장 객체에서 꺼내올 때 한글이 깨지므로 인코딩 방식을 utf-8방식으로 설정
	request.setCharacterEncoding("utf-8");
%>

<%--
	2. join.jsp에서 입력한 회원정보들을 request객체에서 꺼내와 MemberBean객체의 각 변수에 저장
	참고 : Action 태그 사용
 --%>
 <jsp:useBean id = "memberbean" class = "member.MemberBean"/>
 <jsp:setProperty property = "*" name = "memberbean"/>
 

 
<%--
3. DB에 회원 추가(insert)를 위해 MemberDAO객체를 Action태그로 생성하여 MemberDAO객체의 insertMember메소드 호출 시
MemberBean객체를 매개변수로 전달하여 작업
참고 : MemberDAO클래스 내부에 insertMember메소드를 만들어야 호출 가능
--%>
<jsp:useBean id="memberdao" class = "member.MemberDAO"/>

<%
	memberdao.modifyMember(memberbean);
	
	//4. 회원가입 성공시 login.jsp로 포워딩
	response.sendRedirect("../index.jsp");
%>
 