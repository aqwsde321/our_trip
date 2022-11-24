package a.b.c.dataro.room;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import a.b.c.dataro.boardTravel.BoardVO;

@Mapper
public interface RoomMapper {
	public RoomVO view(int no);
	
	public int chat(ChatVO vo);
	
	public int chatListCount(ChatVO vo);
	public List<ChatVO> chatList(ChatVO vo);
	
	public int makeRoom(RoomVO vo);
	
	public List<RoomVO> roomList(BoardVO vo);
	
	public int pwdCheck(RoomVO vo);
	
	public int enterRoom(RoomVO vo);
	
	public int checkRoom(RoomVO vo);
}
