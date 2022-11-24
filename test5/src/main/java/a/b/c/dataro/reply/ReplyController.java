package a.b.c.dataro.reply;

import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequestMapping("/dataro")
public class ReplyController {
	
	@Autowired
	ReplyService replyService;
	
	//댓글 목록
	@GetMapping("/reply/list.do")
	public String list(ReplyVO vo, Model model) { 
		model.addAttribute("reply", replyService.list(vo));
		model.addAttribute("page", vo.getPage());
		return "dataro/common/reply";
	}

	//답글 목록
	@GetMapping("/reply/replyList.do")
	@ResponseBody
	public List<ReplyVO> replyList(ReplyVO vo, Model model) { 
		List<ReplyVO> list = replyService.replyList(vo);
		for(int i=0; i<list.size(); i++) {
			list.get(i).setReply_w_str(new SimpleDateFormat("yy-MM-dd HH:mm:ss").format(list.get(i).getReply_writedate()));
		}
		return list;
	}
	
	//댓글 작성
	@GetMapping("/reply/insert.do")
	@ResponseBody
	public String insert(ReplyVO vo, Model model){
		if(replyService.insert(vo)) {
			return "success";
		} else {
			return "fail";
		}
	}
	
	//답글 작성
	@GetMapping("/reply/reply.do")
	@ResponseBody
	public String reply(ReplyVO vo, Model model){
		if(replyService.reply(vo)) {
			return "success";
		} else {
			return "fail";
		}
	}
	
	@PostMapping("/reply/delete.do")
	@ResponseBody
	public String delete(ReplyVO vo, Model model) {
		if(replyService.delete(vo.getReply_no())) {
			return "success";
		} else {
			return "fail";
		}
	}
	@PostMapping("/reply/update.do")
	@ResponseBody
	public String update(ReplyVO vo, Model model) {
		if(replyService.update(vo)) {
			return  "success";
		} else {
			return "fail";
		}
	}
}
