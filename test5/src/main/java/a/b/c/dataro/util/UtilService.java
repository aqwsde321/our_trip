package a.b.c.dataro.util;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import a.b.c.dataro.boardTravel.BoardVO;

public interface UtilService {
	//해시태그 등록
	void categoryInsert(CategoryVO cvo);
	//해시,지역 수정
	void categoryDel(CategoryVO cvo);
	//글쓰기 사진등록
	boolean fileUpload(FileVO fvo,@RequestParam MultipartFile[] filename, HttpServletRequest req);
	boolean fileReUpload(FileVO fvo, @RequestParam String[] dbimg);
	//해시태그,지역정보 출력
	Map writeCategory();
	//지역 대분류 db에 넘겨 소분류가지고오기/map으로 해보고싶어서 해본거,list로해도됨
	Map regionDetail(String rs);
	//resion_no 카테고리 테이블에 등록
	void uploadFileDel(List<String> list, HttpServletRequest req);
	List<String> uploadFileDelList(BoardVO bvo, String[] dbimgs);
	void fileDelDB(BoardVO bvo);
	
}
