package a.b.c.dataro.room;

import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import a.b.c.dataro.member.MemberVO;

@Controller
@RequestMapping("/dataro/room")
public class RoomController {
	@Autowired	
	RoomService roomService;

	// 모임방채팅리스트
	@PostMapping("/chatlist")
	@ResponseBody
	public List<ChatVO> chatlist(ChatVO vo, @RequestParam int pre_len, Model model, MemberVO mvo) {
		int chat_count = roomService.chatListCount(vo);
		if(pre_len == chat_count) {
			List<ChatVO> nul = null;
			return nul;
		} else {
			List<ChatVO> list = roomService.chatList(vo);
			for(int i=pre_len; i<chat_count; i++) {
				list.get(i).setChat_w_str(new SimpleDateFormat("yy년 MM월 dd일 a HH:mm:ss").format(list.get(i).getChat_writedate()));
			}
			return list;
		}
	}

	// 모임방채팅글쓰기
	@PostMapping("/chatWrite")
	@ResponseBody
	public String chatWrite(ChatVO vo) {
		return roomService.chat(vo) == 1 ? "success" : "fail" ;
	}

	@PostMapping("/makeRoom.do")
	@ResponseBody
	public int makeRoom(RoomVO vo) {
		return roomService.makeRoom(vo);
	}

	@PostMapping("/room.do")
	public String enterRoom(RoomVO vo, HttpSession sess, Model model) {
		//세션에 저장되어있는 로그인 한 사람의 member_no를 roomVO의 room_participant_no번호로 set해서 방에 참가시킴
		MemberVO mvo = (MemberVO)sess.getAttribute("loginInfo");
		 
		vo.setRoom_participant_no(mvo.getMember_no());

		// no=[ ] 로 파라미터 넘어오니 받고 session에 있는 로그인 정보 를 이용해서 디비에 참여자 추가시켜야함.
		//아직 참여하지 않은 방이라면 DB에 insert
		if (roomService.checkRoom(vo) == 0) {
			roomService.enterRoom(vo);
		}
		
		model.addAttribute("view", roomService.view(vo.getRoom_no()));
		return "dataro/room/room";
	}

	@PostMapping("/pwdCheck.do")
	@ResponseBody
	public boolean pwdCheck(RoomVO vo, Model model) {
		return roomService.pwdCheck(vo) == 1;
	}
}
