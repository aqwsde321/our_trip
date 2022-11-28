package a.b.c.dataro.elasticsearch;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ElasticMapper { 
	
	public Map<String, Object> tb(int no);
	
	public List<Map<String, Object>> tb_content(int no);
	
	public List<Map<String, Object>> tb_hash(int no);
	
	public List<Map<String, Object>> tb_map(int no);
	
	public Map<String, Object> fb(int no);
	
	public Map<String, Object> qb(int no);
	
}
