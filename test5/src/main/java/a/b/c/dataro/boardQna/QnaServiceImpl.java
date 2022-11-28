package a.b.c.dataro.boardQna;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class QnaServiceImpl implements QnaService {

	@Autowired
	QnaMapper qMapper;
	
	@Override
	public Map index(QnaVO vo) {
		// 총 게시물 수
		int totalCount = qMapper.count(vo); 
		//총 페이지 수
		int totalPage = totalCount/vo.getPageRow(); 
		if(totalCount % vo.getPageRow() > 0) totalPage++;

		//시작인덱스
		int startIdx = (vo.getPage() - 1) * vo.getPageRow();
		vo.setStartIdx(startIdx);
		List<QnaVO> list = qMapper.list(vo);
		
		//페이징처리 startPage, endPage
		int endPage = (int)(Math.ceil(vo.getPage()/10.0)*10);
		int startPage = endPage-9;
		if(endPage>totalPage) endPage=totalPage;
		boolean prev = startPage > 1 ? true:false;
		boolean next = endPage < totalPage ? true:false;
		
		Map map = new HashMap();
		map.put("totalCount", totalCount);
		map.put("totalPage", totalPage);
		map.put("startPage", startPage);
		map.put("endPage", endPage);
		map.put("prev", prev);
		map.put("next", next);
		map.put("list", list);
	
		return map;
	}

	@Override
	public QnaVO view(int no) {
		qMapper.updateViewcount(no); //조회수 증가 후
		return qMapper.qnaView(no);
	}

	@Override
	public QnaVO edit(int no) {
		return qMapper.qnaView(no);
	}

	@Override
	public boolean update(QnaVO vo) {
		return qMapper.update(vo) > 0 ? true:false;
	}

	@Override
	public boolean delete(int no) {
		if(qMapper.gnoCount(no) > 1) {
			return qMapper.qnaDelete(no) > 0 ? true:false;
		} else {
			return qMapper.delete(no) > 0 ? true:false;
		}
	}

	@Override
	public boolean insert(QnaVO vo) {
		boolean r = qMapper.insert(vo) > 0 ? true:false;
		if (r) {
			qMapper.gnoUpdate(vo.getBoard_no());
		}
		return r;
	}

	@Override
	public boolean reply(QnaVO vo) {
		qMapper.onoUpdate(vo); // 부모의 gno와 같고, 부모의 ono보다 큰 ono를 ono+1로 업뎃
		vo.setOno(vo.getOno()+1);
		vo.setNested(vo.getNested()+1);
		return qMapper.reply(vo) > 0 ? true : false;
	}

}

