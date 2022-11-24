package a.b.c.dataro.util;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import a.b.c.dataro.boardTravel.BoardVO;

//글등록
@Mapper
public interface CategoryMapper {
	
	//카테고리에서 선택한 해쉬태그랑 지역정보 가져오기
	public List<CategoryVO> categoryList(BoardVO vo);

	//해쉬태그 등록
	int hashInsert(CategoryVO vo);
	
	//해쉬태그 출력
	List<CategoryVO> hash();
	
	//해쉬태그 수정(삭제후재등록)
	int categoryDel(CategoryVO vo);
	
	//지역 출력
	List<CategoryVO> regionSelect();
	
	//지역 대분류 db전송후 소분류 가져오기
	List<CategoryVO> regionDetail(String rs);
	
	//지역번호 가져와서 카테고리테이블에 등록
	int regionInsert(CategoryVO vo);
	
	
	//게시글 좋아요
	public int clickBoardLike(BoardVO vo);
	//게시글 싫어요
	public void clickDislike(BoardVO vo);
	//댓글 좋아요
	public void clickReplyLike(BoardVO vo);
	//로그인한 member_no가 좋아요 눌렀는지 체크
	public int likeCheck(BoardVO vo);
	//로그인한 member_no가 싫어요 눌렀는지 체크
	public int dislikeCheck(BoardVO vo);
	//좋아요 취소
	public int likeBack(BoardVO vo);
	//싫어요 취소
	public int dislikeBack(BoardVO vo);
}
