package a.b.c.dataro.message;


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

import a.b.c.dataro.member.MemberVO;

@Controller
@RequestMapping("/dataro/message")
public class MessageController {
	
	@Autowired
	MessageService msgService;
	
	@GetMapping("/sendMessage.do")
	@ResponseBody
	public int sendMessage(MessageVO vo) {
		return msgService.insert(vo);
	}
	
	@GetMapping("/getUnread.do")
	@ResponseBody
	public int getUnreadCount(MessageVO mvo, HttpSession sess) {
		
		MemberVO loginvo = (MemberVO) sess.getAttribute("loginInfo");
		if (loginvo != null) {
			mvo.setReceive_member_no(loginvo.getMember_no()); 
			return msgService.unreadMsgCount(mvo); // 내가 읽지 않은 쪽지 불러오기.
		}
		return 0;
	}
	
	@GetMapping("/getMsgTotalCnt.do")
	@ResponseBody
	public int getMsgTotalCnt(MessageVO mvo, HttpSession sess, @RequestParam int pre_cnt) {
		if(pre_cnt == -1) return -1;
		MemberVO loginvo = (MemberVO) sess.getAttribute("loginInfo");
		if (loginvo != null) {
			int msg_cnt = msgService.msgTotalCount(loginvo.getMember_no());
			
			if(pre_cnt == msg_cnt) {
				return 0;
			} else {
				sess.setAttribute("msg_cnt", msg_cnt);
				return msg_cnt;
			}
		}
		return 0;
	}
	
	// 메인화면에 종 아이콘 클릭시 안읽은 쪽지내용 읽음처리
	@PostMapping("/readProcess")
	@ResponseBody
	public int readProcess(MessageVO vo, HttpServletRequest req) {
		String[] message_noArr = req.getParameterValues("message_no");
		int count = 0;
		for (int i=0; i<message_noArr.length; i++) {
			int message_no = Integer.parseInt(message_noArr[i]);
			count += msgService.readMsg(message_no);
		}
		if (message_noArr.length == count) {
			return 1; 
		} else {
			return 0; 
		}
	}

	@RequestMapping("/deleteProcess")
	@ResponseBody
	public int deleteProcess(Model model, HttpServletRequest req, MessageVO vo, String type) {
		String[] message_noArr = req.getParameterValues("message_no");
		int count = 0;
		for(int i = 0; i < message_noArr.length; i++) {
			int message_no = Integer.parseInt(message_noArr[i]);
			vo.setMessage_no(message_no);
			if (type.equals("send")){
				count += msgService.delSendMsg(message_no);
			} else {
				count += msgService.delReceiveMsg(message_no);
			}
		}
		if (message_noArr.length == count) {
			return 1;
		} else {
			return 0;
		}
	};
}
