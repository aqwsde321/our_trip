var regionarr = new Array(); //ajax 비동기처리로 만들어서 변수값을 넣은상태에서 사용할수있게
var no=$('#board_no').val();  //view.jsp, update.jsp(hidden에 있음). write.jsp(없음 undefined)

var courseArr = []; // ^^ 코스 위치정보를 담을 배열
var markers = []; // 코스 위치 마커를 담을 배열입니다

// db에 있는 코스 정보(마커 위치+정보+내용+사진) 가져오기 [ update.jsp에서는 추가로 카테고리(해쉬태그+지역) 체크하기]
function getCourse(use) {
	$.ajax({
		url : "/dataro/boardTravel/getCourse.do",
		type : "post",
		data : {
			board_no : no,
			use : use
		},
		success : function(res) {
			//console.log(res.course);
			if(res.course.length != 0) {
				for(var i=0; i<res.course.length; i++){
					var fileLength = res.course[i].fileList.length;
					if(fileLength == 0){
						updatebox(i,res.course[i]);
					}
					else if(fileLength == 1){
						updatebox(i,res.course[i],res.course[i].fileList[0].filename_server);
					}
					else if(fileLength == 2){
						updatebox(i,res.course[i],res.course[i].fileList[0].filename_server,res.course[i].fileList[1].filename_server);
					}
					courseArr.push(res.course[i]);
				};
				displayCouses(res.course);
			}

			if(use=="update"){
				//document.querySelector("#title").value = res.view.title;
				// 선택한 해쉬태그 불러오기  
				for(var i=0;i<res.hrcategory.length;i++){
					var idx = res.hrcategory[i].hashtag_no-1;
					//console.log(idx)
					document.getElementsByName("hashtag_no_arr")[idx].checked=true;
					document.getElementsByName("hashtag_no_arr")[idx].parentElement.className='on';
				};
				
				// 선택한 지역 불러오기
				for(var i=0;i<res.hrcategory2.length;i++){
					var html ='<li id=region'+res.hrcategory2[i].region_no+'>'+res.hrcategory2[i].region_name;
						html +='<a onclick="delCondition(\''+res.hrcategory2[i].region_no+'\')"><i class="fa-solid fa-circle-xmark"></i>';
						html +='</a>';
						html +='</li>';
					$('.region_result').append(html);		
					regionarr.push(res.hrcategory2[i].region_no);
				}
				
				// 지역 소분류 html로 만들고 안보이게
				for (r of region_nameArr){
					regionDetailShow(r);
				}
			}
		},
		error : function(e) {
			console.log("all 가져오기 에러"+e);
		}
	});
}   


// 카카오지도~
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	mapOption = {
		center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
		level: 3 // 지도의 확대 레벨
	};  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
var infowindow = new kakao.maps.InfoWindow({zIndex:1});

// 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
function addMarker(position, idx, title) {

	var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
		imageSize = new kakao.maps.Size(36, 37), // 마커 이미지의 크기
		imgOptions = {
			spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
			spriteOrigin : new kakao.maps.Point(0, (idx * 46) + 10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
			offset : new kakao.maps.Point(13, 37)
		},
		// 마커 좌표에 일치시킬 이미지 내에서의 좌표
		markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize,
				imgOptions), marker = new kakao.maps.Marker({
			position : position, // 마커의 위치
			image : markerImage
		});

	marker.setMap(map); // 지도 위에 마커를 표출합니다
	markers.push(marker); //^^ 생성된 마커를 배열에 추가. db로 넣기위해.

	return marker;
}

// 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
// 인포윈도우에 장소명을 표시합니다
function displayInfowindow(marker, title) {
	var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';
	
	infowindow.setContent(content);
	infowindow.open(map, marker);
}



/* 마커 연결 직선 관련[시작] */ 
//^^ 직선거리표시하는데 필요한 변수들
var markerLine // 마우스로 클릭한 좌표로 그려질 선 객체입니다
var distanceOverlay; // 선의 거리정보를 표시할 커스텀오버레이 입니다
var dots = []; // 선이 그려지고 있을때 클릭할 때마다 클릭 지점과 거리를 표시하는 커스텀 오버레이 배열입니다.
	
//^^ 직선거리 및 시간정보 표시
function showInfoDistance(){
	
	// 마우스 클릭으로 그린 선의 좌표 배열을 얻어옵니다
    var path = markerLine.getPath();
	
	// 마지막 클릭 지점에 대한 거리 정보 커스텀 오버레이를 지웁니다
	if (dots[dots.length-1].distance) {
		dots[dots.length-1].distance.setMap(null);
		dots[dots.length-1].distance = null;    
	}

	var distance = Math.round(markerLine.getLength()), // 선의 총 거리를 계산합니다
		content = getTimeHTML(distance); // 커스텀오버레이에 추가될 내용입니다
        
	// 그려진 선의 거리정보를 지도에 표시합니다
	showDistance(content, path[path.length-1]);  
}

