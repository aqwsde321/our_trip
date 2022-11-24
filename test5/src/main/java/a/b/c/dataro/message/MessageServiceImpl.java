package a.b.c.dataro.message;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MessageServiceImpl implements MessageService {

	@Autowired
	MessageMapper msgMapper;
	
	@Override
	public int insert(MessageVO vo) {
		return msgMapper.insert(vo);
	}

	@Override
	public int delReceiveMsg(int no) {
		return msgMapper.delReceiveMsg(no);
	}

	@Override
	public int delSendMsg(int no) {
		return msgMapper.delSendMsg(no);
	}

	@Override
	public int readMsg(int no) {
		return msgMapper.readMsg(no);
	}


	@Override
	public int unreadMsgCount(MessageVO vo) {
		int unreadCount = msgMapper.unreadMsgCount(vo);
		return unreadCount;
	}
	
	@Override
	public int msgTotalCount(int no) {
		return msgMapper.msgTotalCount(no);
	}

	@Override
	public List<MessageVO> unreadMsgList(MessageVO vo) {
		List<MessageVO> unreadList = msgMapper.unreadMsgList(vo);
		return unreadList;
	}


}
