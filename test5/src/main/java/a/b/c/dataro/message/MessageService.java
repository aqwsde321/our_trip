package a.b.c.dataro.message;

import java.util.List;

public interface MessageService {
	
	int insert(MessageVO vo);
	
	int delReceiveMsg(int no);
	
	int delSendMsg(int no);
	
	int readMsg(int no);
	
	int unreadMsgCount(MessageVO vo);
	
	int msgTotalCount(int no);
	
	List<MessageVO> unreadMsgList(MessageVO vo);

}
