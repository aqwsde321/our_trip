package a.b.c.omok;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OmokMapper {
	public List<OmokDTO> selectList(int roomNum);
	
	public int insert(OmokDTO dto);
	
	public int delete(int roomNum);
	
	public OmokDTO select(int roomNum);
	
	public int count(int roomNum);
}
