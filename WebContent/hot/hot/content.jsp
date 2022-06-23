<%@page import="hot.HotDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	request.setCharacterEncoding("utf-8");

	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	
	HotDAO dao = new HotDAO();
	String table = dao.getTable(num);
	int originNum = dao.getOriginNum(num);
	
	if(table.equals("board")){
		response.sendRedirect("freeboardContent.jsp?hotNum="+num+"&pageNum="+pageNum+"&table="+table+"&originNum="+originNum);
	}else if(table.equals("anonymous")){
		response.sendRedirect("anonymousContent.jsp?hotNum="+num+"&pageNum="+pageNum+"&table="+table+"&originNum="+originNum);
	}else if(table.equals("sell")){
		response.sendRedirect("sellContent.jsp?hotNum="+num+"&pageNum="+pageNum+"&table="+table+"&originNum="+originNum);
	}else if(table.equals("buy")){
		response.sendRedirect("buyContent.jsp?hotNum="+num+"&pageNum="+pageNum+"&table="+table+"&originNum="+originNum);
	}else if(table.equals("exam")){
		response.sendRedirect("examContent.jsp?hotNum="+num+"&pageNum="+pageNum+"&table="+table+"&originNum="+originNum);
	}else if(table.equals("ect")){
		response.sendRedirect("ectContent.jsp?hotNum="+num+"&pageNum="+pageNum+"&table="+table+"&originNum="+originNum);
	}

%>