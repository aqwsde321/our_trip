package a.b.c;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TestMapper {
	int fileupload(String sfile);
	List<String> fileUpdate();
}
