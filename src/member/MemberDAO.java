package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import board.BoardBean;

//자바빈 클래스의 종류 중 DAO역할을 하는 클래스. DB연결 후 작업하는 클래스(비즈니스 로직을 처리하는 클래스)
public class MemberDAO {
	
	Connection con = null;		//DB와 미리 연결을 맺은 접속을 나타내는 객체를 저장할 조상 인터페이스 타입의 변수
	PreparedStatement pstmt = null;		//DB(jsbbeginner)에 SQL문을 전송해서 실행할 객체를 저장할 변수
	ResultSet rs = null;		//DB에 select 검색한 결과 데이터들을 임시로 저장해 놓을 수 있는 ResultSet객체를 저장할 변수
	
	//DataSource 커넥션풀을 얻고 커넥션풀 내부에 있는 Connection 객체를 얻는 메소드
	private Connection getConnection() throws Exception{
		
		//톰캣이 각 프로젝트에 접근할 수 있는 Context객체의 경로를 알고 있는  객체
		Context init = new InitialContext();
		
		//DataSource커넥션풀 얻기
		DataSource ds = (DataSource)init.lookup("java:comp/env/jdbc/univ");
		
		//DataSource커넥션풀 내부에 있는 Connection객체 얻기
		con = ds.getConnection();
		
		return con;		//DB와 미리 연결을 맺으 놓은 접속을 나타내는 Connection  객체 반환
	}//getConnection메소드 끝
	
	public void 자원해제(){
		try{
			if(pstmt != null){
				pstmt.close();
			}
			if(rs != null){
				rs.close();
			}
			if(con != null){
				con.close();
			}
		}catch(Exception exception){
			System.out.println("자원 해제 실패 : " + exception);
		}
	}
	
