package a.b.c;

import java.io.File;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class Test {
	
	@Autowired
	TestMapper testmapper;
	
	@GetMapping("/ro/test")
	public String test(Model model) {
		model.addAttribute("list", testmapper.fileUpdate());
		return "test";
	}
	@GetMapping("/test2")
	public void test2() {
		
	}
	
	// test2.jsp 파일 올리는거해뵈기
	@PostMapping("/insert.do")
	public String fileupload(@RequestParam MultipartFile[] filename, HttpServletRequest req, Model model) {
		for(MultipartFile files :filename) {
			if(!files.isEmpty()) {
				String org = files.getOriginalFilename();
				String ext=org.substring(org.lastIndexOf('.'));
				String sever = new Date().getTime()+ext;
				
				String path = req.getRealPath("/upload/");
				try {
					files.transferTo(new File(path+sever));
				}catch(Exception e) {
					System.out.println(e);
				}

				System.out.println("파일 이름:"+ org);				
				System.out.println("파일 이름:"+ sever);				
				testmapper.fileupload(sever);
				
				model.addAttribute("org", org);
				model.addAttribute("sever", sever);
			}
		}
		return "test2";
	}
	
	@PostMapping("/filedelete.do")
	public void filedelete(@RequestParam String use, HttpServletRequest req) {
			String path = req.getRealPath("/upload/");
			String ff =path+use;
			System.out.println(ff);
			File file = new File(ff);
			try {
				file.delete();
			}catch(Exception e) {
				System.out.println(e);
			}

	}
   
}
