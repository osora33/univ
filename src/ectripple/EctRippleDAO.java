package ectripple;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import board.BoardBean;

public class EctRippleDAO {
	
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
	
public void insertRipple(EctRippleBean rBean){
		
		//DB에 추가할 글번호를 저장할 변수 
		int num = 0;
		int pnum = 0;
		
		//SQL문 저장할 변수선언
		String sql = "";
		
		try {
			//커넥션풀에서 커넥션객체 얻기(DB연결)
			con = getConnection();
			
			//DB에 저장된 글의 가장 최신 글번호 검색해 오는 SELECT문
			sql = "select max(num) from EctRipple where postnum=?";
			//참고 : DB에 글이 저장되어 있지 않는경우  새로추가할 글번호 는? 1
			//      DB에 글이 저장되어 있는 경우  검색한 가장 최신글번호 + 1 데이터를 새로추가할 글번호로 지정
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, rBean.getPostnum());
			rs = pstmt.executeQuery();
			
			if(rs.next()){//가장 최신 글번호가 검색된다면?
				//가장최신 글번호  + 1 데이터를 새로 추가할 글번호로 지정
				num = rs.getInt(1) + 1;
			}else{//가장 최신 글번호가 검색되지 않으면?(DB에 글이 없다면)
				num = 1; //새로추가할 글번호를 1로 설정 
			}
			
			int re_ref = num;
			
			//DB에 저장된 글의 가장 최신 글번호 검색해 오는 SELECT문
			sql = "select max(pnum) from EctRipple";
			//참고 : DB에 글이 저장되어 있지 않는경우  새로추가할 글번호 는? 1
			//      DB에 글이 저장되어 있는 경우  검색한 가장 최신글번호 + 1 데이터를 새로추가할 글번호로 지정
			
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()){//가장 최신 글번호가 검색된다면?
				//가장최신 글번호  + 1 데이터를 새로 추가할 글번호로 지정
				pnum = rs.getInt(1) + 1;
			}else{//가장 최신 글번호가 검색되지 않으면?(DB에 글이 없다면)
				pnum = 1; //새로추가할 글번호를 1로 설정 
			}
			
