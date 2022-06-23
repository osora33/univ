package ect;

import java.sql.Timestamp;

//자바빈 클래스의 종류 중 dto
public class EctBean {

	//변수
	private int num;		//글번호
	private String name;		//글 작성자 이름
	private String subject;		//글 제목
	private String content; 		//글 내용
	private int readcount; 		//글 조회수
	private Timestamp date; 		//글 작성 날짜
	private String ip;		//글 작성자 ip주소
	private String imgPath;
	private String file;
	
	//getter, setter 메소드
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getReadcount() {
		return readcount;
	}
	public void setReadcount(int readcount) {
		this.readcount = readcount;
	}
	public Timestamp getDate() {
		return date;
	}
	public void setDate(Timestamp date) {
		this.date = date;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getImgPath() {
		return imgPath;
	}
	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}
	public String getFile() {
		return file;
	}
	public void setFile(String file) {
		this.file = file;
	}
	
}
