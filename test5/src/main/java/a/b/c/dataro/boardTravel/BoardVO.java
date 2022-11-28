package a.b.c.dataro.boardTravel;

import java.sql.Timestamp;
import java.util.List;

import a.b.c.dataro.map.MapVO;
import a.b.c.dataro.util.CategoryVO;
import a.b.c.dataro.util.FileVO;
import lombok.Data;

@Data
public class BoardVO {
	
	private String board_name; 
	private int board_no; 
	private String id; 
	private int member_no; 
	private String title;
	private int viewcount; 
	private Timestamp writedate; 
	private Timestamp updatedate; 
	private String stype;
	private String sword;
	private String stag;
	private String sregion;
	private int startIdx;
	private int pageRow;
	private int page;
	private Timestamp reply_writedate; 
	
	public BoardVO (String board_name, int page, int pageRow, String filename_server){
		this.board_name=board_name;
		this.page=page;
		this.pageRow=pageRow;
		this.filename_server= filename_server;
	}
	public BoardVO (){
		this("여행게시판",1,10, "no-image.jpg");
	}
	
	private String content; 
	private int likecount;
	private int replycount;
	private int dislikecount;
	private int hashtag_no;
	private String hashtag_name;
	private String filename_server;
	
	// 내용여러개
	private List<MapVO> placeList;
	private List<CategoryVO> categoryList; 
	private String[] contents;
	private int course_no;
	private int login_member_no;
}
