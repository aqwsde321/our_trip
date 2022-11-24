var canvas;
var context;
var map;

var imageList = ["0.png","1.png","2.png", "3.png", "4.png"];
var imageArray = new Array(imageList.length);
var imageLoadIndex = 0;
var imgXsize = 30;
var imgYsize = 30;
var who;

// 2인용 처음 들어온 사람 false->돌 못 둠. 2번째로 들어온 사람 true -> 돌 둘 수 있음.
turnSelect = turnSelect!=1 ? true:false;  // 뒤에서 바꿔줌 -> 교대로 돌 둘 수 있게

var stoneColor = turnSelect; //true면 흑돌 false면 백돌. 돌 색은 여기서 고정.
var x;	
var y;
var preX;
var preY;


window.onload = function(){

	mapInit();
	canvas = document.createElement( 'Canvas' )
	
	canvas.width=510;
	canvas.height=510;
	context = canvas.getContext('2d');
	
	document.querySelector('#div').appendChild( canvas );
	
	imageLoad();
	
	mapSet();   // 2인용에서만 사용. db 에서 돌 위치 가지고 와서 두 사람에게 다 뿌려줌.
	
	input();

}

function imageLoad(){
	imageArray[imageLoadIndex] = new Image();
	imageArray[imageLoadIndex].src = "/resources/omok/image/0/" + imageList[imageLoadIndex];
	imageArray[imageLoadIndex].onload = function() {
		if(imageLoadIndex < imageList.length - 1) {
			imageLoadIndex++;
			imageLoad();
		}else{
			draw();
		}
	}
}

function draw(){
	for(var x=0; x<map[0].length; x++){
		for(var y=0; y<map.length; y++){
			if(map[y][x] == 0) continue;
			context.drawImage(imageArray[map[y][x]], x*imgXsize, y*imgYsize);
		}
	}
}

function input(){
	canvas.onclick = function(event){
		if(!turnSelect) return;  // 2인용 교대로 클릭이벤트 적용하기 위해 필요. 흑돌인 사람(turnSelect=true)부터 둘 수 있음.
				
		x = parseInt(event.offsetX /imgXsize);
		y = parseInt(event.offsetY /imgYsize);
		if(x < 0 | x > 16 | y < 0 | y > 16) return;  // 오목판 밖 클릭이벤트 중지
		if(map[y][x] != 1) return;	// 돌 올라가 있으면 클릭이벤트 중지
		
		turnSelect = !turnSelect;	
		// 클릭 후 돌 놓는게 가능해지면(return 보낼거 다끝내고) turnSelect=false 로 바꿔서 클릭 이벤트 막음(if(!turnSelect) return;).
		// 돌 놓은 사람만  turnSelect가 true에서 false 로 바뀐거임. 상대방은 여전히 false. 둘다 클릭해도 변화없는 상태.
		 
		context.drawImage(imageArray[1], preX*imgXsize, preY*imgYsize);
		context.drawImage(imageArray[stoneColor? 3:2], preX*imgXsize, preY*imgYsize);
		        
		if(stoneColor) {
			map[y][x] = 2;
			who="black";	
		} 
		else {
			map[y][x] = 3;
			who="white";
		} 
            
		context.drawImage(imageArray[map[y][x]], x*imgXsize, y*imgYsize);

		$.ajax({
			url: '/omok/omokcheck',
			type: 'post',
			data: { 
				"x": x,
				"y": y,
				"turn": stoneColor,	
				"roomNum": dbRoomNum	
			},					
			success: function (win) {
				if(win){
					setTimeout(function() {
						alert(`${who} 승리`);
						END.submit();
					},500);
				}
			},
			error: function(e){
				console.log(e);
			}
		});
	}
}

var pre_len=0;
// db에 저장된 x, y 좌표와 오목성공여부 data를 가지고옴
function mapSet(){
	//console.log(dbRoomNum);
	$.ajax({
		url: 'map',
		type: 'post',
		data: {	
			"roomNum": dbRoomNum
		},        
		success: function (list) {		// list=[{x:1, y:4, win:0}, {x:11, y:5, win:0}, ...] 이런 값으로 넘어옴.
			//console.log(turnSelect);
			if(list.length >= 1){
				if(list[0].x==0 && list[0].y==0 & list[0].win==1) {
					setTimeout(function() {
						alert(`상대방이 게임을 종료하였습니다.`);
						END.submit();
					},500);
				}
				else if(list.length != pre_len){		// 둔 돌(db에 data)이 없다면 list에 아무것도 없음 -> list.length=0.
					pre_len = list.length;
					
					for (const [index, dto] of list.entries()) {  // foreach 에서 for of로 바꿈 비동기순차처리때문(정확한 내용은 모름).
						x = dto.x;
						y = dto.y;
					    
						// 내가 마지막에 돌을 뒀다면 if문 실행안됨. db에 저장된 좌표에 돌이 다 올라가 있음.
						if(map[y][x]==1) {	// 돌 없는 곳만 돌 놓음.
							map[y][x]=index%2==0 ? 2:3;		// index 0부터 시작 0:검, 1:흰, 2:검, ...
							context.drawImage(imageArray[map[y][x]], x*imgXsize, y*imgYsize);	// 돌 그림 추가
							context.drawImage(imageArray[4], x*imgXsize, y*imgYsize);	// 빨간 테두리 그림 추가
							
							preX = x;	// preX, preY는 빨간 테두리 지우기 위해 필요
							preY = y;
						
							if(dto.win == 1){		// win = 1 인 경우 오목성공.
								who=index%2==0 ? "black":"white"; // index 0부터 시작 0:검, 1:흰, 2:검, ...
								setTimeout(function() {
									alert(`${who} 승리`);
									END.submit();
								},500); 
							}
							else{
								turnSelect = !turnSelect; // 상대가 돌을 놓았다면 나한테 없던 돌이라 if문 실행으로 나의 turnSelect가 false->true 바뀜. 상대방은 input()에서 false로 바뀐상태.
							}
						}
						//if (index == pre_len-1){  // for 문 다 돌고 시작되게
						//	sleep(1000).then(() => mapSet());
						//}
					}
				}
				//else{  // 비동기 함수 처리 하는동안 계속 실행돼서 반복실행을 여러 곳으로 나눔
				//	sleep(1000).then(() => mapSet());
				//}
			}
			//else{
			//	sleep(1000).then(() => mapSet());
			//}
		},
		error: function(e){
			console.log(e);
		},
		complete : function() { // complete으로 재 호출하면 에러가 났다안났다하네..
			sleep(1000).then(() => mapSet());  
		}
	});
}

function sleep(ms) {
	return new Promise((r) => setTimeout(r, ms));
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