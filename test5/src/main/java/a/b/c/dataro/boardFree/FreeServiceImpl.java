package a.b.c.dataro.boardFree;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FreeServiceImpl implements FreeService {

	@Autowired
	FreeMapper fMapper;
	
	@Override
	public Map index(FreeVO vo) {
		// 총 게시물 수
		int totalCount = fMapper.count(vo); 
		//총 페이지 수
		int totalPage = totalCount/vo.getPageRow(); 
		if(totalCount % vo.getPageRow() > 0) totalPage++;

		//시작인덱스
		int startIdx = (vo.getPage() - 1) * vo.getPageRow();
		vo.setStartIdx(startIdx);
		List<FreeVO> list = fMapper.list(vo);
		
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
	public FreeVO view(int no) {
		fMapper.updateViewcount(no); //조회수 증가 후
		return fMapper.freeView(no);
	}

	@Override
	public FreeVO edit(int no) {
		return fMapper.freeView(no);
	}

	@Override
	public boolean update(FreeVO vo) {
		return fMapper.update(vo) > 0 ? true:false;
	}

	@Override
	public boolean delete(int no) {
		return fMapper.delete(no) > 0 ? true:false;
	}

	@Override
	public boolean insert(FreeVO vo) {
		boolean r = fMapper.insert(vo) > 0 ? true:false;

		return r;
	}

}
