package a.b.c.omok;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/omok")
public class PlayController {

	@Autowired
	OmokMapper dao;

	static final int SIZE = 17;	// 오목판 사이즈 -> 배열에 사용.
	static int soloRoom = 1; 	// 게임하는 방번호(roomNum) 정해줌 -> 방번호(roomNum)는 밑에 HashMap의 키 값으로 사용.

	static int playerNum = 0;	// 2인용 인원 체크하고 흑백 정할때 사용.
	static int dbRoomNum = 0;	// db에서 사용하는 2인용 방 번호.
	
	Map<Integer,Integer> dolNum = new HashMap<Integer,Integer>(); // 2인용 방마다 돌넘버 따로 줄 예정
	
	// 이차원배열(boolean[SIZE][SIZE])을 값으로 가지는 Map. 이차원배열은 오목판(in 자바스크립트)이랑 같음. 색깔별로 만들고 오목성공여부 체크용으로 사용.
	Map<Integer, boolean[][]> blackMap = new HashMap<Integer, boolean[][]>();
	Map<Integer, boolean[][]> whiteMap = new HashMap<Integer, boolean[][]>();
	
	@RequestMapping("/wait")
	public String join() {
		return "omok/wait";
	}

	// wait.jsp 에서 1인용, 2인용 클릭시 여기로 옴. 여기서 어디로 보낼지 정함. 
	@PostMapping("/play")
	public String play(HttpServletRequest req, @RequestParam int playerNum) {
		PlayController.playerNum +=playerNum;	// 1인용 클릭-> playerNum=0 으로 static playerNum 변화없음.
									// 2인용 클릭-> playerNum=1 으로 static playerNum 증가(2인용 선택할때 마다 증가됨).
		
		// wait.jsp 에서 게임모드(1인용 or 2인용) 클릭하면 새로운 2차원 배열 생성해서 방마다 오목체크 따로 할 수 있게함. 
		boolean[][] black = new boolean[SIZE][SIZE];	// 배열 선언하면 값 전부 false로 시작임.
		boolean[][] white = new boolean[SIZE][SIZE];
		
		if (playerNum==1) {   
			int turnSelect = PlayController.playerNum %2;  // 1(백돌), 0(흑돌) , 1, 0, ..
			req.setAttribute("turnSelect", turnSelect); // static playerNum에 따라 누가 먼저할지 정해짐. "turnSelect"라는 이름으로 jsp에 받을 예정
			req.setAttribute("dbRoomNum", dbRoomNum); // 방번호 배정 0부터시작해서 감소.
			
			if(turnSelect==1) {		  // 0 인 흑돌 들어와야 오목체크배열 만들어짐
				dao.delete(dbRoomNum);  // 디비에서 기존 방번호에 남아 있던 정보 삭제
				int seqNum = 0;
				dolNum.put(dbRoomNum, seqNum); // db에 넣을 돌 넘버 0부터 시작되게
			}else {
				blackMap.put(dbRoomNum, black);
				whiteMap.put(dbRoomNum, white);
				dbRoomNum--; //다음 2인용방 들어오는 사람에게 1 작아진 번호 배정
			}
			
			return "omok/play2";	// play2.jsp 는 2인용 화면
		} 
		else {    // 1인용 클릭
			int roomNum = soloRoom++;	// 1인용 방에 들어올때마다 static soloRoom 증가하면서 roomNum에 번호 저장. 1부터 시작해서 증가.
			req.setAttribute("roomNum", roomNum);	// req에 방번호(roomNum) 저장
			
			// 위에 선언한 Map 에  방번호를 키값으로 오목체크 배열 저장.
			blackMap.put(roomNum, black);	
			whiteMap.put(roomNum, white);
			
			return "omok/play";	// play.jsp  는 1인용 화면
		} 
	}

	// 화면 클릭시 돌 놓으면 ajax로 좌표 받음 -> 오목성공여부 리턴해줌.  2인용(roomNum=0)이면 디비 저장.
	@PostMapping("/omokcheck")
	public @ResponseBody boolean omokcheck(@RequestParam int x, 
										@RequestParam int y,
										@RequestParam boolean turn,
			 							@RequestParam int roomNum) {
		
		boolean win;  // 오목 체크 후 return 보낼 값
		if (turn) {		
			blackMap.get(roomNum)[y][x] =true;  // 받은 좌표를 인덱스로 해당 배열 값을 true 바꿈.		
			win = Check.check(blackMap.get(roomNum), y, x);    // 오목성공여부 체크  Check.class 안 check() 메소드 실행
		} else {
			whiteMap.get(roomNum)[y][x] =true;
			win = Check.check(whiteMap.get(roomNum), y, x);
		}
		
		//2인용만 디비 저장
		if(roomNum <= 0) dbsave(roomNum, dolNum.get(roomNum), x, y, win);
		
		return win;
	}
	
	public void dbsave(int roomNum, int dolNum, int x, int y, boolean win) {
		OmokDTO dto = new OmokDTO();		
		dto.setDbRoomNum(roomNum);
		dto.setDolNum(dolNum);
		dto.setX(x);
		dto.setY(y);
		dto.setWin(win ? 1 : 0);		// boolean win 을 int 1 또는 0 으로 바꿔서 저장.
		
		int result = dao.insert(dto);
		if (result == 1) {
			this.dolNum.put(roomNum, ++dolNum);// db insert 성공하면  dolNum 증가
		}
	}
	
	@PostMapping("/end")
	public String end(@RequestParam int roomNum) {
		// roomNum 받아와서 해당 방 오목체크배열만 지움   
		if (blackMap.get(roomNum) != null) {
			whiteMap.remove(roomNum);
			blackMap.remove(roomNum);
			// 1인용 방이면 roomNum>0 임  바로 naga.jsp 로 보냄.
			if (roomNum > 0) return "omok/end";
			else {
				dao.delete(roomNum);
				// db에 특이한 좌표 저장하고 해당 값 받으면 상대방이 종료누른거라고 ajex 통해 받기.
				dbsave(roomNum,dolNum.get(roomNum), 0,0,true);
			}
		}else {  // 2인용방에 흰색 혼자 들어갔다가 나왔을 경우 
			dbsave(roomNum,dolNum.get(roomNum), 0,0,true);
		}
		return "omok/end";
	}

	// 2인용 자바스크립에서 ajax로 db에 저장된 오목 좌표 받아올때 호출하는 곳. 모든 오목 db정보 list로 보냄.
	@PostMapping("/map")
	public @ResponseBody List<OmokDTO> map(@RequestParam int roomNum) {
		return dao.selectList(roomNum);
	}
	
	// 2인용 자바스크립에서 ajax로 db에 저장된 오목 좌표 받아올때 호출하는 곳. 모든 오목 db정보 list로 보냄.
//	@PostMapping("/map2")
//	public @ResponseBody OmokDTO map2(@RequestParam int roomNum, @RequestParam int pre_len) {
//		if (pre_len == dao.count(roomNum)) {
//			return null;
//		} else {
//			return dao.select(roomNum);
//		}
//	}
}