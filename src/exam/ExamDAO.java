package exam;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//자바빈 클래스의 종류중 DAO역할을 하는 클래스
//DB연결 후 작업하는 클래스 (비즈니스로직을 처리하는 클래스)
public class ExamDAO {
	
	Connection con = null; //DB와 미리연결을 맺은 접속을 나타내는 객체를 저장할 조상 인터페이스 타입의 변수 
	PreparedStatement pstmt = null; //DB(jspbeginner)에 SQL문을 전송해서 실행할 객체를 저장할 변수 
	ResultSet rs = null;//DB에 SELECT검색한 결과데이터들을 임시로 저장해 놓을 수 있는
						//ResultSet객체를 저장할 변수 
	
	
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
	
	//DB에 새글 추가 메소드
	public void insertExam(ExamBean eBean){
		
		//DB에 추가할 글번호를 저장할 변수 
		int num = 0;
		
		//SQL문 저장할 변수선언
		String sql = "";
		
		try {
			//커넥션풀에서 커넥션객체 얻기(DB연결)
			con = getConnection();
			
			//DB에 저장된 글의 가장 최신 글번호 검색해 오는 SELECT문
			sql = "select max(num) from exam";
			//참고 : DB에 글이 저장되어 있지 않는경우  새로추가할 글번호 는? 1
			//      DB에 글이 저장되어 있는 경우  검색한 가장 최신글번호 + 1 데이터를 새로추가할 글번호로 지정
			
			pstmt = con.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()){//가장 최신 글번호가 검색된다면?
				//가장최신 글번호  + 1 데이터를 새로 추가할 글번호로 지정
				num = rs.getInt(1) + 1;
			}else{//가장 최신 글번호가 검색되지 않으면?(DB에 글이 없다면)
				num = 1; //새로추가할 글번호를 1로 설정 
			}
			
			sql = "insert into exam(num,name,"
				+ "subject,content,readcount,date,ip,imgPath,file)"
				+ "values(?,?,?,?,?,?,?,?,?);";
			
			String content = eBean.getContent();
		 	Pattern pattern  =  Pattern.compile("<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>");
		 	Matcher match = pattern.matcher(content);
		 	String imgPath = null;
		 	if(match.find()){ // 이미지 태그를 찾았다면,,
		 	    imgPath = match.group(0); // 글 내용 중에 첫번째 이미지 태그를 뽑아옴.
		 	}
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);//추가할 새글의 글번호
			pstmt.setString(2, eBean.getName());//새글을 작성한 사람의 이름(id)
			pstmt.setString(3, eBean.getSubject());//추가할 새글의 제목
			pstmt.setString(4, eBean.getContent());//글내용
			pstmt.setInt(5, 0); //추가하는 새글의 조회수 0
			pstmt.setTimestamp(6, eBean.getDate()); //새글을 추가한 날짜 정보 
			pstmt.setString(7, eBean.getIp());//새글을 작성한 사람의  IP주소 정보 
			pstmt.setString(8, imgPath);
			pstmt.setString(9, eBean.getFile());
			
			
			//insert문장 실행
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("insertExam메소드 내부에서 실행 오류 : " + e);
		} finally {
			자원해제();
		}	
	}//insertBoard메소드 끝
	
	//DB에 저장된 전체 글 개수를 검색해서 반환하는 메소드
	public int getExamCount(){
		int count = 0;
		
		String sql = "";
		
		try{
			//DB연결
			con = getConnection();
			
			//전체 글 수 조회
			sql = "select count(*) from exam";
			
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				count = rs.getInt(1);
			}
		}catch(Exception exception){
			System.out.println("getExamCount메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return count;
	}
	
	//notice.jsp페이지에서 호출하는 메소드로 
	//각 페이지마다 처음으로 보여질 시작 글번호와 한 페이지당 보여질 글 개수를 매개변수로 전달받아
	//한 페이지당 보여질 글 개수만큼 검색해서 가져오는 메소드
	public List<ExamBean> getExamList(int startRow, int pageSize){
		List<ExamBean> examList = new ArrayList(); 
		String sql = "";
		
		try{
			con = getConnection();		//DB연결
			
			//select문장 만들기. re_ref 내림차순 정렬 후 re_seq 오름차순 정렬
			//limit 각 페이지마다 첫번째로 보여질 시작글 번호, 한페이지당 보여줄 글개수
			sql = "select * from exam order by num desc limit ?, ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, pageSize);
			
			rs = pstmt.executeQuery();
	
			int num = 0;
			
			while(rs.next()){
				ExamBean eBean = new ExamBean();

				eBean.setContent(rs.getString("content"));
				eBean.setDate(rs.getTimestamp("date"));
				eBean.setIp(rs.getString("ip"));
				eBean.setName(rs.getString("name"));
				eBean.setNum(rs.getInt("num"));
				eBean.setReadcount(rs.getInt("readcount"));
				eBean.setSubject(rs.getString("subject"));
				eBean.setImgPath(rs.getString("imgPath"));
				eBean.setFile(rs.getString("file"));
				
				//BoardBean객체 => ArrayList배열에 추가
				examList.add(eBean);
			}	
		}catch(Exception exception){
			System.out.println("getBoardList 메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return examList;
	}
	
	//하나의 글을 클릭했을 때 글번호를 매개변수로 전달받아 글 번호에 해당되는 글 조회수 정보를 1 증가(업데이트)시키는 메소드
	public void updateReadCount(int num){
		String sql = "";
		int hotNum = 0;
		
		try{
			con = getConnection();
			sql = "update exam set readcount = readcount+1 where num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
			
			sql = "select * from exam where num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			rs.next();
			int readcount = rs.getInt("readcount");
			String subject = rs.getString("subject");
			String content = rs.getString("content");
			String name = rs.getString("name");
			Timestamp timestamp = new Timestamp(System.currentTimeMillis());

			sql = "select max(num) from hot";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()){
				hotNum = rs.getInt(1) + 1;
			}else{
				hotNum = 1;
			}

			if(readcount == 30){
				sql = "insert into hot(num, originTable, originNum, name, subject, content, date) values(?, ?, ?, ?, ?, ?, ?)";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, hotNum);
				pstmt.setString(2, "exam");
				pstmt.setInt(3, num);
				pstmt.setString(4, name);
				pstmt.setString(5, subject);
				pstmt.setString(6, content);
				pstmt.setTimestamp(7, timestamp);
				pstmt.executeUpdate();
			}
			
		}catch(Exception exception){
			System.out.println("updateReadCount메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
	}
	
	public ExamBean getExam(int num){
		String sql = "";
		
		ExamBean eBean = new ExamBean();
		
		try{
			con = getConnection();
			sql = "select * from exam where num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				eBean.setContent(rs.getString("content"));
				eBean.setDate(rs.getTimestamp("date"));
				eBean.setIp(rs.getString("ip"));
				eBean.setName(rs.getString("name"));
				eBean.setNum(rs.getInt("num"));
				eBean.setReadcount(rs.getInt("readcount"));
				eBean.setSubject(rs.getString("subject"));
				eBean.setFile(rs.getString("file"));
			}
		}catch(Exception exception){
			System.out.println("getBoard메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return eBean;
	}
	
	//삭제할 글번호와 글을 삭제하기 위해 입력했던 비밀번호를 매개변수로 전달받아
	//삭제할 글번호에 해당되는 비밀번호를 검색하여 검색한 비밀번호와 입력했던 비밀번호가 일치하면 delete실행
	//delete에 성공하면 check = 1로 저장하여 반환
	//delete에 실패하면 check = 0로 저장하여 반환
	public void deleteExam(int num){
		
		String sql = "";
		
		try{
			con = getConnection();
			
			sql = "delete from exam where num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
			
			sql = "delete from eripple where postnum = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
				
			
		}catch(Exception exception){
			System.out.println("deleteExam메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
	}//deleteBoard 메소드 끝
	
	//수정을 위해 입력한 글 정보가 저장된 BoardBean객체를 매개변수로 전달받아 update문장 완성 후 DB와 연결하여 update구문 실행하는 메소드
	//조건 : DB에 저장된 글의 비밀번호와 글을 수정하기 위해 입력한 비밀번호가 일치할 때만 update 적용
	public void updateExamF(ExamBean eBean){
		String sql = "";
		
		try{
			//커넥션풀로부터 커넥션 객체(DB와 미리 연결을 맺은 접속을 나타내는 객체) 빌려오기
			con = getConnection();
			//BoardBean객체의 num 변수에 저장된 글 번호에 해당되는 글 검색
			sql = "select * from exam where num = ?";
			//select문장을 DB에 전송하여 실행할 PreparedStatement 객체 얻기
			pstmt = con.prepareStatement(sql);
			//?기호에 대응되는 값 설정
			pstmt.setInt(1, eBean.getNum());
			
			String content = eBean.getContent();
		 	Pattern pattern  =  Pattern.compile("<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>");
		 	Matcher match = pattern.matcher(content);
		 	String imgPath = null;
		 	if(match.find()){ // 이미지 태그를 찾았다면,,
		 	    imgPath = match.group(0); // 글 내용 중에 첫번째 이미지 태그를 뽑아옴.
		 	}
			
			//위 select 문 실행 후 검색한 결과를 임시로 ResultSet객체 반환받기
			rs = pstmt.executeQuery();		//해당하는 글이 존재하면
			if(rs.next()){
					sql = "update exam set subject=?, content=?, imgPath=?, file=? where num=?";
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, eBean.getSubject());
					pstmt.setString(2, eBean.getContent());
					pstmt.setString(3, imgPath);
					pstmt.setString(4, eBean.getFile());
					pstmt.setInt(5, eBean.getNum());
					pstmt.executeUpdate();
			}
			
		}catch(Exception exception){
			System.out.println("updateExam 메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
	}
	
	public void updateExam(ExamBean eBean){
		String sql = "";
		
		try{
			//커넥션풀로부터 커넥션 객체(DB와 미리 연결을 맺은 접속을 나타내는 객체) 빌려오기
			con = getConnection();
			//BoardBean객체의 num 변수에 저장된 글 번호에 해당되는 글 검색
			sql = "select * from exam where num = ?";
			//select문장을 DB에 전송하여 실행할 PreparedStatement 객체 얻기
			pstmt = con.prepareStatement(sql);
			//?기호에 대응되는 값 설정
			pstmt.setInt(1, eBean.getNum());
			
			String content = eBean.getContent();
		 	Pattern pattern  =  Pattern.compile("<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>");
		 	Matcher match = pattern.matcher(content);
		 	String imgPath = null;
		 	if(match.find()){ // 이미지 태그를 찾았다면,,
		 	    imgPath = match.group(0); // 글 내용 중에 첫번째 이미지 태그를 뽑아옴.
		 	}
			
			//위 select 문 실행 후 검색한 결과를 임시로 ResultSet객체 반환받기
			rs = pstmt.executeQuery();		//해당하는 글이 존재하면
			if(rs.next()){
					sql = "update exam set subject=?, content=?, imgPath=? where num=?";
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, eBean.getSubject());
					pstmt.setString(2, eBean.getContent());
					pstmt.setString(3, imgPath);
					pstmt.setInt(4, eBean.getNum());
					pstmt.executeUpdate();
			}
			
		}catch(Exception exception){
			System.out.println("updateExam 메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
	}
	
	public int getSearchCount(String frselect, String search){
		int searchCount = 0;
		String sql = "";
		
		try{
			//DB연결
			con = getConnection();
			
			//전체 글 수 조회
			if(frselect.equals("제목/내용")){
				sql = "select count(*) from exam where subject like ? or content like ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%"+search+"%");
				pstmt.setString(2, "%"+search+"%");
			}else if(frselect.equals("작성자")){
				sql = "select count(*) from exam where name like ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%"+search+"%");
			}
			

			rs = pstmt.executeQuery();
			
			if(rs.next()){
				searchCount = rs.getInt(1);
			}
		}catch(Exception exception){
			System.out.println("getSearchCount메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return searchCount;
	}
	
	public List<ExamBean> getSearchList(int startRow, int pageSize, String frselect, String search){
		List<ExamBean> examList = new ArrayList(); 
		String sql = "";
		
		try{
			con = getConnection();		//DB연결
			
			//select문장 만들기. re_ref 내림차순 정렬 후 re_seq 오름차순 정렬
			//limit 각 페이지마다 첫번째로 보여질 시작글 번호, 한페이지당 보여줄 글개수
			
			
			if(frselect.equals("제목/내용")){
				sql = "select * from exam where subject like ? or content like ? limit ?, ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%"+search+"%");
				pstmt.setString(2, "%"+search+"%");
				pstmt.setInt(3, startRow);
				pstmt.setInt(4, pageSize);
			}else if(frselect.equals("작성자")){
				sql = "select * from exam where name like ? limit ?, ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%"+search+"%");
				pstmt.setInt(2, startRow);
				pstmt.setInt(3, pageSize);
			}
			
			
			rs = pstmt.executeQuery();
	
			int num = 0;
			
			while(rs.next()){
				ExamBean eBean = new ExamBean();

				eBean.setContent(rs.getString("content"));
				eBean.setDate(rs.getTimestamp("date"));
				eBean.setIp(rs.getString("ip"));
				eBean.setName(rs.getString("name"));
				eBean.setNum(rs.getInt("num"));
				eBean.setReadcount(rs.getInt("readcount"));
				eBean.setSubject(rs.getString("subject"));
				
				//BoardBean객체 => ArrayList배열에 추가
				examList.add(eBean);
			}	
		}catch(Exception exception){
			System.out.println("getSearchList 메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return examList;
	}
}//BoardDAO클래스 끝
