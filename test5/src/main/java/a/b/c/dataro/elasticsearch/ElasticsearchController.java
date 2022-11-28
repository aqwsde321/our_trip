package a.b.c.dataro.elasticsearch;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/dataro/elastic")
public class ElasticsearchController {
	
	@Autowired
	ElasticMapper elaMapper;
	
	// put document
	@GetMapping("/put.do")
	@ResponseBody
	public List<Map<String, Object>> put() {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		int j =1 ;
		for (int i=5; i<8; i++) {
			Map<String, Object> res = elaMapper.tb(i);
			System.out.println(res);
			List<Map<String, Object>> conLst = elaMapper.tb_content(i); 
			List<Map<String, Object>> hashLst = elaMapper.tb_hash(i); 
			List<Map<String, Object>> mapLst = elaMapper.tb_map(i);

			Map<String, Object> doc = new HashMap<String, Object>(); 
			doc.put("board_no", res.get("board_no")); 
			doc.put("board_name", res.get("board_name"));
			doc.put("id", res.get("id")); doc.put("title", res.get("title"));
			doc.put("writedate", res.get("writedate").toString()); 
			doc.put("conLst", conLst); 
			doc.put("hashLst", hashLst);  
			doc.put("mapLst", mapLst);
			list.add(doc); 
			
			try { 
				ElasticSearch.putDocument("ourtrip", Integer.toString(j), doc); 
			} catch (Exception e) {
				e.printStackTrace(); 
			}
			j++;
		}
		for (int i=5; i<12; i++) {
			Map<String, Object> res1 = elaMapper.fb(i);
			Map<String, Object> doc1 = new HashMap<String, Object>();
			doc1.put("board_no", res1.get("board_no"));
			doc1.put("board_name", res1.get("board_name"));
			doc1.put("id", res1.get("id"));
			doc1.put("title", res1.get("title"));
			doc1.put("content", res1.get("content"));
			doc1.put("writedate", res1.get("writedate").toString());
			list.add(doc1);
			try {
				ElasticSearch.putDocument("ourtrip", Integer.toString(j) , doc1);
			} catch (Exception e) {
				e.printStackTrace();
			}
			j++;
		}
		for (int i=20; i<27; i++) {
			Map<String, Object> res2 = elaMapper.qb(i);
			Map<String, Object> doc2 = new HashMap<String, Object>();
			doc2.put("board_no", res2.get("board_no"));
			doc2.put("board_name", res2.get("board_name"));
			doc2.put("id", res2.get("id"));
			doc2.put("title", res2.get("title"));
			doc2.put("content", res2.get("content"));
			doc2.put("writedate", res2.get("writedate").toString());
			list.add(doc2);
			try {
				ElasticSearch.putDocument("ourtrip", Integer.toString(j) , doc2);
			} catch (Exception e) {
				e.printStackTrace();
			}
			j++;
		}
		return list;
	}
	
	// multi match
	@RequestMapping(value="/get.do", produces = "application/json; charset=UTF-8" )
	@ResponseBody
	public String get(@RequestParam String sword) {
		String json="";
		try {
			json = ElasticSearch.getMultiMatch(sword);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return json;
	}
	
	// address_name 검색
	@RequestMapping(value="/getreg.do" )
	@ResponseBody
	public List<Map<String,Object>> reg(@RequestParam String sword) {
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		try {
			list = ElasticSearch.getList("ourtrip", "mapLst.address_name", sword);  // 여러건 조회
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	@GetMapping("/elastic.do")
	public String es() {
		return "dataro/common/elasticsearch";
	}
	
}
