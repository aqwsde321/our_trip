package a.b.c.dataro.boardQna;

import java.util.Map;

public interface QnaService {
	
	//목록
	Map index(QnaVO vo);
	
	//상세
	QnaVO view(int no);
	
	//수정폼
	QnaVO edit(int no);
	
	//수정처리
	boolean update(QnaVO vo);
	
	//삭제처리
	boolean delete(int no);
	
	//등록처리
	boolean insert(QnaVO vo);
	
	//답변등록
	boolean reply(QnaVO vo);
}
