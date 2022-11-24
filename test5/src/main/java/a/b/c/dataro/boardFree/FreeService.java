package a.b.c.dataro.boardFree;

import java.util.Map;

public interface FreeService {
	
	//목록
	Map index(FreeVO vo);
	
	//상세
	FreeVO view(int no);
	
	//수정폼
	FreeVO edit(int no);
	
	//수정처리
	boolean update(FreeVO vo);
	
	//삭제처리
	boolean delete(int no);
	
	//등록처리
	boolean insert(FreeVO vo);
	
}
