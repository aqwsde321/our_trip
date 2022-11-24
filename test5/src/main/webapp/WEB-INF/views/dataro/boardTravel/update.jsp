<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/resources/dataro/css/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/css/style.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b93e1f37ba26daefa16850e15e3b7c31&libraries=services"></script>
</head>
<body>
<div id="wrap">
	<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp" %>
	<div class="content tv_write">
		<form action="edit.do" name="AH" id="edit" method="post" enctype="multipart/form-data">
			<!--제목-->
			<div class="title">
				<div class="title_top">
					<span class="user">
						<span class="user_img" style="background-image:url(/upload/${loginInfo.m_filename_server})"></span>
						<p>${loginInfo.nickname }</p>
					</span>
					<input type="text" name="title" id="title" class="title_text gmarket" value="${boardVO.title }">
					<input type="hidden" name="board_name" id="board_name" class="board_name" value="${boardVO.board_name }">
					<input type="hidden" id="board_no" name="board_no" value="${boardVO.board_no }">
					
					<div class="hash">
						<h3 class="gmarket">여행테마</h3>
						<c:forEach var="hash" items="${category.hash}">
							<label class="gmarket"><input type="checkbox" id="hash${hash.hashtag_no }" name="hashtag_no_arr" value="${hash.hashtag_no}">#${hash.hashtag_name}</label>
						</c:forEach>
					</div>
				</div>
				
				<div class="region">
					<input type="hidden" name="region_name" value="">
					<select name="region" id="region" class="gmarket">
						<option value="0" selected>지역</option>
						<c:forEach var="region" items="${category.region}">
							<option value="${region.region_name}" >${region.region_name }</option>
						</c:forEach>
					</select>
					<ul class="region_result"></ul>
					<div class="region_detail"></div>
				</div>
			</div>
			<!--지도,글쓰기-->
			<div class="map_wrap">
				
				<!-- 지도 나오는 곳 -->
				<div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
				
				<!-- 검색 목록 -->
				<div id="menu_wrap" class="bg_white" style="display:;">
					<div class="option"></div>
					<hr>
					<ul id="placesList"></ul>
					<div id="pagination"></div>
				</div>
			    
			</div>
			
			<!-- 지도 검색 엔터도 가능-->
			<div class="seracLocation">
				<div>
					<input type="text" value="종각역 맛집" id="keyword" onkeyup="enterkey()" size="15" class="gmarket" placeholder="지역을 검색하세요"> 
					<a onclick="jacascript:searchPlaces()"  class="find_btn"><i class="fa-solid fa-magnifying-glass"></i></a>
					<a href="javascript:displayCouses(courseArr);" class="marker gmarket">[코스 보기]</a>&nbsp;&nbsp;
				</div>
			</div>
			
			<!-- 코스 설명 들어갈 부분 -->      
			<div class="write_detail">
				<div class="scroll">
				</div>
			</div>
			<!--//지도,글쓰기-->
			<a href="javascript:goSave()" class="edit_btn">수정<i class="fa-solid fa-plus"></i></a>
		</form>
	</div>
</div>
    

<script type='text/javascript' src="/resources/dataro/js/map.js"></script>
<script type='text/javascript' src="/resources/dataro/js/mapMake.js"></script> 
<script type='text/javascript' src="/resources/dataro/js/write.js"></script>

<script>
$(function(){
	getCourse('update');
});

// 선택했던 지역이름 배열로 만들어 놓기
var region_nameArr = new Array();
<c:forEach var="region" items="${category.region}">
region_nameArr.push('${region.region_name}');
</c:forEach>

//원래작성된 글불러오는용
function updatebox(index,places,img1='no-image.jpg',img2='no-image.jpg'){
	count++;
	var html ='<div class="set">'
		html +='<div class="map_list">'
		html +=	'<span class="markerbg marker_' + (index+1) + '"></span>'+
				'<h5>' + places.place_name + '</h5>'+
				'<span class="info">'+
					'<span class="tel"><i class="fa\-solid fa\-phone"></i>' + places.phone  + '</span>' +
					'<span><i class="fa-solid fa-location-dot"></i>' +  places.address_name  + '</span>'
		html +='</span>'
		html +='</div>'
		html +='<textarea placeholder="내용 입력" name="contents">'+places.content+'</textarea>'
		html +='<div class="pic_wrap">'
		html +='	<div class="pic">'
		html +='		<input type="hidden" id=hiddenPic'+pic+' name="dbimgs" value="'+img1+'">'
		html +='		<input type="file" class="file_input'+ pic +'" name="filename" id=inputFile'+pic+' onchange="readInputFile(this)">'
		html +='		<img src="/upload/'+img1+'">'
		html +='		<span class="delete"><i class="fa-solid fa-circle-minus"></i></span>'
		html +='	</div>'
	pic++;
		html +='	<div class="pic">'
		html +='		<input type="hidden" id=hiddenPic'+pic+' name="dbimgs" value="'+img2+'">'
		html +='		<input type="file" class="file_input'+ pic +'" name="filename" id=inputFile'+pic+' onchange="readInputFile(this)">'
		html +='		<img src="/upload/'+img2+'">'
		html +='		<span class="delete"><i class="fa-solid fa-circle-minus"></i></span>'
		html +='	</div>'
	pic++;
		html +='</div>'
		html +='<span class="course_delete">코스삭제</span>'
		html +='</div>'
	$('.scroll').append(html);
	 
}

// 기존에 선택했던 지역 삭제가능하도록 따로 만듬.
$(document).on('click',".region_result li",function(){
	
	var id = $(this).attr('id')
	//console.log(id);
	delCondition(id)
}) 
</script>
</body>
</html>