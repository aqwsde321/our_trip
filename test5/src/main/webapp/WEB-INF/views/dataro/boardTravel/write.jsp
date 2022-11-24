<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>write</title>
<link rel="stylesheet" href="/resources/dataro/css/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/css/style.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b93e1f37ba26daefa16850e15e3b7c31&libraries=services"></script>
</head>
<body>
<div id="wrap">
<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp" %>
	<div class="content tv_write">
		<form action="insert.do" name="AH" method="post" enctype="multipart/form-data">
			<input type="hidden" name="id" value=${loginInfo.id }>
			<input type="hidden" name="member_no" value=${loginInfo.member_no }>
			
			<!--제목-->
			<div class="title">
				<div class="title_top">
					<div class="title_write">
						<span class="user">
							<span class="user_img" style="background-image:url(/upload/${loginInfo.m_filename_server})"></span>
							<p>${loginInfo.nickname }</p>
						</span>
						
						<input type="text" name="title" id="title" class="title_text gmarket" value="코스 제목"  maxlength='12'>
						<input type="hidden" name="board_name" id="title" class="title_text" value="여행게시판">
					</div>
					
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
					<div id="pagination"></div>
					<div class="option"></div>
					<hr>
					<ul id="placesList"></ul>
				</div>
			</div>
		
			<!-- 지도 검색 엔터도 가능-->
			<div class="seracLocation">
				<div>
					<input type="text" value="종각역 맛집" id="keyword" onkeyup="enterkey()" size="15" class="gmarket" placeholder="지역을 검색하세요"> 
					<a onclick="jacascript:searchPlaces()" class="find_btn"><i class="fa-solid fa-magnifying-glass"></i></a>
					<a href="javascript:displayCouses(courseArr);" class="marker gmarket">[코스 보기]</a>&nbsp;&nbsp;
				</div>
			</div>
			
			<!-- 코스 설명 들어갈 부분 -->      
			<div class="write_detail">
				<div class="scroll"></div>
			</div>
			<!--//지도,글쓰기-->
			<a href="javascript:goSave()" class="save">등록<i class="fa-solid fa-plus"></i></a>
		</form>
	</div>
</div>

<script type='text/javascript' src="/resources/dataro/js/map.js"></script>
<script type='text/javascript' src="/resources/dataro/js/mapMake.js"></script> 
<script type='text/javascript' src="/resources/dataro/js/write.js"></script> 

<script>
$(function(){
	searchPlaces(); // 키워드로 장소를 검색

	<c:forEach var="region" items="${category.region}">
		regionDetailShow('${region.region_name}');
	</c:forEach>
});


</script>
</body>
</html>