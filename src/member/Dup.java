package member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//서버페이지 : 서블릿
//클라이언트페이지인 ajax2.html페이지에서 Ajax기술로 메세지를 요청하면 처리하는 서블릿입니다.
//웹브라우저에서 매개변수 이름인 param으로 데이터를 보내면  getParameter()메소드를 이용해 요청한 데이터를 가져옵니다
//그리고 서블릿에서는 PrintWriter객체의 print()메소드의 인자로 응답 메세지를 웹브라우저로 내보냅니다.
//웹브라우저로 내보낸 응답 메세지는 웹브라우저를 거쳐 요청한  ajax2.html의  $.ajax메소드의 success속성에 전달됨
@WebServlet("/dup")
public class Dup extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doHandle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 한글처리
		request.setCharacterEncoding("UTF-8");
		// 응답할 데이터 형식 설정
		response.setContentType("text/html;charset=utf-8");
		
		response.setHeader("Access-Control-Allow-Origin","*");

		// 클라이언트의 웹브라우저로 응답할(출력할) 스트림통로 객체 생성
		PrintWriter writer = response.getWriter();

		//1. 요청한 값 얻기(ajax3.html에서 입력한 아이디 얻기)
		String id = request.getParameter("id");		//data : {id : _id}의 id
		
		//2. 응답할 값 마련(MemberDAO객체의 overLappedID(String id)메소드 호출 시 입력한 아이디를 전달하여 DB에 저장된 아이디와 비교하여 중복체크하는 값 얻기)
		MemberDAO memberDAO = new MemberDAO();
		//ID중복여부 체크하기 위해 메소드 호출 후 반환받기
		boolean overlappedID = memberDAO.overlappedID(id);
		
		//3. 응답 -> 웹브라우저 거쳐 -> ajax 기술로 요청한 ajax3.html로 전달
		if(overlappedID == true){
			writer.print("not_usable");
		}else{
			writer.print("usable");
		}
	}
}