package a.b.c.dataro.member;

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
import a.b.c.dataro.message.MessageService;
import a.b.c.dataro.message.MessageVO;
import a.b.c.dataro.room.RoomVO;

@Controller
@RequestMapping("/dataro/member")
public class MemberController {
	
	@Autowired
	MemberService memService;
	
	@Autowired
	MessageService msgService;
	
	@Autowired
	BoardService bService;

	// 회원가입화면
	@GetMapping("/register")
	public String register() {
		return "dataro/member/register";
	}
	
	// 아이디 중복체크
	@PostMapping("/checkId")
	@ResponseBody
	public int checkId(MemberVO vo, @RequestParam String id) {
		return memService.checkId(vo);
	}
	
	// 이메일 중복체크
	@PostMapping("/checkEmail")
	@ResponseBody
	public int checkEmail(MemberVO vo, HttpSession sess) {
		MemberVO vo1 = (MemberVO) sess.getAttribute("loginInfo");
		if (vo1 == null) {
			return memService.checkEmail(vo);
		} else {
			if (vo1.getEmail().toUpperCase().equals(vo.getEmail().toUpperCase())) {
				return -1;
			} else {
				return memService.checkEmail(vo);
			}
		}
	}
		
	// 입력하지 않거나 틀린 정보를 입력 후, 회원가입을 클릭했을 때
	@PostMapping("/register")
	public String insert(MemberVO vo, Model model, 
			@RequestParam MultipartFile filename, 
			HttpServletRequest req, HttpSession sess) {

		String emailT = vo.getEmail() + '@'+ vo.getEmail2();
		vo.setEmail(emailT);
		vo = memService.fileupload(vo, filename, req);
		if (memService.register(vo)) {
			model.addAttribute("msg", "회원가입이 완료되었습니다.");
			model.addAttribute("url", "/dataro/boardTravel/main.do");
			return "dataro/common/alert";
		} else {
			model.addAttribute("msg", "가입할 회원정보를 다시 한 번 확인해주세요.");
			return "dataro/common/alert";
		}
	}
	
	// 아이디, 비밀번호 찾기 화면
	@GetMapping("/findIdPwd")
	public String findIdPwd(){
		return "dataro/member/findIdPwd";
	};
	
	// 아이디 찾기
	@GetMapping("/findId")
	public void findId(){};
	
	//이메일 정보로 아이디 찾기
	@PostMapping("/findId")
	@ResponseBody
	public String findId(Model model, MemberVO vo) {
		MemberVO vo1 = memService.findId(vo);
		if (vo1 != null) {
			return vo1.getId();
		} else return "";
	}
	
	// 비밀번호 찾기
	@GetMapping("/findPwd")
	public void findPwd(){};
	
	@PostMapping("/findPwd")
	@ResponseBody
	public String findPwd(Model model, MemberVO vo) {
		MemberVO vo1 = memService.findPwd(vo);
		if(vo1 != null) {
			return vo1.getPwd();
		}else return "";
	}
	
	// 로그인
	@GetMapping("/login")
	public String login() {
		return "dataro/member/login";
	}
	
	@PostMapping("/login")
	public String login(MemberVO vo, HttpSession sess, Model model) {
		if (memService.loginCheck(vo, sess)) {
			MemberVO vo1 = (MemberVO) sess.getAttribute("loginInfo");
			model.addAttribute("msg",  vo1.getNickname() + " 님 안녕하세요 :) ");
			model.addAttribute("url", "/dataro/boardTravel/main.do");
			return "dataro/common/alert";
		} else {
			model.addAttribute("msg", "아이디 혹은 비밀번호가 틀립니다.");
			return "dataro/common/alert";
		}
	}
	
	// 로그아웃
	@RequestMapping("/logout")
	public String logout(Model model, HttpServletRequest req) {
		HttpSession sess= req.getSession();
		sess.invalidate(); // 세션객체에 저장된 값 모두 초기화. 
		model.addAttribute("msg", "로그아웃되었습니다.");
		model.addAttribute("url", "/dataro/boardTravel/main.do");
		return "dataro/common/alert";
	}
	
	// 회원정보수정화면
	@GetMapping("/editMemberInfo") 
	public String editUserInfo() {
		return "dataro/member/editMemberInfo";
	}
	
	// 회원정보수정처리
	@PostMapping("/editUserInfo")
	public String editUserInfo(MemberVO vo, 
								HttpSession sess,
								Model model, 
								@RequestParam MultipartFile filename, 
								HttpServletRequest req){
		
		String emailT = vo.getEmail() + '@'+ vo.getEmail2();
		vo.setEmail(emailT);
		
		vo = memService.fileupload(vo, filename, req);
		
		if (memService.editUserInfo(vo)) {
			model.addAttribute("msg",  "회원정보 수정이 완료되었습니다. 다시 로그인해주세요");
			model.addAttribute("url", "/dataro/boardTravel/main.do");
			sess.invalidate(); // 세션객체에 저장된 값 모두 초기화. 

			return "dataro/common/alert";
		} else {
			model.addAttribute("msg", "회원정보를 확인해 주세요");
			return "dataro/common/alert";
		}
	}
	
	@GetMapping("/myPage")
	public String myPage() {
		return "dataro/member/myPage";
	}
	
	// 탈퇴처리
	@PostMapping("/leave")
	public String leave(MemberVO vo, Model model, HttpSession sess) {
		if (memService.deleteId(vo) > 0) {
			model.addAttribute("msg",  "계정 삭제가 완료되었습니다.");
			model.addAttribute("url", "/dataro/boardTravel/main.do");
			sess.invalidate();
			return "dataro/common/alert";
		} else {
			model.addAttribute("msg", "비밀번호가 맞지 않습니다.");
			return "dataro/common/alert";
		}
	}
	
	// 마이페이지 내가 쓴 게시글 보기
	@GetMapping("/myList")
	public String mylist(BoardVO bvo, MessageVO mvo, RoomVO rvo, @RequestParam int listIdx, Model model, HttpSession sess) {
		MemberVO vo1 = (MemberVO) sess.getAttribute("loginInfo");
		int no = vo1.getMember_no();
		bvo.setMember_no(no);
		bvo.setPageRow(5);
		mvo.setReceive_member_no(no);
		mvo.setSend_member_no(no);

		if (listIdx == 6) {
			rvo.setRoom_participant_no(no);
			model.addAttribute("list", bService.myList6(rvo, sess));
		} else {
			model.addAttribute("data", bService.myList(bvo, mvo, listIdx, sess));
		}
		
		String s= "dataro/member/myList" + listIdx;
		return s;
	}
	
	// 메인화면에 종 아이콘 클릭시 안읽은 쪽지내용 보기
	@RequestMapping("/alarm")
	public String alarm(MessageVO vo, Model model, HttpSession sess) {
		MemberVO vo1 = (MemberVO)sess.getAttribute("loginInfo");
		int member_no = vo1.getMember_no();
		vo.setReceive_member_no(member_no);
		model.addAttribute("unreadList", msgService.unreadMsgList(vo));
		return "dataro/common/alarm";
	}
}
