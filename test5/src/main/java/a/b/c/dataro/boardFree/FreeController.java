package a.b.c.dataro.boardFree;

import java.io.File;
import java.util.Date;
import java.util.List;
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

import a.b.c.dataro.boardTravel.BoardService;
import a.b.c.dataro.boardTravel.BoardVO;
import a.b.c.dataro.map.MapMapper;
import a.b.c.dataro.member.MemberService;
import a.b.c.dataro.member.MemberVO;
import a.b.c.dataro.message.MessageVO;
import a.b.c.dataro.room.RoomVO;
import a.b.c.dataro.util.CategoryVO;
import a.b.c.dataro.util.FileVO;
import a.b.c.dataro.util.UtilService;

@Controller
@RequestMapping("/dataro/boardFree")
public class FreeController {
	
	@Autowired
	FreeService fService;
	
	@Autowired
	BoardService bService;
	
	@Autowired
	MemberService mService;

	@Autowired
	UtilService uService;

	@GetMapping("/main.do")
	public String list(Model model, FreeVO vo, HttpSession sess) {
		model.addAttribute("data",fService.index(vo));
		return "dataro/boardFree/main";
	}
	
	@GetMapping("/write.do")
	public String write() {
		return "dataro/boardFree/write";
	}
	
	@PostMapping("/insert.do")
	public String insert(FreeVO vo, Model model, 
			@RequestParam MultipartFile filename,
			HttpServletRequest req) {
		//첨부파일 처리
		if(!filename.isEmpty()) {
			//파일명 변경
			String org = filename.getOriginalFilename(); //사용자가 첨부한 첨부파일의 파일명을 가지고옴(확장자 포함)
			String ext = org.substring(org.lastIndexOf(".")); // 확장자 추출
			String server = new Date().getTime() + ext; // 실제 파일명 : 서버에 저장할 파일명
			
			//파일저장
			String path = req.getRealPath("/upload/"); 
			try {
			filename.transferTo(new File(path+server)); 
			
			} catch (Exception e) {}
			
			vo.setFilename_org(org);
			vo.setFilename_server(server);
		}
		
		if(fService.insert(vo)) {
			model.addAttribute("msg", "정상적으로 저장되었습니다.");
			model.addAttribute("url", "/dataro/boardFree/main.do");
			return "dataro/common/alert";
		} else {
			model.addAttribute("msg", "글쓰기에 실패하였습니다.");
			return "dataro/common/alert";
		}
	}
	
	@GetMapping("/view.do")
	public String view(FreeVO freevo, Model model, HttpSession sess) {
		MemberVO mvo = (MemberVO)sess.getAttribute("loginInfo");
		//글 보고있는 사람(로그인 한 사람)
		if(mvo!= null) {
			freevo.setLogin_member_no(mvo.getMember_no());
		}
		model.addAttribute("data", fService.view(freevo.getBoard_no()));
		return "dataro/boardFree/view";
	}
	
	@GetMapping("/edit.do")
	public String edit(FreeVO fvo, Model model) {
		FreeVO data = fService.edit(fvo.getBoard_no());
		model.addAttribute("data", data);
		return "dataro/boardFree/edit";
	}
	
	@PostMapping("/update.do")
	public String update(FreeVO fvo, Model model) {
		if(fService.update(fvo)) {
			model.addAttribute("msg", "정상적으로 수정되었습니다.");
			model.addAttribute("url", "view.do?board_no="+fvo.getBoard_no());
			return "dataro/common/alert";
		} else {
			model.addAttribute("msg", "게시글 수정에 실패하였습니다.");
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
	
	@PostMapping("/delete.do")
	@ResponseBody
	public Integer delete(FreeVO vo, Model model) {
		if(fService.delete(vo.getBoard_no())) {
			return 1;
		} else {
			return 0;
		}
	}
}