			sql = "insert into EctRipple(pnum, postnum, num, id, content, re_ref, re_lev, re_seq, date)"
				+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?);";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, pnum);
			pstmt.setInt(2, rBean.getPostnum());
			pstmt.setInt(3, num);//추가할 새글의 글번호
			pstmt.setString(4, rBean.getId());//새글을 작성한 사람의 이름(id)
			pstmt.setString(5, rBean.getContent());//글내용
			pstmt.setInt(6, re_ref); // 새글의 그룹번호는 새글의 글번호로 넣는다.
			pstmt.setInt(7, 0); //새글 (주글) 추가시 들여쓰기 정도값은 0으로 넣는다.
			pstmt.setInt(8, 0); //주글의 순서값 
			pstmt.setTimestamp(9, rBean.getDate()); //새글을 추가한 날짜 정보 
			
			//insert문장 실행
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("insertBoard메소드 내부에서 실행 오류 : " + e);
		} finally {
			자원해제();
		}	
	}//insertBoard메소드 끝

	public EctRippleBean getRipple(int num){
		String sql = "";
		
		EctRippleBean rBean = new EctRippleBean();
		
		try{
			con = getConnection();
			sql = "select * from EctRipple where postnum = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				rBean.setNum(rs.getInt("num"));
				rBean.setId(rs.getString("id"));
				rBean.setContent(rs.getString("content"));
				rBean.setRe_ref(rs.getInt("re_ref"));
				rBean.setRe_lev(rs.getInt("re_lev"));
				rBean.setRe_seq(rs.getInt("re_seq"));
				rBean.setDate(rs.getTimestamp("date"));
			}
		}catch(Exception exception){
			System.out.println("getBoard메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return rBean;
	}
	
	public int getRippleCount(int num){
		int count = 0;
		
		String sql = "";
		
		try{
			//DB연결
			con = getConnection();
			
			//전체 글 수 조회
			sql = "select count(*) from EctRipple where postnum=?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				count = rs.getInt(1);
			}
		}catch(Exception exception){
			System.out.println("getRipeCount메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return count;
	}
	
	public List<EctRippleBean> getRippleList(int startRow, int pageSize, int postnum){
		List<EctRippleBean> rippleList = new ArrayList(); 
		String sql = "";
		
		try{
			con = getConnection();		//DB연결
			
			//select문장 만들기. re_ref 내림차순 정렬 후 re_seq 오름차순 정렬
			//limit 각 페이지마다 첫번째로 보여질 시작글 번호, 한페이지당 보여줄 글개수
			sql = "select * from EctRipple where postnum=? order by re_ref, re_seq asc limit ?, ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, postnum);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, pageSize);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				EctRippleBean rBean = new EctRippleBean();
				
				rBean.setPostnum(postnum);
				rBean.setNum(rs.getInt("num"));
				rBean.setId(rs.getString("id"));
				rBean.setContent(rs.getString("content"));
				rBean.setRe_ref(rs.getInt("re_ref"));
				rBean.setRe_lev(rs.getInt("re_lev"));
				rBean.setRe_seq(rs.getInt("re_seq"));
				rBean.setDate(rs.getTimestamp("date"));
				
				//BoardBean객체 => ArrayList배열에 추가
				rippleList.add(rBean);
			}	
			
		}catch(Exception exception){
			System.out.println("getRippleList 메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return rippleList;
	}
	
	public void reInsertRipple(EctRippleBean rBean){
		String sql = "";
		int num = 0;		//답글의 글번호를 만들어 저장할 변수
		int pnum=0;
		int re_lev=0;
		int re_seq=0;
		try{
			con = getConnection();
			
			sql = "select max(num) from EctRipple where postnum=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, rBean.getPostnum());
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				//답변글의 글번호 = 검색한 최신 글번호 + 1
				num = rs.getInt(1) + 1;
			}else{
				num = 1;
			}
			
			sql = "select max(pnum) from EctRipple";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				//답변글의 글번호 = 검색한 최신 글번호 + 1
				pnum = rs.getInt(1) + 1;
			}else{
				pnum = 1;
			}
			
			sql = "select re_lev from EctRipple where postnum=? and num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, rBean.getPostnum());
			pstmt.setInt(2, rBean.getNum());
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				//답변글의 글번호 = 검색한 최신 글번호 + 1
				re_lev = rs.getInt(1) + 1;
			}else{
				re_lev = 1;
			}
			
			sql = "select re_seq from EctRipple where postnum=? and num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, rBean.getPostnum());
			pstmt.setInt(2, rBean.getNum());
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				//답변글의 글번호 = 검색한 최신 글번호 + 1
				re_seq = rs.getInt(1) + 1;
			}else{
				re_seq = 1;
			}
			
			//답변 달기
			//insert
			sql = "insert into EctRipple(pnum, postnum, num, id, content, Re_ref, re_lev, re_seq, date) values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, pnum);
			pstmt.setInt(2, rBean.getPostnum());
			pstmt.setInt(3, num);
			pstmt.setString(4, rBean.getId());
			pstmt.setString(5, rBean.getContent());
			pstmt.setInt(6, rBean.getRe_ref());
			pstmt.setInt(7, re_lev);
			pstmt.setInt(8, re_seq);
			pstmt.setTimestamp(9, rBean.getDate());
			
			pstmt.executeUpdate();
		}catch(Exception exception){
			System.out.println("reInsertRipple 메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
	}
	
	//삭제할 글번호와 글을 삭제하기 위해 입력했던 비밀번호를 매개변수로 전달받아
		//삭제할 글번호에 해당되는 비밀번호를 검색하여 검색한 비밀번호와 입력했던 비밀번호가 일치하면 delete실행
		//delete에 성공하면 check = 1로 저장하여 반환
		//delete에 실패하면 check = 0로 저장하여 반환
		public void deleteRipple(int postnum, int num){
		
			String sql = "";
			
			try{
				con = getConnection();
				sql = "delete from EctRipple where postnum=? and num = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, postnum);
				pstmt.setInt(2, num);
				pstmt.executeUpdate();
				
			}catch(Exception exception){
				System.out.println("deletEctRipple메소드 내부에서 오류 : " + exception);
			}finally{
				자원해제();
			}
		}//deleteBoard 메소드 끝
		
		public void updateRipple(EctRippleBean rBean){
			String sql = "";
			
			try{
				//커넥션풀로부터 커넥션 객체(DB와 미리 연결을 맺은 접속을 나타내는 객체) 빌려오기
				con = getConnection();
				//BoardBean객체의 num 변수에 저장된 글 번호에 해당되는 글 검색
				sql = "select * from EctRipple where num = ?";
				//select문장을 DB에 전송하여 실행할 PreparedStatement 객체 얻기
				pstmt = con.prepareStatement(sql);
				//?기호에 대응되는 값 설정
				pstmt.setInt(1, rBean.getNum());
				
				//위 select 문 실행 후 검색한 결과를 임시로 ResultSet객체 반환받기
				rs = pstmt.executeQuery();		//해당하는 글이 존재하면
				if(rs.next()){
						sql = "update EctRipple set content=? where postnum=? and num=?";
						pstmt = con.prepareStatement(sql);
						pstmt.setString(1, rBean.getContent());
						pstmt.setInt(2, rBean.getPostnum());
						pstmt.setInt(3, rBean.getNum());
						pstmt.executeUpdate();
				}
				
			}catch(Exception exception){
				System.out.println("updatEctRipple 메소드 내부에서 오류 : " + exception);
			}finally{
				자원해제();
			}
		}
}