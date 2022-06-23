package hot;

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
public class HotDAO {
	
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
	
	//DB에 저장된 전체 글 개수를 검색해서 반환하는 메소드
	public int getBoardCount(){
		int count = 0;
		
		String sql = "";
		
		try{
			//DB연결
			con = getConnection();
			
			//전체 글 수 조회
			sql = "select count(*) from hot";
			
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				count = rs.getInt(1);
			}
		}catch(Exception exception){
			System.out.println("getBoardCount메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return count;
	}
	
	public List<HotBean> getMainList(){
		List<HotBean> list = new ArrayList();
		String sql = null;
		
		try{
			con = getConnection();
			sql = "select * from hot order by num desc";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				HotBean bean = new HotBean();
				bean.setNum(rs.getInt("num"));
				bean.setSubject(rs.getString("subject"));
				list.add(bean);
			}
		}catch(Exception e){
			System.out.println("getMainList 메소드 내부에서 오류 : " + e);
		}finally{
			자원해제();
		}
		
		return list;
	}
	
	//notice.jsp페이지에서 호출하는 메소드로 
	//각 페이지마다 처음으로 보여질 시작 글번호와 한 페이지당 보여질 글 개수를 매개변수로 전달받아
	//한 페이지당 보여질 글 개수만큼 검색해서 가져오는 메소드
	public List<HotBean> getBoardList(int startRow, int pageSize){
		List<HotBean> boardList = new ArrayList(); 
		String sql = "";
		
		try{
			con = getConnection();		//DB연결
			
			sql = "select * from hot order by num desc limit ?, ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, pageSize);
			rs = pstmt.executeQuery();
	
			int num = 0;
			
			while(rs.next()){
				HotBean bBean = new HotBean();

				bBean.setDate(rs.getTimestamp("date"));
				bBean.setNum(rs.getInt("num"));
				bBean.setSubject(rs.getString("subject"));
				bBean.setOriginNum(rs.getInt("originNum"));
				bBean.setTable(rs.getString("originTable"));
				
				//BoardBean객체 => ArrayList배열에 추가
				boardList.add(bBean);
			}	
		}catch(Exception exception){
			System.out.println("getBoardList 메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return boardList;
	}
	
	public int getRippleCount(int originNum, String table){
		int count = 0;
		String sql = "";
		
		try{
			//DB연결
			con = getConnection();
			
			if(table.equals("board")){
			//전체 글 수 조회
				sql = "select count(*) from ripple where postnum=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					count = rs.getInt(1);
				}
			}else if(table.equals("anonymous")){
				sql = "select count(*) from aripple where postnum=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					count = rs.getInt(1);
				}
			}else if(table.equals("sell")){
				sql = "select count(*) from sripple where postnum=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					count = rs.getInt(1);
				}
			}else if(table.equals("buy")){
				sql = "select count(*) from bripple where postnum=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					count = rs.getInt(1);
				}
			}else if(table.equals("exam")){
				sql = "select count(*) from eripple where postnum=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					count = rs.getInt(1);
				}
			}else if(table.equals("ect")){
				sql = "select count(*) from ectripple where postnum=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					count = rs.getInt(1);
				}
			}
			
		}catch(Exception exception){
			System.out.println("getRippleCount메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return count;
	}
	
	public String getImgPath(int originNum, String table){
		String imgPath = null;
		
		String sql = "";
		
		try{
			//DB연결
			con = getConnection();
			
			if(table.equals("board")){
			//전체 글 수 조회
				sql = "select imgPath from board where num=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					imgPath = rs.getString(1);
				}
			}else if(table.equals("anonymous")){
				sql = "select imgPath from anonymous where num=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					imgPath = rs.getString(1);
				}
			}else if(table.equals("sell")){
				sql = "select imgPath from sell where num=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					imgPath = rs.getString(1);
				}
			}else if(table.equals("buy")){
				sql = "select imgPath from buy where num=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					imgPath = rs.getString(1);
				}
			}else if(table.equals("exam")){
				sql = "select imgPath from exam where num=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					imgPath = rs.getString(1);
				}
			}else if(table.equals("ect")){
				sql = "select imgPath from ect where postnum=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					imgPath = rs.getString(1);
				}
			}
			
		}catch(Exception exception){
			System.out.println("getRippleCount메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return imgPath;
	}
	
	//하나의 글을 클릭했을 때 글번호를 매개변수로 전달받아 글 번호에 해당되는 글 조회수 정보를 1 증가(업데이트)시키는 메소드
	public void updateReadCount(int num){
		String sql = "";
		int hotNum = 0;
		
		try{
			sql = "select * from hot where num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			rs.next();
			int originNum = rs.getInt("originNum");
			String table = rs.getString("originTable");

			if(table.equals("board")){
				sql = "update board set readcount = readcount+1 where num = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				pstmt.executeUpdate();
			}else if(table.equals("anonymous")){
				sql = "update anonymous set readcount = readcount+1 where num = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				pstmt.executeUpdate();
			}else if(table.equals("sell")){
				sql = "update sell set readcount = readcount+1 where num = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				pstmt.executeUpdate();
			}else if(table.equals("buy")){
				sql = "update buy set readcount = readcount+1 where num = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				pstmt.executeUpdate();
			}else if(table.equals("exam")){
				sql = "update exam set readcount = readcount+1 where num = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				pstmt.executeUpdate();
			}else if(table.equals("ect")){
				sql = "update ect set readcount = readcount+1 where num = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, originNum);
				pstmt.executeUpdate();
			}
			
		}catch(Exception exception){
			System.out.println("updateReadCount메소드 내부에서 오류 : " + exception);
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
				sql = "select count(*) from hot where subject like ? or content like ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%"+search+"%");
				pstmt.setString(2, "%"+search+"%");
			}else if(frselect.equals("작성자")){
				sql = "select count(*) from hot where name like ?";
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
	
	public List<HotBean> getSearchList(int startRow, int pageSize, String frselect, String search){
		List<HotBean> boardList = new ArrayList(); 
		String sql = "";
		
		try{
			con = getConnection();		//DB연결
			
			//select문장 만들기. re_ref 내림차순 정렬 후 re_seq 오름차순 정렬
			//limit 각 페이지마다 첫번째로 보여질 시작글 번호, 한페이지당 보여줄 글개수
			
			
			if(frselect.equals("제목/내용")){
				sql = "select * from hot where subject like ? or content like ? order by num desc limit ?, ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%"+search+"%");
				pstmt.setString(2, "%"+search+"%");
				pstmt.setInt(3, startRow);
				pstmt.setInt(4, pageSize);
			}else if(frselect.equals("작성자")){
				sql = "select * from hot where name like ? and origintable not like 'anonymous' order by num desc limit ?, ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%"+search+"%");
				pstmt.setInt(2, startRow);
				pstmt.setInt(3, pageSize);
			}
			
			rs = pstmt.executeQuery();
	
			while(rs.next()){
				HotBean bBean = new HotBean();

				bBean.setDate(rs.getTimestamp("date"));
				bBean.setNum(rs.getInt("num"));
				bBean.setSubject(rs.getString("subject"));
				bBean.setOriginNum(rs.getInt("originNum"));
				bBean.setTable(rs.getString("originTable"));
				
				//BoardBean객체 => ArrayList배열에 추가
				boardList.add(bBean);
			}	
		}catch(Exception exception){
			System.out.println("getSearchList 메소드 내부에서 오류 : " + exception);
		}finally{
			자원해제();
		}
		return boardList;
	}
	
	public String getTable(int num){
		String table=null;
		String sql = null;
		
		try{
			con = getConnection();
			
			sql = "select origintable from hot where num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			rs.next();
			table=rs.getString(1);
			
		}catch(Exception e){
			System.out.println("getTable메소드 내부에서 오류" + e);
		}finally{
			자원해제();
		}
		
		return table;
	}
	
	public int getOriginNum(int num){
		int originNum = 0;
		String sql = null;
		
		try{
			con = getConnection();
			
			sql = "select originnum from hot where num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			rs.next();
			originNum=rs.getInt(1);
			
		}catch(Exception e){
			System.out.println("getOriginNum메소드 내부에서 오류" + e);
		}finally{
			자원해제();
		}
		
		return originNum;
	}
}//BoardDAO클래스 끝
