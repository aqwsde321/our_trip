package a.b.c.dataro.elasticsearch;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpHost;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestClientBuilder;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.client.ml.PostDataRequest.JsonBuilder;
import org.elasticsearch.common.unit.Fuzziness;
import org.elasticsearch.common.xcontent.XContentType;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;

public class ElasticSearch {
	
	public static void putDocument (String index, String id, Map doc) throws Exception {
		
		HttpHost host = new HttpHost("localhost", 9200);
		RestClientBuilder restClientBuilder = RestClient.builder(host);
		RestHighLevelClient client = new RestHighLevelClient(restClientBuilder);
		
		JsonBuilder json = new JsonBuilder();
		json.addDoc(doc);
		IndexRequest req = new IndexRequest(index).id(id).source(doc, XContentType.JSON);
		client.index(req, RequestOptions.DEFAULT);
	}
	
	// 여러건 조회
	public static List<Map<String, Object>> getList(String index, String field, String sword) throws Exception {
		
		HttpHost host = new HttpHost("localhost", 9200);
		RestClientBuilder restClientBuilder = RestClient.builder(host);
		RestHighLevelClient client = new RestHighLevelClient(restClientBuilder);
		
		SearchRequest searchRequest = new SearchRequest(index);
		SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
		
		//sourceBuilder.query(QueryBuilders.matchQuery(field, sword));
		//sourceBuilder.query(QueryBuilders.matchQuery("place_nm", "송x파")); // 에러
		//sourceBuilder.query(QueryBuilders.fuzzyQuery("place_nm", "송x파").fuzziness(Fuzziness.ONE));
		//sourceBuilder.query(QueryBuilders.fuzzyQuery(field, sword).fuzziness(Fuzziness.TWO));
		sourceBuilder.query(QueryBuilders.matchQuery(field, sword));
		searchRequest.source(sourceBuilder);
		
		// 페이징처리 관련
		//sourceBuilder.size(10);
		//sourceBuilder.from(0);
		
		SearchResponse searchResponse = client.search(searchRequest, RequestOptions.DEFAULT);
		//System.out.println(searchResponse.getHits().getHits());
		
		List<Map<String,Object>> list = new ArrayList();
		for (SearchHit sh: searchResponse.getHits().getHits()) {
			list.add(sh.getSourceAsMap());
		}
		return list;
		}
		
	
	public static String getMultiMatch (String sword) throws Exception {
		URL url = new URL("http://localhost:9200/ourtrip/_search");
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-type", "application/json");
		conn.setDoOutput(true);
		
		String paramData = "{\"size\": 500,\"query\": {\"multi_match\": {\"query\": \""+ sword +"\",\"fields\": [\"id\",\"title\",\"content\",\"conLst.content\",\"hashLst.hashtag_name\",\"mapLst.place_name\",\"mapLst.address_name\"]}}}";
		
		try (OutputStream os = conn.getOutputStream()){
			byte request_data[] = paramData.getBytes("utf-8");
			os.write(request_data);
			os.close();
		} catch(Exception e) {
			e.printStackTrace();
		}	
		
		conn.connect();
		
		try{
			StringBuffer sb = new StringBuffer();
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			while(br.ready()) {
				sb.append(br.readLine());
			}
			return sb.toString();
		}catch(Exception e) {
			e.printStackTrace();
			return "error";
		}
	}

}
