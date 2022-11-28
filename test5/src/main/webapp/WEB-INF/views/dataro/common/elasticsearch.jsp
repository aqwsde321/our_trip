<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="/resources/dataro/css/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/css/style.css"/>
<link href="https://www.flaticon.com/authors/freepik" title="Freepik">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Lobster&display=swap" >
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" integrity="sha384-DyZ88mC6Up2uqS4h/KRgHuoeGwBcD4Ng9SiP4dIRy0EXTlnuz47vAwmeGwVChigm" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css" integrity="sha512-1sCRPdkRXhBV2PBLUdRb4tMg1w2YPf37qatUFeS7zlBy7jJI8Lf4VHwWfZZfpXtYSLy85pkm9GaYVYMfw5BC1A==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<!-- 이미지슬라이드 -->
<link rel="stylesheet" type="text/css" href="/resources/dataro/slick/slick.css"/>
<link rel="stylesheet" type="text/css" href="/resources/dataro/slick/slick-theme.css"/>

<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<title>OurTrip</title>
<style>
a:hover {color: #3c40c6;}
.trhov tbody tr:hover{background:#f6f6f6; color: #3c40c6;} /*마우스오버 배경칼라지정*/
.esBtn {border:1px solid #eee; border-radius:50px; background:#eee; padding:5px;}
.esBtn:hover {border:1px solid #ddd; background:#ddd; color: #3c40c6;}
.espad {padding:10px; margin:10px;}
</style>
</head>
<body>
<div id="wrap">
	<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp" %>
	
	<div class="content gmarket">
		<div class="sub size">
			<h1 class="sub sub_title espad">ElasticSearch 통합 검색</h1>

			<input type="text" id="sword" list="browsers" onkeyup="enterkey()" >
			<a href="javascript:search();" class="esBtn">검색</a>
			<div id="result" class="espad">
			
			</div>
		</div>
		<h1>ElasticSearch는 localhost에서만 사용가능해서 사진으로 대체함</h1>
		<div class="your-class" style="border: 1px solid black">
			<c:forEach var="i" begin="1" end="12">
				<div><img src="/resources/dataro/img/elasticsearch/${i}.png"  alt=""></div>
			</c:forEach>
		</div>
	</div>
</div>

<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<script type="text/javascript" src="/resources/dataro/slick/slick.min.js"></script>
<script>

$(document).ready(function() {
	$('.your-class').slick({
		autoplay : true,
		dots : true, /* 하단 점 버튼 */
		speed : 300 /* 이미지가 슬라이딩시 걸리는 시간 */,
		infinite : true,
		autoplaySpeed : 30000 /* 이미지가 다른 이미지로 넘어 갈때의 텀 */,
		arrows : true,
		slidesToShow : 1,
		slidesToScroll : 1,
		touchMove : true, /* 마우스 클릭으로 끌어서 슬라이딩 가능여부 */
		nextArrows : true, /* 넥스트버튼 */
		prevArrows : true,
		arrow : true,
		fade : false
	});
});

//^^ 엔터키가 눌렸을 때 검색
function enterkey() {

	if (window.event.keyCode == 13) {
		search();
	}
}

//키워드 검색을 요청하는 함수입니다
function search(){
	var keyword = document.getElementById('sword').value;
	$.ajax({
		url:"/dataro/elastic/get.do",
		data:{
			sword:keyword
		},
		success: function(res){
			html ="<table style='border:1px solid black; ' class='trhov espad'>";
			html +=	"<thead>";
			html +=	"<tr style='padding:10px;'>";
			html +=		"<th style='padding:10px;'>게시판</th>";
			html +=		"<th>글번호</th>";
			html +=		"<th>글제목</th>";
			html +=		"<th>작성자</th>";
			html +=	"</tr>";
			html +=	"</thead>";
			
			if(res.hits.hits.length==0){
				html +="	<tr style='padding:10px;'>";
				html +="		<td colspan='4' style='padding:10px;'>검색결과 없음</td>";
				html +="	</tr>";
			} else {
				res.hits.hits.forEach(function(data) {
				    console.log(data);
					var boardname="";
					if(data._source.board_name=="여행게시판") boardname = 'boardTravel';
					else if(data._source.board_name=="자유게시판") boardname = 'boardFree';
					else boardname = 'boardQna';
					html +=	"<tbody>";
					html +=	"<tr style='padding:10px;'>";
					html +=		"<td style='padding:10px;'>"+data._source.board_name+"</td>";
					html +=		"<td>"+data._source.board_no+"</td>";
					html +=		"<td><a href='/dataro/"+boardname+"/view.do?board_name="+data._source.board_name+"&board_no="+data._source.board_no+"'>"+data._source.title+"</a></td>";
					html +=		"<td>"+data._source.id+"</td>";
					html +=	"</tr>";
					html +=	"</tbody>";
				});
			}
			html +="</table>";
			$("#result").html(html);
		},
		error: function(res){
			console.log(res);
		}
	})
}


</script>
	
</body>
</html>