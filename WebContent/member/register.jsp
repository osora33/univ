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
<%
response.setHeader("Access-Control-Allow-Origin","*");
%>
<script>
	//중복체크 버튼을 눌렀을 때 호출되는 함수
	//아래의 <input>에서 입력한 ID를 얻어 DB에 존재하는 ID와 중복되는지 요청할 수 있는 함수
		function dup(){
			var id = $("#id").val();		//서블릿(서버페이지)으로 요청하는 파라미터
			if(id == ''){		//아이디를 입력하지 않았다면
				alert("아이디를 입력하세요");
				return;
			}
			//아이디를 입력했다면 ajax기술을 이용하여 서버페이지로 아이디 중복확인을 요청
			$.ajax({
				type : "post",
				async : true,
				url : "http://localhost:8080/univ/dup",
				dataType : "text",
				data : {id:id},		//입력한 ID를 서블릿으로 요청시 요청할 데이터로 전송
				success : function(data, textStatus){
					//서블릿(서버가 실행하는 페이지)에서 전송되어 오는 응답메세지를 data 매개변수로 전달받아 아래의 div태그영역에 표시
					if(data == "usable"){		//아이디가 중복이 아닐 경우
						//아래의 div 요소를 선택해 가져와서 text로 메세지 정보를 출력
						$("#message").text("사용할 수 있는 아이디입니다");
						//사용할 수 있는 ID이므로 ID 중복체크버튼을 비활성화시킴
						$("#id").attr("readonly", true);
					}else{		//아이디가 중복이면
						//아래의 div 요소를 선택해 가져와서 text로 메세지 정보를 출력
						$("#message").text("사용할 수 없는 아이디입니다");
					}
				},
				error : function(data, textStatus){
					alert(data);
					alert("에러 발생");
				}
			});
		}
	
	function frck(){
		var id = document.fr.id.value;
		var id_ck = document.fr.message;
		var pass = document.fr.pass.value;
		var pass_ck = document.fr.pass_ck.value;
		var name = document.fr.name.value;
		var email = document.fr.email.value;
		var emailconfirm_value = document.fr.emailconfirm_value.value;
		var postcode = document.fr.postcode.vale;
		var addr = document.fr.addr.value;
		var detail_addr = document.fr.detail_addr.value;
		
		if(id == ""){
			alert("아이디를 입력해 주십시오");
			return;
		}else if($("#message").text() != "사용할 수 있는 아이디입니다"){
			alert("아이디 중복확인을 해 주십시오");
			return;
		}else if(pass == ""){
			alert("비밀번호를 입력해 주십시오");
			return;
		}else if(pass != pass_ck){
			alert("비밀번호 확인이 일치하지 않습니다");
			return;
		}else if(name == ""){
			alert("이름을 입력해 주십시오");
			return;
		}else if(emailconfirm_value != 1){
			alert("이메일 인증을 해 주십시오");
			return;
		}else if(postcode == "" || addr == ""){
			alert("주소를 입력해 주십시오");
			return;
		}else if(detail_addr == ""){
			alert("상세주소를 입력해 주십시오");
			return;
		}else{
			document.fr.submit();
		}
	}
	
	function emailcheck(email){
		if(document.fr.email.value == ""){
			alert("이메일을 입력해 주십시오");
		}else{
			// 인증을 위해 새창으로 이동
			var url="emailCheck.jsp?email="+email;
			open(url,"emailwindow", "statusbar=no, scrollbar=no, menubar=no, width=300, height=130, left=800, top=450" );
		}
	}
	
	function getAddressInfo(){
		new daum.Postcode({
			oncomplete: function(data) {
				// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

				// 각 주소의 노출 규칙에 따라 주소를 조합한다.
				// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
				var addr = ''; // 주소 변수
				var extraAddr = ''; // 참고항목 변수

				//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
				if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
					addr = data.roadAddress;
				} else { // 사용자가 지번 주소를 선택했을 경우(J)
					addr = data.jibunAddress;
				}

				// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
				if(data.userSelectedType === 'R'){
					// 법정동명이 있을 경우 추가한다. (법정리는 제외)
					// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
					if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
						extraAddr += data.bname;
					}
					// 건물명이 있고, 공동주택일 경우 추가한다.
					if(data.buildingName !== '' && data.apartment === 'Y'){
						extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
					}
					// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
					if(extraAddr !== ''){
						extraAddr = ' (' + extraAddr + ')';
					}
				}

				// 우편번호와 주소 정보를 해당 필드에 넣는다.
				document.getElementById('postcode').value = data.zonecode;
				document.getElementById("addr").value = addr + extraAddr;
				// 커서를 상세주소 필드로 이동한다.
				document.getElementById("detail_addr").focus();
				}
			}).open();
	}
</script>

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
					Community<br> Registration Page
				</h2>
				<p>Register from here to access.</p>
			</div>
		</div>
		<div class="main">
			<div class="col-md-6 col-sm-12">
				<div class="register-form">
					<form class="form" action="registerPro.jsp" method="post" name="fr">
						<div class="form-group">
							<label>아이디</label>	<input type="button" value="중복확인" class="btn-dup" id = "btn-dup" onclick="dup();"><label id = "message"></label>
							<input type="text" class="form-control" id="id" name="id" placeholder="아이디" >
						</div>
						<div class="form-group">
							<label>비밀번호</label> 
							<input type="password" class="form-control" id="pass" name="pass" placeholder="비밀번호">
						</div>
						<div class="form-group">
							<label>비밀번호 확인</label>
							<input type="password" class="form-control" id="pass_ck" name="pass_ck" placeholder="비밀번호 확인">
						</div>
						<div class="form-group">
							<label>이름</label> 
							<input type="text" class="form-control" id="name" name="name" placeholder="이름">
						</div>
						<div class="form-group">
							<label>이메일</label> <input type="button" value="이메일 인증" class="btn-email"" name="emailconfirm_btn" id="emailconfirm_btn" onclick="emailcheck(document.fr.email.value)">
							<input type="email" class="form-control" id="email" name="email" placeholder="***@hanguk.ac.kr">
							<input type = "hidden" id = "emailconfirm_value" name = "emailconfirm_value">
						</div>
						<div class="form-group">
							<label>주소</label> <input type="button" value="우편번호 찾기" class="btn-addr" onclick="getAddressInfo();">
							<input type="text" class="form-control" id="postcode" name="postcode" placeholder="우편번호" readonly>
							<input type="text" class="form-control" id="addr" name="addr" placeholder="주소" readonly>
							<input type="text" class="form-control" id="detail_addr" name="detail_addr" placeholder="상세주소">
						</div>
						<input type = "button" class="btn btn-black" onclick="frck();" value="Register">
						<button type = "reset" class="btn btn-secondary">Reset</button>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>