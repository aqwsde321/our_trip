var canvas;
var context;
var map;
			   //0번 배경, 1번 배경, 2번 검정돌, 3번 흰돌,  4번 돌 빨간테두리
var imageList = ["0.png","1.png","2.png", "3.png", "4.png"];
// 위의 5개의 사진 src를 갖고 있는 [ <img>, <img> ,<img>, <img>, <img>] 태그 집합을 만들 예정
var imageArray = new Array(imageList.length);    
var imageLoadIndex = 0;
var imgXsize = 30;
var imgYsize = 30;

var stoneColor = true;
var who;
var preX;
var preY;

window.onload = function(){
	mapInit();   // map 배열 초기화
	canvas = document.createElement( 'Canvas' )  // <Canvas> 태그만듬
	
	canvas.width=510;
	canvas.height=510;
	context= canvas.getContext('2d');   
	
	document.querySelector('#div').appendChild( canvas );
	
	imageLoad();   //사진 준비
	
	input();  // 돌 놓는 클릭 관련 함수
}

// 이미지 파일 로드. 아직 사진 보이게 만든건 아님 파일만 준비.
function imageLoad(){
	imageArray[imageLoadIndex] = new Image();  // <img> 태그만듬
	imageArray[imageLoadIndex].src = "/resources/omok/image/0/" + imageList[imageLoadIndex];  // <img src=""> 저장
	imageArray[imageLoadIndex].onload = function() {
		if(imageLoadIndex < imageList.length - 1) {
			imageLoadIndex++;
			imageLoad();
		}else{
			draw();     // 사진 4개 다 준비되면 화면에 그림.
		}
	}
}

// 보드 판 그리는거 
function draw(){
	for(var x=0; x<map[0].length; x++){
		for(var y=0; y<map.length; y++){
			// imageLoad()에서 draw() 했을 경우  map(배열)에 값은 0, 1 뿐임 
			//if(map[y][x] == 0) continue;  // 배열 값이 0인 경우 그리지 않고 넘어감
			// 배열 값 = map[y][x] =1 인 경우   imageArray[1] -> 1.png 사진을 그림.  
			context.drawImage(imageArray[map[y][x]], x*imgXsize, y*imgYsize);
													// 그리는 좌표
		}
	}
}
var clickCheck = true;
// 돌 놓는 클릭 관련 함수
function input(){
	canvas.onclick = function(event){
		if(!clickCheck) return;
		
		var x = parseInt(event.offsetX /imgXsize);   // 클릭 좌표를 map[][]에 인덱스에 맞춰서 계산
		var y = parseInt(event.offsetY /imgYsize);
		if(x < 0 | x > 16 | y < 0 | y > 16) return;	// 배열 인덱스 밖에 찍히면 클릭 이벤트 종료
		if(map[y][x] != 1) return;    // 배열 값이 1이 아니면 클릭이벤트 종료 ( 1이 아니면 돌이 올라가 있음)
		
		clickCheck = !clickCheck; // 리턴될만한거 다 한 후 클릭 이벤트 막아야함
		
		// 첫 돌에는  preX, preY 값 없어서 실행안됨.
		// 마지막에 둔 돌 빨간색으로 표시한거 지우기 위해. 그 위에 다시 오목판이랑 돌 그림 올리는 과정 
		context.drawImage(imageArray[1], preX*imgXsize, preY*imgYsize);
		context.drawImage(imageArray[stoneColor? 3:2], preX*imgXsize, preY*imgYsize);
		
		// stoneColor: boolean 으로 참 / 거짓으로 클릭 좌표에 해당하는 map 값을 바꿔줌.   
		if(stoneColor) {
			map[y][x] = 2;	// 배열 값을 2로 바꾸면 밑에 drawImage 에서 imageArray[2] -> 2.png 사진을 그림.
			who="black";	// who는 나중에 승리한 사람 누군지 알려주려고 저장.
		} 
		else {
			map[y][x] = 3;
			who="white";
		} 
		    
		// 클릭한 x ,y 좌표 값만 그림    imageArray[4] -> 4.png 는 돌 빨간테두리 그리는 거 (마지막에 둔 돌 표시).
		context.drawImage(imageArray[map[y][x]], x*imgXsize, y*imgYsize);
		context.drawImage(imageArray[4], x*imgXsize, y*imgYsize);
 
		// data -> java파일로 보내 오목 체크          
		$.ajax({
			url: '/omok/omokcheck',
			type: 'post',
			data: { "x": x,
				"y": y,
				"turn": stoneColor,
				"roomNum": roomNum
			},
			success: function (win) { //win은 boolean임
				if(win){
					setTimeout(function() {
						alert(`${who} 승리`);
						END.submit();
					},300);
				}else{
					stoneColor = !stoneColor;    // 돌 색 교체
					clickCheck = !clickCheck;
				}
			},
			error: function(e){
				console.log(e);
			}
		});
	
		preX = x;     // 다음 클릭에서 돌 빨간테두리 지우기 위해 좌표 저장
		preY = y;
	}
}

function mapInit(){
	map = [
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	];
}