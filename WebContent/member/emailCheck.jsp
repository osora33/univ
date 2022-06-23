<%@page import="member.EmailConfirm"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<script src = "https://code.jquery.com/jquery-3.5.1.js"></script>
<script>
function confirmemail(emailconfirm_value, authNum){
    // 입력한 값이 없거나, 인증코드가 일지하지 않을 경우
	if(!emailconfirm_value || emailconfirm_value != authNum){
		alert("인증코드가 일치하지 않습니다");
		emailconfirm_value="";
    // 인증코드가 일치하는 경우
	}else if(emailconfirm_value==authNum){
		alert("인증 완료되었습니다");
		emailconfirm_value="";
		self.close();
		$(opener.document).find("#emailconfirm_value").attr("value", "1");
		$(opener.document).find("#email").attr("readonly", "readonly");
		$(opener.document).find("#emailconfirm_btn").attr("value", "인증 완료");
		$(opener.document).find("#emailconfirm_btn").prop("disabled", true);
	}
}
</script>
<%
	String email=request.getParameter("email");
	
	// 위에서 작성한 java파일 객체 생성
	EmailConfirm emailconfirm = new EmailConfirm();
	String authNum=emailconfirm.connectEmail(email);
%>
<form method="post" action="" name="emailcheck" style="text-align: center;">
	<br>인증번호를 입력하세요<br><br>
	<input type="text" name="emailconfirm">
	<input type="button" value="확인" 
	onclick="confirmemail(emailcheck.emailconfirm.value, <%=authNum%>)"
	style="width: 50px; border: none; border-radius: 20px 20px 20px 20px; text-align: center;">
</form>