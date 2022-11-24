package a.b.c.dataro.util;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import a.b.c.dataro.boardTravel.BoardVO;

@Mapper
public interface FileMapper {
	//여행코스글쓰기 사진등록
	int fileUpload(FileVO fvo);
	//여행코스글쓰기 수정화면 사진출력
	List<FileVO> fileUpdate(BoardVO bvo);
	List<String> getServerFileName(BoardVO bvo);
	
	int fileDelDB(BoardVO bvo);
}
