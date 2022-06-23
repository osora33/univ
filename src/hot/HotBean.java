package hot;

import java.sql.Timestamp;

//자바빈 클래스의 종류 중 dto
public class HotBean {

	//변수
	private int num;		//글번호
	private String table;
	private int originNum;
	private String subject;		//글 제목
	private Timestamp date; 		//글 작성 날짜
	private String content;
	private String name;
	
	
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getTable() {
		return table;
	}
	public void setTable(String table) {
		this.table = table;
	}
	public int getOriginNum() {
		return originNum;
	}
	public void setOriginNum(int originNum) {
		this.originNum = originNum;
	}
	public String getName() {
		return name;
	}
	public void setNane(String name) {
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
	public Timestamp getDate() {
		return date;
	}
	public void setDate(Timestamp date) {
		this.date = date;
	}
	
}
