package a.b.c.dataro.boardQna;

import java.io.File;
import java.util.Date;

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
import a.b.c.dataro.member.MemberService;
import a.b.c.dataro.member.MemberVO;
import a.b.c.dataro.util.UtilService;

@Controller
@RequestMapping("/dataro/boardQna")
public class QnaController {
	
	@Autowired
	QnaService qService;
	
	@Autowired
	BoardService bService;
	
	@Autowired
	MemberService mService;

	@Autowired
	UtilService uService;

	@GetMapping("/main.do")
	public String list(Model model, QnaVO qvo, HttpSession sess) {
		model.addAttribute("data",qService.index(qvo));
		return "dataro/boardQna/main";
	}
	
	@GetMapping("/write.do")
	public String write() {
		return "dataro/boardQna/write";
	}
	
	@PostMapping("/insert.do")
	public String insert(QnaVO qvo, Model model, 
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
			
			qvo.setFilename_org(org);
			qvo.setFilename_server(server);
		}
		
		if(qService.insert(qvo)) {
			model.addAttribute("msg", "정상적으로 저장되었습니다.");
			model.addAttribute("url", "/dataro/boardQna/main.do");
			return "dataro/common/alert";
		} else {
			model.addAttribute("msg", "글쓰기에 실패하였습니다.");
			return "dataro/common/alert";
		}
	}
	
	@GetMapping("/view.do")
	public String view(QnaVO qvo, Model model, HttpSession sess) {
		MemberVO mvo = (MemberVO)sess.getAttribute("loginInfo");
		//글 보고있는 사람(로그인 한 사람)
		if(mvo!= null) {
			qvo.setLogin_member_no(mvo.getMember_no());
		}
		model.addAttribute("data", qService.view(qvo.getBoard_no()));
		return "dataro/boardQna/view";
	}
	
	@GetMapping("/reply.do")
	public String reply(QnaVO qvo, Model model) {
		QnaVO data = qService.edit(qvo.getBoard_no());
		model.addAttribute("data", data);	
		return "dataro/boardQna/reply";
	}
	
	@PostMapping("/reply.do")
	public String reply(QnaVO qvo, Model model, 
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
			
			qvo.setFilename_org(org);
			qvo.setFilename_server(server);
		}
		//session에 저장된 로그인 정보에서 no(MemberVO) 꺼내서 member_no(replyVO)에 set
		HttpSession sess = req.getSession();
		MemberVO mv = (MemberVO)sess.getAttribute("loginInfo");
		qvo.setMember_no(mv.getMember_no());
		qvo.setId(mv.getId());
		
		if(qService.reply(qvo)) {
			model.addAttribute("msg", "정상적으로 저장되었습니다.");
			model.addAttribute("url", "main.do");
			return "dataro/common/alert";
		} else {
			model.addAttribute("msg", "글쓰기에 실패하였습니다.");
			return "dataro/common/alert";
		}
	}
	
	@GetMapping("/edit.do")
	public String edit(QnaVO qvo, Model model) {
		QnaVO data = qService.edit(qvo.getBoard_no());
		model.addAttribute("data", data);
		return "dataro/boardQna/edit";
	}
	
	@PostMapping("/update.do")
	public String update(QnaVO qvo, Model model) {
		if(qService.update(qvo)) {
			model.addAttribute("msg", "정상적으로 수정되었습니다.");
			model.addAttribute("url", "view.do?board_no="+qvo.getBoard_no());
			return "dataro/common/alert";
		} else {
			model.addAttribute("msg", "게시글 수정에 실패하였습니다.");
			return "dataro/common/alert";
		}
	}
	
	@PostMapping("/initBoardLike.do")
	@ResponseBody
	public Integer boardLike(BoardVO vo, Integer likeCheck) {
		//
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
	public Integer delete(QnaVO qvo, Model model) {
		if(qService.delete(qvo.getBoard_no())) {
			return 1;
		} else {
			return 0;
		}
	}
}
