package a.b.c.dataro.util;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import a.b.c.dataro.boardTravel.BoardVO;

@Service
public class UtilServicempl implements UtilService {
	
	@Autowired
	CategoryMapper cMapper;

	@Autowired
	FileMapper fMapper;
	
	// categoryInsert
	@Override
	public void categoryInsert(CategoryVO cvo) {
		if (cvo.getHashtag_no_arr() != null) {
			for(int hashtag:cvo.getHashtag_no_arr()) {
				cvo.setHashtag_no(hashtag);
				cMapper.hashInsert(cvo);
			}
		}
		
		if (cvo.getRegion_no_arr() != null) {
			for(int region:cvo.getRegion_no_arr()) {
				cvo.setRegion_no(region);
				cMapper.regionInsert(cvo);
			}
		}
	}
	
	//해쉬태그 수정
	@Override
	public void categoryDel(CategoryVO cvo) {
		cMapper.categoryDel(cvo);
	}

	//업로드한 파일 삭제
	@Override
	public void uploadFileDel(List<String> list, HttpServletRequest req) {
		String path = req.getRealPath("/upload/");
		
		for (String name : list) {
			String pathFile =path+name;
			File file = new File(pathFile);
			try {
				file.delete();
			}catch(Exception e) {
				System.out.println(e);
			}
		}	
	}
	
	// 업로드한 파일중 삭제할거 선택
	@Override
	public List<String> uploadFileDelList(BoardVO bvo, String[] dbimgs) {
		List<String> dbfile = fMapper.getServerFileName(bvo);
		if(dbimgs == null) return dbfile;
		
		List<String> dbimgsList = Arrays.asList(dbimgs);
		
		List<String> list = new ArrayList<String>();
		for(String pre: dbfile) {
			if(dbimgsList.indexOf(pre) == -1) {
				list.add(pre);
			}
		}
		return list;
	}
	
	//파일디비삭제
	@Override
	public void fileDelDB(BoardVO bvo) {
		fMapper.fileDelDB(bvo);
	}
	
	//파일 재업로드
	@Override
	public boolean fileReUpload(FileVO fvo, @RequestParam String[] dbimgs) {
		int a = 1;
		for(String dbimg :dbimgs) {
			a++;
			if(!dbimg.isEmpty() && !dbimg.equals("no-image.jpg")) {
				fvo.setCourse_no(a/2);
				fvo.setFilename_org(dbimg);
				fvo.setFilename_server(dbimg);
				fMapper.fileUpload(fvo);
			}
		}
		return true;
	}
	
	//파일 업로드
	@Override
	public boolean fileUpload(FileVO fvo, @RequestParam MultipartFile[] filename, HttpServletRequest req) {
		int a = 1;
		for(MultipartFile files :filename) {
			a++;
			if(!files.isEmpty()) {
				String org = files.getOriginalFilename();
				String ext=org.substring(org.lastIndexOf('.'));
				String server = new Date().getTime()+ext;
				
				String path = req.getRealPath("/upload/");
				try {
					files.transferTo(new File(path+server));
				}catch(Exception e) {
					
				}
				
				fvo.setCourse_no(a/2);
				fvo.setFilename_org(org);
				fvo.setFilename_server(server);
				
				fMapper.fileUpload(fvo);
			}
		}
		return true;
	}
	
	//해시태그,지역대분류 출력
	@Override
	public Map writeCategory() {
		Map category = new HashMap();
		category.put("hash", cMapper.hash());
		category.put("region", cMapper.regionSelect());
		return category;
	}
	
	//지역 소분류 리스트로 받아서 map에 담기
	@Override
	public Map regionDetail(String rs) {
		List<CategoryVO> regionDetailList =cMapper.regionDetail(rs);
		Map regionDetail = new HashMap();
		regionDetail.put("regionDetailList", regionDetailList);
		return regionDetail;
	}

}
