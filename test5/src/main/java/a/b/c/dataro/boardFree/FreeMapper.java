package a.b.c.dataro.boardFree;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface FreeMapper {
	
	public List<FreeVO> list(FreeVO vo);
	
	public int count(FreeVO vo);  

	public int insert(FreeVO vo);
	
	public FreeVO freeView(int no); 
	
	public int update(FreeVO vo);

	public int delete(int no);
	
	public void updateViewcount(int no);
	//댓글 좋아요
	public void clickReplyLike(FreeVO vo);
}
