package a.b.c.dataro.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

public interface MemberService {
	
	public MemberVO fileupload(MemberVO vo, @RequestParam MultipartFile filename, HttpServletRequest req);
	boolean register(MemberVO vo);
	int checkId(MemberVO vo);
	int checkEmail(MemberVO vo);
	boolean loginCheck(MemberVO vo, HttpSession sess); 
	MemberVO myInfo(String id);
	MemberVO myInfo2(int no);
	boolean editUserInfo(MemberVO vo);
	MemberVO findId(MemberVO vo);
	MemberVO findPwd(MemberVO vo);
	int deleteId(MemberVO vo);

}
