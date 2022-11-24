package a.b.c.dataro.boardTravel;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import a.b.c.dataro.map.MapMapper;
import a.b.c.dataro.map.MapVO;
import a.b.c.dataro.member.MemberMapper;
import a.b.c.dataro.member.MemberVO;
import a.b.c.dataro.message.MessageMapper;
import a.b.c.dataro.message.MessageVO;
import a.b.c.dataro.room.RoomMapper;
import a.b.c.dataro.room.RoomVO;
import a.b.c.dataro.util.CategoryMapper;
import a.b.c.dataro.util.CategoryVO;
import a.b.c.dataro.util.FileMapper;
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {
	
	BoardMapper bMapper;
	RoomMapper roomMapper;
	MapMapper mapMapper;
	CategoryMapper cMapper;
	FileMapper fMapper;
	MemberMapper memMapper;
	MessageMapper msgMapper;
	
	// main
	@Override
	public List<BoardVO> list(BoardVO bvo) {
		int startIdx = (bvo.getPage()-1) * bvo.getPageRow(); 
		bvo.setStartIdx(startIdx); // 무한 스크롤 사용을 위해 
		List<BoardVO> list = bMapper.list(bvo); // 게시물+좋아요수+댓글수+사진1장+검색결과 가져오기
		for (int i=0; i<list.size(); i++) {
			list.get(i).setPlaceList(mapMapper.list(list.get(i).getBoard_no())); // 지도 가져오기
			list.get(i).setCategoryList(cMapper.categoryList(list.get(i)));  // 카테고리 가져오기
		}
		return list;
	}
	
	//여행코스글쓰기 pbaord 내용 삽입 + board_no 설정 
	@Override
	public void boardInsert(BoardVO bvo, CategoryVO cvo) {
		bMapper.boardInsert(bvo);
		mapMapper.updateBoardNo(bvo);  // board_no 가지고 오자마자 pmap테이블에 board_no 업데이트하기.
	}
	
	//여행코스글수정 pboardcourse 내용 삽입
	@Override
	public void boardCourseInsert(BoardVO bvo) {
		for(int i=0; i<bvo.getContents().length; i++) {
			bvo.setContent(bvo.getContents()[i]);
			bvo.setCourse_no(i+1);
			bMapper.boardCourseInsert(bvo);
		}
	}
	
	//여행코스글수정
	@Override
	public void boardCourseDel(BoardVO bvo) {
		bMapper.boardCourseDel(bvo);  // pboardcourse에서 해당 content 삭제
	}
	@Override
	public void boardUpdate(BoardVO bvo) {
		bMapper.boardUpdate(bvo);
	}
		
	//여행코스글수정 화면 불러오기
	@Override
	public Map<String, Object> getCourse(BoardVO vo, String use) {
		//vo에 board_no가 담겨있음
		List<MapVO> courseList = bMapper.getCourse(vo); //board_no에 맞는 view에 보일 코스(지도정보, 글내용) 가지고 오기
		
		for (int i=0; i<courseList.size(); i++) {//MapVO가 배열로 담겨있음
			vo.setCourse_no(courseList.get(i).getCourse_no()); //BoardVO의 course_no에  MapVO의 course_no를 set해줌
			courseList.get(i).setFileList(fMapper.fileUpdate(vo)); //maplist의 i번쨰에 filelist필드에 vo(board_no,위에서set한 코스번호를 사용해서 파일을 조회한 값을 set함)
		}
		
		Map<String, Object> list = new HashMap<String, Object>();
		list.put("course",courseList);
		
		if (use.equals("view")) return list;
		
		// 글 수정에서 사용했을때 else 사용
		else {
			list.put("view",bMapper.updateView(vo)); // board_no, memeber_no, title 담기
			list.put("hrcategory",bMapper.updateCategory(vo)); //선택한 해쉬태그
			list.put("hrcategory2",bMapper.updateCategory2(vo)); //선택한 지역
			return list;
		}
	}

	//게시글 상세보기
	@Override
	public Map<String, Object> view(BoardVO vo) {
		bMapper.updateViewcount(vo); //조회수 증가 후
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("roomList", roomMapper.roomList(vo));  // 채팅방 리스트 가져오기
		map.put("categoryList", cMapper.categoryList(vo)); // 게시물 카테고리 가져오기
		
		BoardVO bvo = bMapper.view(vo);
		map.put("board", bvo);
		map.put("member", memMapper.myInfo2(bvo.getMember_no()));
		
		return map;
	}

	@Override
	public int delete(BoardVO vo) {
		return bMapper.delete(vo);
	}
	
	@Override
	public int clickBoardLike(BoardVO vo) { 
		return cMapper.clickBoardLike(vo); 	//게시글 좋아요
	}

	@Override
	public void clickDislike(BoardVO vo) {
		cMapper.clickDislike(vo); //게시글 싫어요
	}

	@Override
	public void clickReplyLike(BoardVO vo) {
		cMapper.clickReplyLike(vo); //댓글 좋아요
	}

	@Override
	public int likeCheck(BoardVO vo) {
		return cMapper.likeCheck(vo); //로그인한 member_no가 좋아요 눌렀는지 체크
	}

	@Override
	public void likeBack(BoardVO vo) {
		cMapper.likeBack(vo); 	//좋아요 취소
	}

	@Override
	public int dislikeCheck(BoardVO vo) {
		return cMapper.dislikeCheck(vo); //로그인한 member_no가 싫어요 눌렀는지 체크
	}

	@Override
	public void dislikeBack(BoardVO vo) {
		cMapper.dislikeBack(vo); //싫어요 취소
	}
	
	// 이거 사용?
	@Override
	public List<MapVO> place(int board_no) {
		return bMapper.place(board_no);
	}

	// 내가 쓴 게시물(마이페이지)
	@Override
	public Map<String, Object> myList(BoardVO vo, MessageVO mvo,int listIdx, HttpSession sess) {
		Map<String, Object> map = new HashMap<String, Object>();
		int totalCount = 0;

		switch (listIdx) {
		case 1:		
			totalCount = bMapper.count1(vo);
			break;
		case 2:		
			totalCount = bMapper.count2(vo);
			break;
		case 3:
			totalCount = bMapper.count3(vo);
			break;
		case 4:
			totalCount = msgMapper.count4(mvo);
			break;
		case 5:
			totalCount = msgMapper.count5(mvo);
			break;
		}
		
		int totalPage = totalCount / vo.getPageRow();
		if(totalCount % vo.getPageRow() > 0) totalPage++;
		int startIdx = (vo.getPage()-1) * vo.getPageRow();
		vo.setStartIdx(startIdx);
		mvo.setStartIdx(startIdx);
		
		switch (listIdx) {
		case 1:
			map.put("list", bMapper.myList1(vo));
			break;
		case 2:		
			map.put("list", bMapper.myList2(vo));
			break;
		case 3:
			map.put("list", bMapper.myList3(vo));
			break;
		case 4:
			map.put("list", msgMapper.myList4(mvo));
			break;
		case 5:
			map.put("list", msgMapper.myList5(mvo));
			break;
		}
		
		int endPage = (int)(Math.ceil(vo.getPage()/((float)vo.getPageRow()))*vo.getPageRow());
		int startPage = endPage - vo.getPageRow() + 1;
		if (endPage > totalPage) endPage = totalPage;
		boolean prev = startPage > 1 ? true : false;
		boolean next = endPage < totalPage ? true: false;
		
		map.put("totalCount", totalCount);
		map.put("totalPage", totalPage);
		
		map.put("startPage", startPage);
		map.put("endPage", endPage);
		map.put("prev", prev);
		map.put("next", next);
		
		return map;
	}

	// 내가 참여한 방(마이페이지)
	@Override
	public List<RoomVO> myList6(RoomVO vo, HttpSession sess) {
		MemberVO vo1 = (MemberVO) sess.getAttribute("loginInfo");
		int no = vo1.getMember_no();
		vo.setRoom_participant_no(no);
		return bMapper.myList6(vo);
	}
}
