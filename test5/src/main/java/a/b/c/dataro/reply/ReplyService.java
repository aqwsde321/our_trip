package a.b.c.dataro.reply;

import java.util.List;
import java.util.Map;

public interface ReplyService {
	
	//목록 출력
	public Map list(ReplyVO vo);
	//답글 목록
	public List<ReplyVO> replyList(ReplyVO vo);
	//수정처리
	boolean update(ReplyVO vo);
	//삭제처리
	boolean delete(int no);
	//등록처리
	boolean insert(ReplyVO vo);
	//답변등록
	boolean reply(ReplyVO vo);
}
	