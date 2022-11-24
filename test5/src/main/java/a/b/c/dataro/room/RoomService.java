package a.b.c.dataro.room;

import java.util.List;

import a.b.c.dataro.boardTravel.BoardVO;


public interface RoomService {
	
	RoomVO view(int no);
	
	//채팅insert
	public int chat(ChatVO vo);
	
	//채팅리스트
	public int chatListCount(ChatVO vo);
	public List<ChatVO> chatList(ChatVO vo);
	
	//방 새로 만들기
	public int makeRoom(RoomVO vo);
	
	//해당 게시물에 맞는 방 리스트 가져옴
	public List<RoomVO> list2(BoardVO vo);
	
	//비밀방일때, 비밀번호 확인
	public int pwdCheck(RoomVO vo);
	
	//방 입장
	public int enterRoom(RoomVO vo);
	
	//내가 입장한 방인지 아닌지 확인
	public int checkRoom(RoomVO vo);
}
