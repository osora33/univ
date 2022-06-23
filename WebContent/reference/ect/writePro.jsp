<%@page import="ect.EctDAO"%>
<%@page import="ect.EctBean"%>
<%@page import="com.mysql.jdbc.StringUtils"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="sell.SellBean"%>
<%@page import="sell.SellDAO"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="board.BoardBean"%>
<%@page import="board.BoardDAO"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//세션영역에 저장된 값 얻기(로그인 하지 않고 글쓰기 작업시 로그인창으로 이동시키기 위해)
	String id = (String)session.getAttribute("id");

	//세션영역에 값이 저장되어 있지 않을 경우
	if(id == null){
		response.sendRedirect("../member/login.jsp");
	}

    request.setCharacterEncoding("utf-8");
    // C: 드라이브에 미리 test라는 폴더를 만들어 놓으세요
			String savePath = "D:\\Coding\\javascript_workspace\\univ\\WebContent\\reference\\upload"; // 저장할 디렉토리 (절대경로)
			int sizeLimit = 100 * 1024 * 1024; // 10메가까지 제한 넘어서면 예외발생
			String fileName = "";
			String originalFileName = "";
			try {
				MultipartRequest multi = 
				        new MultipartRequest(request, savePath, sizeLimit, "utf-8",
											 new DefaultFileRenamePolicy());
				Enumeration formNames = multi.getFileNames(); // 폼의 이름 반환
				String formName = (String)formNames.nextElement(); // 자료가 많을 경우엔 while 문을 사용
				System.out.println(formName);
				fileName = multi.getFilesystemName(formName); // 파일의 이름 얻기
				originalFileName = multi.getOriginalFileName(formName); //원래 이름 가져오기
				String userName = "";
				
				
				
				String name = multi.getParameter("name");
				String subject = multi.getParameter("subject");
				String content = multi.getParameter("content");
				
				Timestamp timestamp = new Timestamp(System.currentTimeMillis());
				String ip = request.getRemoteAddr();

				if (fileName == null) { // 파일이 업로드 되지 않았을때
%>
					<script>
						alert("파일을 업로드해 주십시오");
						history.go(-1);
					</script>
<%
				} else { // 파일이 업로드 되었을때
				 	//3. Boardean객체를 생성하여 DB에 추가할 글 내용 저장
				 	EctBean ectbean = new EctBean();
				     //set으로 시작하는 메소드들을 호출하여 각 변수에 저장
				     ectbean.setContent(content);
				     ectbean.setSubject(subject);
				     ectbean.setName(name);
				     ectbean.setDate(timestamp);
				     ectbean.setIp(ip);
				     ectbean.setFile(fileName);
				    
				     //4. galaryDAO 객체를 생성하여 새로운 글 내용을 추가할 insertgalary 메소드 호출시 galaryBean 객체를 전달
				     EctDAO dao = new EctDAO();
				     dao.insertEct(ectbean);
				    
				     //5. DB에 글 추가가 성공되었다면 notice.jsp 게시판 목록 화면을 재요청해 이동
				     response.sendRedirect("ect.jsp");
				} //else 끝
			} catch (Exception e) {
				out.print("예외 상황 발생..! ");
			} //catch
 %>
