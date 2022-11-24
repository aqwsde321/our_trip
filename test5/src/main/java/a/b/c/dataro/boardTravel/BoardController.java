package a.b.c.dataro.boardTravel;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import a.b.c.dataro.member.MemberService;
import a.b.c.dataro.member.MemberVO;
import a.b.c.dataro.message.MessageService;
import a.b.c.dataro.room.RoomVO;
import a.b.c.dataro.util.CategoryVO;
import a.b.c.dataro.util.FileMapper;
import a.b.c.dataro.util.FileVO;
import a.b.c.dataro.util.UtilService;

@Controller
@RequestMapping("/dataro/boardTravel")
public class BoardController {
	
	@Autowired
	BoardService bService;
	
	@Autowired
	MessageService msgService;
	
	@Autowired
	MemberService mService;

	@Autowired
	UtilService uService;

	@Autowired
	FileMapper fMapper;
	
	// main
	@GetMapping("/main.do")
	public String mainGet(Model model, BoardVO bvo, HttpSession sess) {
		bvo.setPageRow(9);
		model.addAttribute("list",bService.list(bvo)); // 게시물+좋아요수+댓글수+사진1장+검색결과+지도+해쉬+지역 가져오기 무한스크롤 사용을 위한 페이징인덱스까지 처리해서
		if (bvo.getPage() > 1) return "dataro/boardTravel/mainlist"; // ajax로 무한스크롤 위해 main.do 호출시 여기까지 
		
		model.addAttribute("wordsearch", 1);
		model.addAttribute("category",uService.writeCategory()); //기본 해쉬태그+지역 가져오기
		return "dataro/boardTravel/main";
	}
	
	@RequestMapping("/getCourse.do")
	@ResponseBody  // board_no넘어옴
	public Map getCourse(BoardVO bvo, @RequestParam String use) {
		return bService.getCourse(bvo, use);
	}
	
	@GetMapping("/view.do")
	public String view(BoardVO vo, RoomVO rvo, Model model, HttpSession sess) {
		MemberVO mvo = (MemberVO)sess.getAttribute("loginInfo");
		//글 보고있는 사람(로그인 한 사람)
		if(mvo!= null) {
			vo.setLogin_member_no(mvo.getMember_no());
		}
		model.addAttribute("data", bService.view(vo));
		return "dataro/boardTravel/view";
	}
		
	//여행코스 글쓰기화면
	@GetMapping("/write.do")
	public String write(Model model) {
		model.addAttribute("category",uService.writeCategory()); //기본 해쉬태그+지역 가져오기
		return "dataro/boardTravel/write";
	}
	
	// 여행코스 글쓰기
	@PostMapping("/insert.do")
	public String insert(BoardVO bvo,CategoryVO cvo,FileVO fvo,@RequestParam MultipartFile[] filename, HttpServletRequest req) {
		bService.boardInsert(bvo, cvo);
		bService.boardCourseInsert(bvo);
		
		cvo.setBoard_no(bvo.getBoard_no()); // 커맨드객체 cvo에 정해진 board_no 주기
		fvo.setBoard_no(bvo.getBoard_no());
		
		uService.categoryInsert(cvo);
		uService.fileUpload(fvo, filename, req);
		return "redirect:/dataro/boardTravel/main.do";
	}
	
	//여행코스 글쓰기 수정화면 
	@PostMapping("/updateView.do")
	public String updateView(BoardVO bvo, Model model) {
		model.addAttribute("category",uService.writeCategory()); //카테고리전체 리스트 화면출력
		return "dataro/boardTravel/update";
	}
	
	//여행코스 글쓰기 수정
	@RequestMapping("/edit.do")
	public String edit(BoardVO bvo, CategoryVO cvo,FileVO fvo,@RequestParam MultipartFile[] filename,@RequestParam String[] dbimgs, HttpServletRequest req) throws UnsupportedEncodingException {
		bService.boardUpdate(bvo);
		
		bService.boardCourseDel(bvo);
		bService.boardCourseInsert(bvo);
		
		uService.categoryDel(cvo);//태그,지역삭제
		uService.categoryInsert(cvo);//태그재등록
		
		uService.uploadFileDel(uService.uploadFileDelList(bvo, dbimgs), req);
		uService.fileDelDB(bvo);
		uService.fileUpload(fvo, filename, req);
		uService.fileReUpload(fvo, dbimgs);
		return "redirect:/dataro/boardTravel/view.do?board_no="+bvo.getBoard_no()+"&board_name="+URLEncoder.encode(bvo.getBoard_name(), "UTF-8");
	}
	
	//travel view 삭제
	@PostMapping("/viewDelete.do")
	public String viewDelete(BoardVO bvo, CategoryVO cvo, HttpServletRequest req, Model model) {
		if(bService.delete(bvo)==1) { // pboard 에서 게시물 하나 지우기
			bService.boardCourseDel(bvo); // 해당게시물 코스들 지이구
			uService.uploadFileDel(uService.uploadFileDelList(bvo, null), req); // 해당게시물 서버에 업로드한 파일 지우기
			uService.categoryDel(cvo); // 해당게시물 카테고리선택한거 지우기
			uService.fileDelDB(bvo); // 해당게시물 파일 db에서 삭제
			model.addAttribute("msg", "정상적으로 삭제되었습니다.");
			model.addAttribute("url", "/dataro/boardTravel/main.do");
			return "dataro/common/alert";
		} else {
			model.addAttribute("msg", "삭제에 실패하였습니다.");
			return "dataro/common/alert";
		}
	}
	
	@PostMapping("/initBoardLike.do")
	@ResponseBody
	public Integer boardLike(BoardVO vo, Integer likeCheck) {
		if(likeCheck==0) {
			bService.clickBoardLike(vo);
			return 1;
		} else if(likeCheck > 0) {
			bService.likeBack(vo);
			return 0;
		}
		return bService.likeCheck(vo);
	}
	
	@PostMapping("/clickDislike.do")
	@ResponseBody
	public Integer boardDislike(BoardVO vo, Integer dislikeCheck) {
		if(dislikeCheck==0) {
			bService.clickDislike(vo);
			return 1;
		} else if(dislikeCheck > 0) {
			bService.dislikeBack(vo);
			return 0;
		}
		return bService.dislikeCheck(vo);
	}
	
	//지역나오게
	@RequestMapping("/region_detail")
	@ResponseBody
	public Map regionDatail(String rs) {
		return uService.regionDetail(rs);
	}
	
}
