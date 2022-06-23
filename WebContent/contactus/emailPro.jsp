<%@page import="member.MemberBean"%>
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	
	String id = (String)session.getAttribute("id");
	String email = request.getParameter("email");
	String name = request.getParameter("name");
	String subject = request.getParameter("subject");
	String content = request.getParameter("content");
	
	MemberBean bean = new MemberBean();
	bean.setId(id);
	bean.setEmail(email);
	bean.setName(name);
	bean.setSubject(subject);
	bean.setContent(content);
	
	MemberDAO dao = new MemberDAO();
	dao.sendEmail(bean);
	
	response.sendRedirect("../index.jsp");
%>

