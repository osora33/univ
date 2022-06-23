package anonymous;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//자바빈 클래스의 종류중 DAO역할을 하는 클래스
//DB연결 후 작업하는 클래스 (비즈니스로직을 처리하는 클래스)
public class AnonymousDAO {
	
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
	public void insertAnonymous(AnonymousBean bBean){
		
		//DB에 추가할 글번호를 저장할 변수 
		int num = 0;
		
		//SQL문 저장할 변수선언
		String sql = "";
		
		try {
			//커넥션풀에서 커넥션객체 얻기(DB연결)
			con = getConnection();
			
			//DB에 저장된 글의 가장 최신 글번호 검색해 오는 SELECT문
			sql = "select max(num) from anonymous";
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
			
			sql = "insert into anonymous(num,name,"
				+ "subject,content,re_ref,re_lev,re_seq,readcount,date,ip,imgPath)"
				+ "values(?,?,?,?,?,?,?,?,?,?,?);";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);//추가할 새글의 글번호
			pstmt.setString(2, bBean.getName());//새글을 작성한 사람의 이름(id)
			pstmt.setString(3, bBean.getSubject());//추가할 새글의 제목
			pstmt.setString(4, bBean.getContent());//글내용
			pstmt.setInt(5, num); // 새글의 그룹번호는 새글의 글번호로 넣는다.
			pstmt.setInt(6, 0); //새글 (주글) 추가시 들여쓰기 정도값은 0으로 넣는다.
			pstmt.setInt(7, 0); //주글의 순서값 
			pstmt.setInt(8, 0); //추가하는 새글의 조회수 0
			pstmt.setTimestamp(9, bBean.getDate()); //새글을 추가한 날짜 정보 
			pstmt.setString(10, bBean.getIp());//새글을 작성한 사람의  IP주소 정보 
			pstmt.setString(11, bBean.getImgPath());
			
			//insert문장 실행
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("insertAnonymous메소드 내부에서 실행 오류 : " + e);
		} finally {
			자원해제();
		}	
	}//insertAnonymous메소드 끝
	
	//DB에 저장된 전체 글 개수를 검색해서 반환하는 메소드
	public int getAnonymousCount(){
		int count = 0;
		
		String sql = "";
		
		try{
			//DB연결
			con = getConnection();
			
			//전체 글 수 조회
			sql = "select count(*) from anonymous";
			
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				count = rs.getInt(1);
			}
		}catch(Exception exception){
			System.out.println("getAnonymousCount메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return count;
	}
	
	//notice.jsp페이지에서 호출하는 메소드로 
	//각 페이지마다 처음으로 보여질 시작 글번호와 한 페이지당 보여질 글 개수를 매개변수로 전달받아
	//한 페이지당 보여질 글 개수만큼 검색해서 가져오는 메소드
	public List<AnonymousBean> getAnonymousList(int startRow, int pageSize){
		List<AnonymousBean> anonymousList = new ArrayList(); 
		String sql = "";
		
		try{
			con = getConnection();		//DB연결
			
			//select문장 만들기. re_ref 내림차순 정렬 후 re_seq 오름차순 정렬
			//limit 각 페이지마다 첫번째로 보여질 시작글 번호, 한페이지당 보여줄 글개수
			sql = "select * from anonymous order by re_ref desc, re_seq asc limit ?, ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, pageSize);
			
			rs = pstmt.executeQuery();
	
			int num = 0;
			
			while(rs.next()){
				AnonymousBean bBean = new AnonymousBean();

				bBean.setContent(rs.getString("content"));
				bBean.setDate(rs.getTimestamp("date"));
				bBean.setIp(rs.getString("ip"));
				bBean.setName(rs.getString("name"));
				bBean.setNum(rs.getInt("num"));
				bBean.setRe_lev(rs.getInt("re_lev"));
				bBean.setRe_ref(rs.getInt("re_ref"));
				bBean.setRe_seq(rs.getInt("re_seq"));
				bBean.setReadcount(rs.getInt("readcount"));
				bBean.setSubject(rs.getString("subject"));
				bBean.setImgPath(rs.getString("imgPath"));
				
				//AnonymousBean객체 => ArrayList배열에 추가
				anonymousList.add(bBean);
			}	
		}catch(Exception exception){
			System.out.println("getAnonymousList 메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return anonymousList;
	}
	
	//하나의 글을 클릭했을 때 글번호를 매개변수로 전달받아 글 번호에 해당되는 글 조회수 정보를 1 증가(업데이트)시키는 메소드
	public void updateReadCount(int num){
		String sql = "";
		int hotNum = 0;
		
		try{
			con = getConnection();
			sql = "update anonymous set readcount = readcount+1 where num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
			
			sql = "select * from anonymous where num=?";
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
				pstmt.setString(2, "anonymous");
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
	
	public AnonymousBean getAnonymous(int num){
		String sql = "";
		
		AnonymousBean bBean = new AnonymousBean();
		
		try{
			con = getConnection();
			sql = "select * from anonymous where num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				bBean.setContent(rs.getString("content"));
				bBean.setDate(rs.getTimestamp("date"));
				bBean.setIp(rs.getString("ip"));
				bBean.setName(rs.getString("name"));
				bBean.setNum(rs.getInt("num"));
				bBean.setRe_lev(rs.getInt("re_lev"));
				bBean.setRe_ref(rs.getInt("re_ref"));
				bBean.setRe_seq(rs.getInt("re_seq"));
				bBean.setReadcount(rs.getInt("readcount"));
				bBean.setSubject(rs.getString("subject"));
			}
		}catch(Exception exception){
			System.out.println("getAnonymous메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return bBean;
	}
	
	//삭제할 글번호와 글을 삭제하기 위해 입력했던 비밀번호를 매개변수로 전달받아
	//삭제할 글번호에 해당되는 비밀번호를 검색하여 검색한 비밀번호와 입력했던 비밀번호가 일치하면 delete실행
	//delete에 성공하면 check = 1로 저장하여 반환
	//delete에 실패하면 check = 0로 저장하여 반환
	public void deleteAnonymous(int num){
		
		String sql = "";
		
		try{
			con = getConnection();
			
			sql = "delete from anonymous where num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
			
			sql = "delete from aripple where postnum=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
				
			
		}catch(Exception exception){
			System.out.println("deleteAnonymous메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
	}//deleteAnonymous 메소드 끝
	
	//수정을 위해 입력한 글 정보가 저장된 AnonymousBean객체를 매개변수로 전달받아 update문장 완성 후 DB와 연결하여 update구문 실행하는 메소드
	//조건 : DB에 저장된 글의 비밀번호와 글을 수정하기 위해 입력한 비밀번호가 일치할 때만 update 적용
	public void updateAnonymous(AnonymousBean bBean){
		String sql = "";
		
		try{
			//커넥션풀로부터 커넥션 객체(DB와 미리 연결을 맺은 접속을 나타내는 객체) 빌려오기
			con = getConnection();
			//AnonymousBean객체의 num 변수에 저장된 글 번호에 해당되는 글 검색
			sql = "select * from anonymous where num = ?";
			//select문장을 DB에 전송하여 실행할 PreparedStatement 객체 얻기
			pstmt = con.prepareStatement(sql);
			//?기호에 대응되는 값 설정
			pstmt.setInt(1, bBean.getNum());
			
			//위 select 문 실행 후 검색한 결과를 임시로 ResultSet객체 반환받기
			rs = pstmt.executeQuery();		//해당하는 글이 존재하면
			if(rs.next()){
					sql = "update anonymous set subject=?, content=?, imgPath=? where num=?";
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, bBean.getSubject());
					pstmt.setString(2, bBean.getContent());
					pstmt.setString(3, bBean.getImgPath());
					pstmt.setInt(4, bBean.getNum());
					pstmt.executeUpdate();
			}
			
		}catch(Exception exception){
			System.out.println("updateAnonymous 메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
	}
	//답변달기 규칙
	//1. 답글 그룹번호(re_ref)는 주 글의 그룹번호(re_ref)를 사용
	//2. 같은 그룹의 글들 내의 순서값(re_seq)은 주 글의 re_seq에서 +1한 값을 적용
	//3. 답글의 들여쓰기 정도값(re_lev)는 주 글의 re_lev값에 +1한 값을 적용
	
	//답변글을 DB에 insert하는 메소드 만들기
	public void reInsertAnonymous(AnonymousBean bBean){
		String sql = "";
		int num = 0;		//답글의 글번호를 만들어 저장할 변수
		try{
			con = getConnection();
			sql = "select max(num) from anonymous";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				//답변글의 글번호 = 검색한 최신 글번호 + 1
				num = rs.getInt(1) + 1;
			}else{
				num = 1;
			}
			
			//re_seq 답글들 내의 순서 재배치
			//주 글의 그룹과 같은 그룹이면서 주 글의 seq값보다 큰 답변글들은 seq값을 1 증가시키기
			sql = "update anonymous set re_seq = re_seq+1 where re_ref = ? and re_seq>?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, bBean.getRe_ref());		//주 글의 그룹번호
			pstmt.setInt(2, bBean.getRe_seq());		//주 글의 글 입력순서
			pstmt.executeUpdate();
			
			//답변 달기
			//insert
			sql = "insert into anonymous(num, name, subject, content, Re_ref, re_lev, re_seq, readcount, date, ip, imgPath) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);		//추가할 답변글의 글번호
			pstmt.setString(2, bBean.getName());		//답변글을 작성하는 사람의 이름
			pstmt.setString(3, bBean.getSubject());
			pstmt.setString(4, bBean.getContent());
			pstmt.setInt(5, bBean.getRe_ref());		//답변글의 그룹번호는 주 글의 그룹번호를 사용
			pstmt.setInt(6, bBean.getRe_lev()+1);		//답변글의 들여쓰기 정도값은 주글의 들여쓰기 정도값에 +1한 값을 사용
			pstmt.setInt(7, bBean.getRe_seq()+1);		//답변글의 순서값은 주글의 re_seq +1한 값을 사용
			pstmt.setInt(8, 0);		//답변글을 조회한 조회수 0
			pstmt.setTimestamp(9, bBean.getDate());		//답변글을 작성한 날짜 및 시간
			pstmt.setString(10, bBean.getIp());		//답변글을 작성하는 클라이언트의 ip정보
			pstmt.setString(11, bBean.getImgPath());
			
			pstmt.executeUpdate();
		}catch(Exception exception){
			System.out.println("reInsertAnonymous 메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
	}
	
	public int getSearchCount(String search){
		int searchCount = 0;
		String sql = "";
		
		try{
			//DB연결
			con = getConnection();
			
			//전체 글 수 조회
			sql = "select count(*) from anonymous where subject like ? or content like ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "%"+search+"%");
			pstmt.setString(2, "%"+search+"%");

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
	
	public List<AnonymousBean> getSearchList(int startRow, int pageSize, String search){
		List<AnonymousBean> anonymousList = new ArrayList(); 
		String sql = "";
		
		try{
			con = getConnection();		//DB연결
			
			//select문장 만들기. re_ref 내림차순 정렬 후 re_seq 오름차순 정렬
			//limit 각 페이지마다 첫번째로 보여질 시작글 번호, 한페이지당 보여줄 글개수
			
			sql = "select * from anonymous where subject like ? or content like ? order by re_ref desc, re_seq asc limit ?, ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "%"+search+"%");
			pstmt.setString(2, "%"+search+"%");
			pstmt.setInt(3, startRow);
			pstmt.setInt(4, pageSize);
			
			rs = pstmt.executeQuery();
	
			int num = 0;
			
			while(rs.next()){
				AnonymousBean bBean = new AnonymousBean();

				bBean.setContent(rs.getString("content"));
				bBean.setDate(rs.getTimestamp("date"));
				bBean.setIp(rs.getString("ip"));
				bBean.setName(rs.getString("name"));
				bBean.setNum(rs.getInt("num"));
				bBean.setRe_lev(rs.getInt("re_lev"));
				bBean.setRe_ref(rs.getInt("re_ref"));
				bBean.setRe_seq(rs.getInt("re_seq"));
				bBean.setReadcount(rs.getInt("readcount"));
				bBean.setSubject(rs.getString("subject"));
				bBean.setImgPath(rs.getString("imgPath"));
				
				//AnonymousBean객체 => ArrayList배열에 추가
				anonymousList.add(bBean);
			}	
		}catch(Exception exception){
			System.out.println("getSearchList 메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return anonymousList;
	}
}//AnonymousDAO클래스 끝
