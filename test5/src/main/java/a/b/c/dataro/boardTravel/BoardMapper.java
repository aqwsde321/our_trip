package a.b.c.dataro.boardTravel;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import a.b.c.dataro.map.MapVO;
import a.b.c.dataro.message.MessageVO;
import a.b.c.dataro.room.RoomVO;
import a.b.c.dataro.util.CategoryVO;
import a.b.c.dataro.util.FileVO;

@Mapper
public interface BoardMapper {
	
	List<BoardVO> list(BoardVO vo);
	public void updateViewcount(BoardVO vo);
	public BoardVO view(BoardVO vo); 

	int update(BoardVO vo);
	int delete(int no);
	
	// main 
	List<MapVO> place(int board_no);
	List<CategoryVO> hashtag(int board_no);
	// 여행코스글쓰기 pboard 테이블에 작성 정보 삽입
	int boardInsert(BoardVO vo);
	// 여행코스글쓰기/코스등록 
	int boardCourseInsert(BoardVO vo);
	// 여행코스수정 화면출력
	BoardVO updateView(BoardVO vo);
	List<MapVO> getCourse(BoardVO vo);
	List<CategoryVO> updateCategory(BoardVO vo);
	List<CategoryVO> updateCategory2(BoardVO vo);
	// 여행코스글,타이틀 수정
	int boardUpdate(BoardVO vo);
	int boardCourseDel(BoardVO vo);
	
	//게시글 삭제
	public int delete(BoardVO vo);
	
	int count1(BoardVO vo);
	int count2(BoardVO vo);
	int count3(BoardVO vo);
	
	List<BoardVO> myList1(BoardVO vo);
	List<BoardVO> myList2(BoardVO vo);
	List<BoardVO> myList3(BoardVO vo);
	
	List<RoomVO> myList6(RoomVO vo);

	
}
