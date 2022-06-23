<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Hanguk.in.hand</title>
<script src = "https://code.jquery.com/jquery-3.5.1.js"></script>
<link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900|Quicksand:400,700|Questrial" rel="stylesheet" />
<link href="../css/fonts.css" rel="stylesheet" type="text/css" media="all" />
<link href="../css/member.css" rel="stylesheet" type="text/css">
<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>

</head>
<body>
	<%
	String id = (String)session.getAttribute("id");
	%>
	<div id="wrap">
		<div class="sidenav">
			<div id="logo">
				<h3>
					<a href="../index.jsp">Hanguk.in.hand</a>
				</h3>
			</div>
			<div class="login-main-text">
				<h2>
					Member Information<br> Modifying Page
				</h2>
				<p>Modify your information here.</p>
			</div>
		</div>
		<div class="main">
			<div class="col-md-6 col-sm-12">
				<div class="modify-form">
					<form class="form" action="modifyPro.jsp" method="post" name="fr">
						<div class="form-group">
							<label>비밀번호 확인</label>
							<input type="password" class="form-control" id="pass" name="pass" placeholder="비밀번호 확인">
							<input type="hidden" id="id" name="id" value = "<%=id%>">
						</div>
						<div class = "button-div" style="float: right;">
							<button type = "submit" class="btn btn-black">Check</button>
							<button type = "reset" class="btn btn-secondary">Reset</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>