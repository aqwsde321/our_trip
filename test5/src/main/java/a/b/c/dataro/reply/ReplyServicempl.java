package a.b.c.dataro.reply;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReplyServicempl implements ReplyService {
	@Autowired
	ReplyMapper replyMapper;
	
	@Override
	public Map list(ReplyVO vo) {
		//총 댓글 수
		int totalCount = replyMapper.count(vo);
		
		//ono=0 댓글수
		int pagingCount = replyMapper.pagingCount(vo);
		
		//총 댓글 페이지 수
		int totalPage = pagingCount/vo.getPageRow(); 
		if(pagingCount % vo.getPageRow() > 0) totalPage++;

		//시작인덱스
		int startIdx = (vo.getPage() - 1) * vo.getPageRow();
		vo.setStartIdx(startIdx);
		List<ReplyVO> list = replyMapper.list(vo);
		
		//페이징처리	startPage ,endPage
		int endPage = (int)(Math.ceil(vo.getPage()/10.0)*10);
		int startPage = endPage-9;
		if(endPage>totalPage) endPage=totalPage;
		boolean prev = startPage > 1 ? true:false;
		boolean next = endPage < totalPage ? true:false;
		
		Map map = new HashMap();
		map.put("totalCount", totalCount);
		map.put("pagingCount", pagingCount);
		map.put("totalPage", totalPage);
		map.put("startPage", startPage);
		map.put("endPage", endPage);
		map.put("prev", prev);
		map.put("next", next);
		map.put("list", list);
		return map;
	}

	@Override
	public boolean update(ReplyVO vo) {
		return replyMapper.update(vo) > 0 ? true:false;
	}

	@Override
	public boolean delete(int no) {
		return replyMapper.delete(no) > 0 ? true:false;
	}

	@Override
	public boolean insert(ReplyVO vo) {
		boolean r = replyMapper.insert(vo) > 0 ? true:false;
		if (r) replyMapper.gnoUpdate(vo.getReply_no());
		return r;
	}

	@Override
	public boolean reply(ReplyVO vo) {
		replyMapper.onoUpdate(vo);
		vo.setOno(vo.getOno()+1);
		return replyMapper.reply(vo) > 0 ? true : false;
	}

	@Override
	public List<ReplyVO> replyList(ReplyVO vo) {
		return replyMapper.replyList(vo);
	}
}
