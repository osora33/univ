<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Hanguk.in.hand</title>

<link
	href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900|Quicksand:400,700|Questrial"
	rel="stylesheet" />
<link href="../css/fonts.css" rel="stylesheet" type="text/css" media="all" />
<link href="../css/member.css" rel="stylesheet" type="text/css">
<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>

<%
	String recentURI = (String)request.getHeader("REFERER");
%>

</head>
<body>
	<div id="wrap">
		<div class="sidenav">
			<div id="logo">
				<h3>
					<a href="../index.jsp">Hanguk.in.hand</a>
				</h3>
			</div>
			<div class="login-main-text">
				<h2>
					Community<br> Login Page
				</h2>
				<p>Login or register from here to access.</p>
			</div>
		</div>
		<div class="main">
			<div class="col-md-6 col-sm-12">
				<div class="login-form">
					<form action="loginPro.jsp" method="post" name="fr">
						<input type="hidden" name="from" value="<%=recentURI%>" >
						<div class="form-group">
							<label>아이디</label> 
							<input type="text" class="form-control" name="id" placeholder="아이디">
						</div>
						<div class="form-group">
							<label>비밀번호</label> 
							<input type="password" class="form-control" name="pass" placeholder="비밀번호">
						</div>
						<button type="submit" class="btn btn-black">Login</button>
						<input type = "button" class="btn btn-secondary" onclick="location.href='register.jsp'" value = "Register">
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>