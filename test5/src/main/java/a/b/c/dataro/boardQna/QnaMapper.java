package a.b.c.dataro.boardQna;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface QnaMapper {
	
	public List<QnaVO> list(QnaVO vo);
	
	public int count(QnaVO vo);  

	public int insert(QnaVO vo);
	
	public QnaVO qnaView(int no); 
	
	public int update(QnaVO vo);
	
	public int gnoUpdate(int gno);
	
	public int onoUpdate(QnaVO vo);

	public int reply(QnaVO vo);

	public int delete(int no);
	
	public void updateViewcount(int no);
	//댓글 좋아요
	public void clickReplyLike(QnaVO vo);
	
}
