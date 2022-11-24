package a.b.c.dataro.member;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper {
	
	// 회원등록
	int insert(MemberVO vo);
	// 중복아이디 찾기
	int checkId(MemberVO vo);
	// 중복이메일 찾기
	int checkEmail(MemberVO vo);
	// 로그인 할 때, 아이디 패스워드 확인용
	MemberVO checkIdPw(MemberVO vo); 
	// 아이디로 해당하는 개인정보 가져오기
	MemberVO myInfo(String id);
	// 회원번호로 해당하는 개인정보 가져오기
	MemberVO myInfo2(int no);
	// 회원정보수정
	int editUserInfo(MemberVO vo);
	// 아이디 찾기
	MemberVO findId(MemberVO vo);
	// 비밀번호 찾기
	MemberVO findPwd(MemberVO vo);
	// 임시비밀번호로 비밀번호 업데이트
	int updateTempPwd(MemberVO vo); 
	// 회원삭제
	int deleteId(MemberVO vo);

	

	
}
