package a.b.c.dataro.boardFree;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class FreeVO {
	
	private String board_name;
	private int board_no; 
	private String id; 
	private int member_no; 
	private String title;
	private String content; 
	private int viewcount; 
	private Timestamp writedate; 
	private Timestamp updatedate;
	private String filename_org;
	private String filename_server;
	
	private int login_member_no;
	
	private String stype;
	private String sword;
	private int startIdx;
	private int pageRow;
	private int page;
	private Timestamp reply_writedate; 
	
	public FreeVO (String board_name, int page, int pageRow){
		this.board_name=board_name;
		this.page=page;
		this.pageRow=pageRow;
	}
	public FreeVO (){
		this("자유게시판",1,10);
	}
	
	private int likecount;
	private int dislikecount;
	private int replycount;
	
}