// 마우스 드래그로 그려지고 있는 선의 총거리 정보를 표시하거
// 마우스 오른쪽 클릭으로 선 그리가 종료됐을 때 선의 정보를 표시하는 커스텀 오버레이를 생성하고 지도에 표시하는 함수입니다
function showDistance(content, position) {
    
	if (distanceOverlay) { // 커스텀오버레이가 생성된 상태이면
		// 커스텀 오버레이의 위치와 표시할 내용을 설정합니다
		distanceOverlay.setPosition(position);
		distanceOverlay.setContent(content);
	} else { // 커스텀 오버레이가 생성되지 않은 상태이면
		// 커스텀 오버레이를 생성하고 지도에 표시합니다
		distanceOverlay = new kakao.maps.CustomOverlay({
			map: map, // 커스텀오버레이를 표시할 지도입니다
			content: content,  // 커스텀오버레이에 표시할 내용입니다
			position: position, // 커스텀오버레이를 표시할 위치입니다.
			xAnchor: 0,
			yAnchor: 0,
			zIndex: 3  
		});      
	}
}
 
// 마우스 우클릭 하여 선 그리기가 종료됐을 때 호출하여 
// 그려진 선의 총거리 정보와 거리에 대한 도보, 자전거 시간을 계산하여
// HTML Content를 만들어 리턴하는 함수입니다
function getTimeHTML(distance) {

	// 도보의 시속은 평균 4km/h 이고 도보의 분속은 67m/min입니다
	var walkkTime = distance / 67 | 0;
	var walkHour = '', walkMin = '';
	
	// 계산한 도보 시간이 60분 보다 크면 시간으로 표시합니다
	if (walkkTime > 60) {
		walkHour = '<span class="number">' + Math.floor(walkkTime / 60) + '</span>시간 '
	}
	walkMin = '<span class="number">' + walkkTime % 60 + '</span>분'
	
	// 자전거의 평균 시속은 16km/h 이고 이것을 기준으로 자전거의 분속은 267m/min입니다
	var bycicleTime = distance / 227 | 0;
	var bycicleHour = '', bycicleMin = '';
	
	// 계산한 자전거 시간이 60분 보다 크면 시간으로 표출합니다
	if (bycicleTime > 60) {
		bycicleHour = '<span class="number">' + Math.floor(bycicleTime / 60) + '</span>시간 '
	}
	bycicleMin = '<span class="number">' + bycicleTime % 60 + '</span>분'
	
	// 거리와 도보 시간, 자전거 시간을 가지고 HTML Content를 만들어 리턴합니다
	var content = '<ul class="dotOverlay distanceInfo">';
		content += '    <li>';
		content += '        <span class="label">총거리</span><span class="number">' + distance + '</span>m';
		content += '    </li>';
		content += '    <li>';
		content += '        <span class="label">도보</span>' + walkHour + walkMin;
		content += '    </li>';
		content += '    <li>';
		content += '        <span class="label">자전거</span>' + bycicleHour + bycicleMin;
		content += '    </li>';
		content += '</ul>';
		
	return content;
}

// 선이 그려지고 있는 상태일 때 지도를 클릭하면 호출하여 
// 클릭 지점에 대한 정보 (동그라미와 클릭 지점까지의 총거리)를 표출하는 함수입니다
function displayCircleDot(position, distance) {

	// 클릭 지점을 표시할 빨간 동그라미 커스텀오버레이를 생성합니다
	var circleOverlay = new kakao.maps.CustomOverlay({
		content: '<span class="dot"></span>',
		position: position,
		zIndex: 1
	});
	
	// 지도에 표시합니다
	circleOverlay.setMap(map);
	
	if (distance > 0) {
		// 클릭한 지점까지의 그려진 선의 총 거리를 표시할 커스텀 오버레이를 생성합니다
		var distanceOverlay = new kakao.maps.CustomOverlay({
			content: '<div class="dotOverlay">거리 <span class="number">' + distance + '</span>m</div>',
			position: position,
			yAnchor: 1,
			zIndex: 2
		});
		
		// 지도에 표시합니다
		distanceOverlay.setMap(map);
	}
	// 배열에 추가합니다
	dots.push({circle:circleOverlay, distance: distanceOverlay});
}

// 클릭으로 그려진 선을 지도에서 제거하는 함수입니다
function deleteMarkerLine() {
	if (markerLine) {
		markerLine.setMap(null);    
		markerLine = null;        
	}
}

// 그려지고 있는 선의 총거리 정보와 
// 선 그리가 종료됐을 때 선의 정보를 표시하는 커스텀 오버레이를 삭제하는 함수입니다
function deleteDistnce () {
	if (distanceOverlay) {
		distanceOverlay.setMap(null);
		distanceOverlay = null;
	}
}

// 클릭 지점에 대한 정보 (동그라미와 클릭 지점까지의 총거리)를 지도에서 모두 제거하는 함수입니다
function deleteCircleDot() {
	var i;
	for ( i = 0; i < dots.length; i++ ){
		if (dots[i].circle) { 
			dots[i].circle.setMap(null);
		}
		if (dots[i].distance) {
			dots[i].distance.setMap(null);
		}
	}
	dots = [];
}
/* 마커 연결 직선 관련[끝] */