	//joinPro.jsp에서 호출하는 메소드로 입력한 회원정보를 DB에 추가하는 메소드
	public void insertMember(MemberBean memberbean){
		
		String sql = "";
		int no = 0;
		
		try{
			//커넥션풀에서 커넥션객체 얻기(DB연결)
			con = getConnection();
			//DB에 저장된 글의 가장 최신 글번호 검색해 오는 SELECT문
			sql = "select max(no) from member";
			//참고 : DB에 글이 저장되어 있지 않는경우  새로추가할 글번호 는? 1
			//      DB에 글이 저장되어 있는 경우  검색한 가장 최신글번호 + 1 데이터를 새로추가할 글번호로 지정
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()){//가장 최근 가입한 회원이 검색된다면?
				//가장최근 가입한 회원번호 + 1 데이터를 새로 추가할 글번호로 지정
				no = rs.getInt(1) + 1;
			}else{//가장 최근 가입한 회원이 검색되지 않으면?(DB에 글이 없다면)
				no = 1; //새로추가할 글번호를 1로 설정 
			}
			
			//2. insert문장 만들기
			sql = "insert into member(no,id,pass,name,email,postcode,addr) values(?,?,?,?,?,?,?)";
			
			//3. PreparedStatement insert실행 객체 얻기
			pstmt = con.prepareStatement(sql);
			//3-1. ?기호에 대응되는 값을 입력한 가입할 내용으로 설정
			pstmt.setInt(1, no);
			pstmt.setString(2, memberbean.getId());
			pstmt.setString(3, memberbean.getPass());
			pstmt.setString(4, memberbean.getName());
			pstmt.setString(5, memberbean.getEmail());
			pstmt.setString(6, memberbean.getPostcode());
			pstmt.setString(7, memberbean.getAddr() + " " + memberbean.getDetail_addr());

			//4. insert문장을 DB에 전송하여 실행
			pstmt.executeUpdate();

		}catch(Exception exception){
			System.out.println("insertMember 내부에서 오류 : " + exception);
		}finally{
			//5. 자원해제
			자원해제();
		}
	}//insertMember메소드 끝
	
	//회원가입을 위해 사용자가 입력한 id를 매개변수로 전달받아 DB에 저장된 id와 비교하여 중복체크하여 판단 후 반환하는 메소드
	public int idCheck(String id){
		String sql = "";
		
		//중복여부의 판단 데이터를 저장할 변수 선언
		int check = 0;
		
		try{
			//DataSource에서 Connection얻기(DB연결)
			con = getConnection();
			
			//매개변수로 전달받은 입력한 아이디에 해당되는 회원 검색 select문장 만들기
			sql = "select * from member where id = ?";
			
			//select문장을 실행할 PreparedStatement실행 객체 얻기
			pstmt = con.prepareStatement(sql);
			//?값 설정
			pstmt.setString(1, id);
			
			//DB에 select 전송하여 실행 후 검색한 회원 한사람에 대한 정보를 ResultSet객체에 담아 반환
			rs = pstmt.executeQuery();
			
			if(rs.next()){		//입력한 아이디에 해당되는 회원이 조회되면	->		입력한 아이디가 DB에 저장되어 있으면
				check = 1;		//아이디 중
			}else{		//입력한 아이디가 DB에 존재하지 않으면
				check = 0;
			}
		}catch(Exception exception){
			System.out.println("idCheck메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return check;		//join_IDCheck.jsp로 리턴
	}//idCheck메소드 끝
	
	//loginPro.jsp에서 호출하는 메소드로 사용자로부터 입력받은 id, pwd를 매개변수로 전달받아
	//DB에 존재하는 id, pwd가 같으면 로그인 처리하는 메소드
	public int userCheck(String id, String pass){
		int check = -1;		//1 : 아이디 비밀번호 일치	/	0 : 아이디 일치, 비밀번호 불일치	/	-1 : 아이디 불일치
		try{
			con = getConnection();
			
			//매개변수로 전달받은 입력한 id에 해당하는 회원 검색 sql문
			String sql = "select * from member where id = ?";
			
			//PreparedStatement 실행 객체 얻기
			pstmt = con.prepareStatement(sql);
			
			//? 설정
			pstmt.setString(1, id);
			
			//입력한 id에 해당되는 회원 검색 후 얻기
			rs = pstmt.executeQuery();
			
			if(rs.next()){		//입력한 id가 DB에 존재
				if(pass.equals(rs.getString("pass"))){		//아이디 비밀번호 일치
					check = 1;
				}else{		//아이디 일치, 비밀번호 불일치
					check = 0;
				}
			}else{		//입력한 id가 DB에 존재하지 않음
				check = -1;
			}
		}catch(Exception exception){
			System.out.println("userCheck메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return check;
	}
	
	//서블릿에서 전달된 입력한 ID로 SQL문의 조건식에 설정한 후
	   //입력한 ID에 해당되는 회원정보를 조회하여 그 결과를 true 또는 false로 반환함
	   public boolean overlappedID(String id){
	      
	      boolean result = false;
	      
	      try{
	         //커넥션풀(DataSource)공간에서 커넥션(Connection)객체를 빌려옴
	         //DB접속
	         con = getConnection();

	         //오라클 decode()함수를 이용하여 서블릿에서 전달된 입력한 ID에 해당하는 데이터를 검색하여
	         //true 또는 false를 반환하는데
	         //검색한 갯수가 1(검색한 레코드가 존재하면)이면 true를 반환
	         //존재하지 않으면 false를 문자열로 반환하여 조회하는 SQL문
	         String query = "select (case count(*) when 1 then 'true' else 'false' end) as result from member where id = ?";
	               
	         pstmt = con.prepareStatement(query);
	         pstmt.setString(1, id);
	         rs = pstmt.executeQuery();
	         rs.next();
	         
	         //문자열 "true" 또는 "false"를 Boolean클래스의 parseBoolean(String value)메소드를 호출해
	         //Boolean데이터로 변환해서 반환함
	         result = Boolean.parseBoolean(rs.getString("result"));
	         
	         
	      }catch(Exception e){
	         e.printStackTrace();
	      }finally {
	         자원해제();
	      }
	      return result;//MemberServlet서블릿으로  true 또는 false반환
	   }
	//loginPro.jsp에서 호출하는 메소드로 사용자로부터 입력받은 id, pwd를 매개변수로 전달받아
	//DB에 존재하는 id, pwd가 같으면 로그인 처리하는 메소드
	public int passCheck(String id, String pass){
		int check = -1;		//1 : 비밀번호 일치	/	0 : 비밀번호 불일치
		try{
			con = getConnection();
				
			//매개변수로 전달받은 입력한 id에 해당하는 회원 검색 sql문
			String sql = "select * from member where id = ?";
				
			//PreparedStatement 실행 객체 얻기
			pstmt = con.prepareStatement(sql);
			
			//? 설정
			pstmt.setString(1, id);
				
			//입력한 id에 해당되는 회원 검색 후 얻기
			rs = pstmt.executeQuery();
				
			if(rs.next()){		//입력한 비밀번호가 DB에 존재
				if(pass.equals(rs.getString("pass"))){		//아이디 비밀번호 일치
					check = 1;
				}else{		//아이디 일치, 비밀번호 불일치
					check = 0;
				}
			}
		}catch(Exception exception){
			System.out.println("passCheck메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return check;
	}
	
	//DB로 부터 모든 직원 정보를 조회하여 얻는 메소드
	//index.jsp에서 요청한 겁색기준값과 검색어를 매개변수로 넘겨받아 검색어를 입력하지 않았따면 모든 직원을 검색하여 ArrayList에 담는다
	//그 후 ArrayList배열을 반환
	public MemberBean userInfo(String id){	//검색기준값, 검색어를 매개변수로 받음
		//검색한 모든 직원정보들을 저장할 가변길이 배열 ArrayList생성
			
		//조건에 따라 select문장을 저장할 변수 선언
		String sql = " ";
		MemberBean memberbean = new MemberBean();
		try{
			//1. 커넥션풀로부터 커넥션 객체 빌려오기(DB연결)
			con = getConnection();
			//2. SQL문 만들기(select)
			//검색어가 입력되었는지 파악하여 select문장 완성
			sql = "select * from member where id = ?";
			
			//3. SQL문장을 실행할 PreparedStatement객체 얻기
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			//4. SQL문장 select 실행
			rs = pstmt.executeQuery();
				
			//setter메소드 호출하여 SawonDto객체의 각 변수에 저장
			if(rs.next()){
				memberbean.setPass(rs.getString("pass"));
				memberbean.setName(rs.getString("name"));
				memberbean.setEmail(rs.getString("email"));
				memberbean.setPostcode(rs.getString("postcode"));
				memberbean.setAddr(rs.getString("addr"));
			}
			
			pstmt.executeQuery();
		}catch(Exception exception){
			System.out.println("userInfo메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		//7. ArrayList배열을 index.jsp로 리턴(반환)
		return memberbean;
	}//getList메소드 끝
	
	//매개변수로 전달받은 입력한 수정할 내용을 DB에 update할 메소드
	public void modifyMember(MemberBean memberbean){
		//매개변수로 전달받은 SawonDto객체의 no 변수에 저장된 직원번호에 해당되는 직원의 정보 수정
		String sql = "update member set pass = ?, name = ?, email = ?, postcode = ?, addr = ? where id = ?";
			
		try{
			//커넥션풀 내부에 있는 커넥션 얻기(DB접속)
			con = getConnection();
				
			//PreparedStatement실행객체 얻기
			pstmt = con.prepareStatement(sql);
				
			//?기호에 대응되는 값을 매개변수로 전달받은 SawonDto객체의 각 변수에 저장된 값으로 설정
			pstmt.setString(1, memberbean.getPass());
			pstmt.setString(2, memberbean.getName());
			pstmt.setString(3, memberbean.getEmail());
			pstmt.setString(4, memberbean.getPostcode());
			pstmt.setString(5, memberbean.getAddr() + " " + memberbean.getDetail_addr());
			pstmt.setString(6, memberbean.getId());
				
			//update 실행
			pstmt.executeUpdate();
				
		}catch(Exception exception){
			System.out.println("modifySawon메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
	}//modifySawon메소드 끝
	
	public void secessionMember(String id){
		try{
			con = getConnection();
			
			String sql = "delete from member where id =?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
			
		}catch(Exception e){
			System.out.println("secessionMember 메소드 내부에서 오류 : " + e);
		}finally{
			자원해제();
		}
	}
	
	public MemberBean getEmail(String id){
		
		MemberBean bean = new MemberBean();

		try{
			con = getConnection();
			String sql = "select * from member where id=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			rs.next();
			String email = rs.getString("email");
			String name = rs.getString("name");
			
			bean.setEmail(email);
			bean.setName(name);
			
		}catch(Exception e){
			System.out.println("getEmail메소드 내부에서 오류 : " + e);
		}finally{
			자원해제();
		}
		return bean;
	}
	
	public void sendEmail(MemberBean bean){
		
		String to1= "hangukinhand@gmail.com"; // 인증위해 사용자가 입력한 이메일주소
		String host="smtp.gmail.com"; // smtp 서버
		String subject=bean.getSubject(); // 보내는 제목 설정
		String fromName=bean.getName(); // 보내는 이름 설정
		String from="hangukinhand@gmail.com"; // 보내는 사람(구글계정)
		String content=bean.getEmail() + "<br>" + bean.getContent().replace("\r\n", "<br>"); // 이메일 내용 설정
		
		System.out.println("a : " +fromName);
		
        // SMTP 이용하기 위해 설정해주는 설정값들
		try{
		Properties props=new Properties();
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.transport.protocol", "smtp");
		props.put("mail.smtp.host", host);
		props.setProperty
                       ("mail.smtp.socketFactory.class",
                        "javax.net.ssl.SSLSocketFactory");
		props.put("mail.smtp.port","465");
		props.put("mail.smtp.user",from);
		props.put("mail.smtp.auth","true");
		
		Session mailSession 
           = Session.getInstance(props,new javax.mail.Authenticator(){
			    protected PasswordAuthentication getPasswordAuthentication(){
				    return new PasswordAuthentication
                                        ("hangukinhand@gmail.com","dbsgusgh33"); // gmail계정
			}
		});
		
		Message msg = new MimeMessage(mailSession);
		InternetAddress []address1 = {new InternetAddress(to1)};
		msg.setFrom(new InternetAddress(from, MimeUtility.encodeText(fromName,"utf-8","B")));
		msg.setRecipients(Message.RecipientType.TO, address1); // 받는사람 설정
		msg.setSubject(subject); // 제목설정
		msg.setSentDate(new java.util.Date()); // 보내는 날짜 설정
		msg.setContent(content,"text/html; charset=utf-8"); // 내용설정
		
		Transport.send(msg); // 메일보내기
		}catch(MessagingException e){
			e.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
