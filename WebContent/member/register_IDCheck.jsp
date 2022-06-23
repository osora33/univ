<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript" src = "https://code.jquery.com/jquery-3.5.1.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link href="../css/member.css" rel="stylesheet" type="text/css">
</head>
	
<script>
	//6. 이 아이디를 사용 버튼을 눌렀을 때 호출되는 메소드. 
	//join_IDCheck.jsp(팝업창, 자식창)에 입력되어있는 아이디값을 join.jsp(부모창)의 아이디 입력 <input>태그에 넣어주고 팝업창 닫기
	function result(){
// 		opener.document.fr.id.value = document.nfr.userid.value;
		$(opener.document).find("#id").attr("value", $("#userid").val());
		
		//팝업창 닫기
		window.close();
	}
	function fn_press_han(obj){
		//좌우 방향키, 백스페이스, 딜리트, 탭키에 대한 예외
		if(event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39
		|| event.keyCode == 46 ) return;
		//obj.value = obj.value.replace(/[\a-zㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
		obj.value = obj.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
	}
</script>

<body class="IDCheck">
		
	
	<%
		request.setCharacterEncoding("utf-8");
		//1. join.jsp의 function winopen()함수에 의해서 전달받은 입력한 아이디 얻기
		//2. 아래의 중복 확인 버튼 눌렀을 때 <form>태그로부터 전달받은 아이디 얻기
		String id = request.getParameter("userid");
		
		//3. DB에 저장된 아이디와 회원가입을 위해 입력한 아이디를 비교
		//MemberDAO객체를 생성하여 메소드 호출시 입력한 아이디를 매개변수로 전달하여 DB작업
		MemberDAO mdao = new MemberDAO();
		//아이디 중복 체크 유무 반환받기
		int check = mdao.idCheck(id);
		
		//4. check == 1일 경우 "사용중인 ID입니다" 출력
		//		check == 0일 경우 "사용 가능한 ID입니다" 출력
		if(id == ""){
			out.print("아이디를 입력해 주십시오");
		}else if(check == 1){
			out.println(id + " -  사용중인 ID입니다");
		}else{
			out.println(id + " -  사용 가능한 ID입니다");
	%>
			<!-- 5. 사용 가능한 아이디이므로 버튼을 눌러 부모창에 사용 가능한 아이디 출력 -->
			<br><input type = "button" value = "사용" onclick = "result()" class = "btn-dup2">
	<%
		}
	%>
	
	<!-- 위 1에서 입력한 아아디를 아래의 디자인 <input>에 출력해주고 확인 후 중복확인버튼 클릭하여 현재 페이지인 join_IDCheck.jsp페이지로 중복확인 요청 -->
	<form action = "register_IDCheck.jsp" method = "post" name = "nfr">
		<br>
		<input type = "text" name = "userid" class="userid" id ="userid" onkeydown="fn_press_han(this);" style="ime-mode:disabled;">
		<br>
		<input type = "submit" value = "중복확인"  class = "btn-dup2">
	</form>
</body>
</html>