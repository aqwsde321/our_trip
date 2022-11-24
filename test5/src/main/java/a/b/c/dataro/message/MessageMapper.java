package a.b.c.dataro.message;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MessageMapper {
	
	int insert(MessageVO vo);
	
	int delReceiveMsg(int no);
	
	int delSendMsg(int no);
	
	// 쪽지 읽음처리
	int readMsg(int no);
	
	// 읽지 않은 쪽지 수
	int unreadMsgCount(MessageVO vo);
	
	// 전체 받은 쪽지 수
	int msgTotalCount(int no);
	
	// 읽지 않은 쪽지 목록
	List<MessageVO> unreadMsgList(MessageVO vo);
	
	// 받은쪽지함
	int count4(MessageVO vo);
	List<MessageVO> myList4(MessageVO vo);
	// 보낸쪽지함
	int count5(MessageVO vo);
	List<MessageVO> myList5(MessageVO vo);
}
