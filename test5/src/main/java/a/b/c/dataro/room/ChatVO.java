package a.b.c.dataro.room;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ChatVO {
   private String board_name;
   private int board_no;
   private int room_no;
   private int chat_no;
   private String member_id;
   private String content;
   private int member_no;
   private Timestamp chat_writedate;
   private String chat_w_str;

   public ChatVO() {
      this.board_name = "여행게시판";
   }
}