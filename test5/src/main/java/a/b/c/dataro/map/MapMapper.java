package a.b.c.dataro.map;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import a.b.c.dataro.boardTravel.BoardVO;

@Mapper
public interface MapMapper {
	
   public int insert(MapVO vo);
   public List<MapVO> list(int board_no);
   public int updateBoardNo(BoardVO vo);
   public boolean delete(int board_no);
   public String place(BoardVO vo);
   
}
