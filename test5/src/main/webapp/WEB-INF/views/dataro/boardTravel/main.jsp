<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OurTrip</title>
<link rel="stylesheet" href="/resources/dataro/css/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/css/style.css"/>
<link rel="stylesheet" href="/resources/dataro/css/main.css"/> 
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
<div id="wrap">

	<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp" %>

	<div class="content">	  
	<i class="fa-regular fa-bell-exclamation"></i>                  
		<div class="hash" style="display: inline-block; margin: 10px 10px;">
			<span class='hashtag' data-no=''>&nbsp;#전체</span>
			<c:forEach var="hash" items="${category.hash}">
				<span class='hashtag' data-no='${hash.hashtag_no }'>&nbsp;#${hash.hashtag_name}</span>
			</c:forEach>
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
     
	<div class="content main">
		<div class="container" id="area">
			<c:forEach var ="list" items="${list}" varStatus="status">
				<div class="cnt_set color1">
					<div class="color1">
						<br>
						<h5>${list.title}</h5>
						<br>
						<div><strong>글번호 : ${list.board_no} ㅣ 회원ID : ${list.id}</strong></div>
						<br>
						<span>
							<c:forEach var ="cate" items="${list.categoryList}">
								<c:if test="${!empty cate.region_name }">
									<label class="hash gmarket">#${cate.region_name }</label>
								</c:if>
								<c:if test="${!empty cate.hashtag_name }">
									<label class="hash gmarket">#${cate.hashtag_name }</label>
								</c:if>
							</c:forEach>
						</span>
					</div>
					<div class="img_area color1">
						<a href="view.do?board_no=${list.board_no}&board_name=${list.board_name}">
							<img src ="/upload/${list.filename_server }" height="100%" width="100%" id="idImg" >
						</a>
						<ul>
							<li>
								<span><b>${list.likecount}</b></span>
								<span>좋아요</span>
							</li>
							<li>
								<span><b>${list.replycount}</b></span>
								<span>댓글수</span>
							</li>
							<li>
								<span><b>${list.viewcount}</b></span>
								<span>조회수</span>
							</li>
						</ul>
					</div>
					<ul class="courselist color1" >
						<li class="maplist">
							<c:forEach var="mvo" items="${list.placeList}">
								<span>●&nbsp;</span><span>${mvo.place_name}</span><br>
							</c:forEach>
						</li><br>
					</ul>    
				</div>
			</c:forEach>
		</div>
	</div>
</div>


<script>
/* 해쉬태그 & 지역 검색 관련[시작] */
$('.hashtag').click(function(){
	$("#stag").val($(this).data('no'));
	$("#frm").submit();
})

//지도 소분류 ajax로 바로 가져오기
$("#region").change(function(){
	//console.log($(this).val())
	var region_name = $(this).val()
	$.ajax({
		url:"/dataro/boardTravel/region_detail",
		data:{
			rs:region_name
		},
		success:function(res){
			$(".region_detail").find("input").remove();
			$(".region_detail").find("label").remove();
			for(var i=0;i<res.regionDetailList.length;i++){
			    	var html = '<label for="region'+res.regionDetailList[i].region_no+'">'+res.regionDetailList[i].region_name
			    		html +='<input type="checkbox" name="region_no_arr" id="region'+res.regionDetailList[i].region_no+'" value="'+res.regionDetailList[i].region_no+'">'
			    		html +='</label>'
			    	$(".region_detail").append(html);
			}
		}
	})
});
//지도소분류 체크css
$(document).on("click",".region_detail label",function(){
	$("#sregion").val($(this).find("input").val());
	$("#frm").submit();
})
/* 해쉬태그 & 지역 검색 관련[끝] */


/* 무한스크롤[시작] */
function getPage(page){ 
	//console.log(page);
	var params =[];
	const searchParams = new URLSearchParams(location.search);
	for (const param of searchParams) {
	  params.push(param[1]);
	}
	
	$.ajax({
		url:"/dataro/boardTravel/main.do",
		type:'get',
		data:{
			page: page,
			stag: params[0],
			sword: params[1],
			sregion: params[2]
		}, 
		success : function(res){
			if(res.trim() == ''){
				listEND = false;
			}else{
				$("#area").append(res);
			}
		},
		error : function(e) {
			console.log("getPage 가져오기 에러"+e);
		}
	})
};

var pageNum = 2;
var listEND = true;
window.onscroll = function(e) {
	if(listEND && ((window.innerHeight + window.scrollY) >= document.body.offsetHeight)) { 
		//console.log("loading");
		getPage(pageNum++);
	}
}
/* 무한스크롤[끝] */
</script>
</body>
</html>