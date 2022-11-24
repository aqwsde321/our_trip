package a.b.c.dataro.boardTravel;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import a.b.c.dataro.map.MapVO;
import a.b.c.dataro.message.MessageVO;
import a.b.c.dataro.room.RoomVO;
import a.b.c.dataro.util.CategoryVO;
import a.b.c.dataro.util.FileVO;

public interface BoardService {
	
	List<BoardVO> list(BoardVO vo);
	List<MapVO> place(int board_no);
	// write
	void boardInsert(BoardVO bvo, CategoryVO cvo);
	void boardCourseInsert(BoardVO bvo);
	Map getCourse(BoardVO bvo, String use);
	//여행글쓰기 글수정
	void boardCourseDel(BoardVO bvo); 
	void boardUpdate(BoardVO bvo);

	//상세
	Map view(BoardVO vo);
	//게시글 삭제
	int delete(BoardVO vo);
	//게시글 좋아요
	int clickBoardLike(BoardVO vo);
	//게시글 싫어요
	void clickDislike(BoardVO vo);
	//댓글 좋아요
	void clickReplyLike(BoardVO vo);
	int likeCheck(BoardVO vo);
	int dislikeCheck(BoardVO vo);
	void likeBack(BoardVO vo);
	void dislikeBack(BoardVO vo);

	Map myList(BoardVO vo,  MessageVO mvo, int listIdx, HttpSession sess);
	// 마이페이지 관련
	List<RoomVO> myList6(RoomVO vo, HttpSession sess);
}
