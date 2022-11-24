package a.b.c.dataro.member;

import java.io.File;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import a.b.c.dataro.message.MessageService;
import a.b.c.dataro.message.MessageVO;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	MemberMapper memMapper;
	@Autowired
	MessageService msgService;
	
	@Override
	public MemberVO fileupload(MemberVO vo
								, @RequestParam MultipartFile filename
								, HttpServletRequest req) {
		if (!filename.isEmpty()) {
			// 파일명 구하기
			String org = filename.getOriginalFilename();
			String ext = org.substring(org.lastIndexOf(".")); // 확장자
			String real = new Date().getTime()+ext;
			// 파일저장
			String path = req.getRealPath("/upload/");
			try {
			filename.transferTo(new File(path+real));
			} catch (Exception e) {}
			vo.setM_filename_org(org);
			vo.setM_filename_server(real);
		} else {
			vo.setM_filename_server("123.png");
		}
		return vo;
	}
	
	// 회원 등록
	@Override
	public boolean register(MemberVO vo) {
		return memMapper.insert(vo) > 0 ? true : false;
	}
	
	// 아이디 중복확인
	@Override
	public int checkId(MemberVO vo) {
		return memMapper.checkId(vo);
	}
	
	// 이메일 중복확인
	@Override
	public int checkEmail(MemberVO vo) {
		return memMapper.checkEmail(vo);
	}
	
	// DB에 저장된 정보가 있어서 로그인 성공하면 로그인정보가 세션에 저장.
	@Override
	public boolean loginCheck(MemberVO vo, HttpSession sess) {
		boolean r = false;
		MemberVO loginInfo = memMapper.checkIdPw(vo);
		if (loginInfo != null) { // 로그인 가능한 상태. 
			r = true;
			sess.setAttribute("loginInfo", loginInfo);
			sess.setAttribute("msg_cnt", msgService.msgTotalCount(loginInfo.getMember_no()));
		}
		return r; // 로그인 불가능한 상태. 
	}
	
	// 아이디로 해당하는 개인정보 가져오기
	@Override
	public MemberVO myInfo(String id) {
		return memMapper.myInfo(id);
	}
	
	// 회원정보수정
	@Override
	public boolean editUserInfo(MemberVO vo) {
		return memMapper.editUserInfo(vo) > 0 ? true : false;
	}
	
	// 아이디 찾기
	@Override
	public MemberVO findId(MemberVO vo) {
		return memMapper.findId(vo);
	}
	
	// 비밀번호찾기화면에서 입력한 아이디와 이메일이 디비에 저장되어 있나 확인 후, 임시비밀번호로 업데이트.
	@Override
	public MemberVO findPwd(MemberVO vo) {
		MemberVO vo1 = memMapper.findPwd(vo);
		if (vo1 != null) {
			// 임시비밀번호 생성
			// 영문 4 자리, 숫자 4 자리
			String temp ="!";
			for (int i=0; i < 4; i++) { 
				temp += (char)(Math.random()*26 + 65); // 26은 대문자만 나오게 하려고, 65부터 대문자 A
				temp += (int)(Math.random()*9);
			}
			vo1.setPwd(temp);
			memMapper.updateTempPwd(vo1);  // 임시비밀번호로 업데이트
			//String email = vo1.getEmail();
			// email발송
			//SendMail.sendMail("jeonggil5579@naver.com", email, "[Dataro]임시 비밀번호", "임시비밀번호는 "+ temp + " 입니다.");
			return vo1;
		} else {
			return null;
		}
	}

	// 회원탈퇴
	@Override
	public int deleteId(MemberVO vo) {
		return memMapper.deleteId(vo);
	}

	// 회원번호로 해당하는 개인정보 가져오기
	@Override
	public MemberVO myInfo2(int no) {
		return memMapper.myInfo2(no);
	}
}
