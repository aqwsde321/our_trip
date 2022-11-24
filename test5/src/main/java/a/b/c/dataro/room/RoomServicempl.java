package a.b.c.dataro.room;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import a.b.c.dataro.boardTravel.BoardVO;

@Service
public class RoomServicempl implements RoomService {
	@Autowired
	RoomMapper rMapper;

	//모임방상세보기
	@Override
	public RoomVO view(int no) {
		return rMapper.view(no);
	}
	
	//방 만들고 방장 방 입장
	@Override
	public int makeRoom(RoomVO vo) {
		rMapper.makeRoom(vo);
		rMapper.enterRoom(vo);
		return 1;
	}
	
	// 이건 어디서 사용?
	@Override
	public List<RoomVO> list2(BoardVO vo) {
		return rMapper.roomList(vo);
	}

	@Override
	public int pwdCheck(RoomVO vo) {
		return rMapper.pwdCheck(vo);
	}
	
	//방 참여
	@Override
	public int enterRoom(RoomVO vo) {
		return rMapper.enterRoom(vo);
	}
	
	//내가 참여한 방인지 확인
	@Override
	public int checkRoom(RoomVO vo) {
		return rMapper.checkRoom(vo);
	}

	@Override
	public int chat(ChatVO vo) {
		return rMapper.chat(vo);
	}

	@Override
	public List<ChatVO> chatList(ChatVO vo) {
		return rMapper.chatList(vo);
	}
	
	@Override
	public int chatListCount(ChatVO vo) {
		return rMapper.chatListCount(vo);
	}
}





















