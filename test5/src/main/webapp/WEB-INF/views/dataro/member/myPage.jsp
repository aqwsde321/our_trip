<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OurTrip</title>
<link rel="stylesheet" href="/resources/dataro/css/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/css/style.css"/>
<link rel="stylesheet" href="/resources/dataro/css/login.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css" integrity="sha512-1sCRPdkRXhBV2PBLUdRb4tMg1w2YPf37qatUFeS7zlBy7jJI8Lf4VHwWfZZfpXtYSLy85pkm9GaYVYMfw5BC1A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
<div id="wrap" >
<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp" %>
	<div class="content login pa gmarket">
		<h1>MY PAGE
			<a href="/dataro/member/editMemberInfo">
				<i class="fa-solid fa-gear" style="font-size:30px;" id="setbtn"></i>
			</a>
		</h1>
		<img src ="/upload/${loginInfo.m_filename_server}" id="idImg" >
		<h1 id="nic">${loginInfo.nickname}</h1>
		<a href="javascript:logout();" id="lo">&nbsp;Logout</a>
		
		<input type="hidden" value="${loginInfo.member_no}" name="member_no" id="no"> 
		<div id = "bts">
			<img src="/resources/dataro/img/myArticle.png" id="1" class="bt6" title="내가 쓴 글">
			<img src="/resources/dataro/img/myReply.png" id="2" class="bt6" title="내가 쓴 댓글">
			<img src="/resources/dataro/img/heart.png" id="3" class="bt6" title="좋아요 누른 게시물">
			<img src="/resources/dataro/img/message2.png" id="4" class="bt6" title="받은 쪽지함">
			<img src="/resources/dataro/img/message3.png" id="5" class="bt6" title="보낸 쪽지함">
			<img src="/resources/dataro/img/room.png" id="6" class="bt6" title="내가 참여한 채팅방">
		</div>
		<div id="area" style="padding-bottom: 100px;"></div>
	</div>
</div>
<script>
$(function(){
	$('#4').click();
})

function logout(){
	if(confirm('로그아웃 하시겠습니까?')) {
		location.href = "/dataro/member/logout";
	} else {
		location.reload();
	}
}

var listIdx;
$('.bt6').click(function(e){
	listIdx = this.id
	
	$.ajax({
		url : '/dataro/member/myList',
		type : 'get',
		data:{
			listIdx: listIdx
		},
		success : function(e) {
			$("#area").html(e);
		},
		error : function(e){
			console.log(e);
		}
	}); 
});


function getPage(page){ 
	//console.log(page);
	//console.log(listIdx);
	
	$.ajax({
		url: '/dataro/member/myList',
		type:'get',
		data:{
			listIdx: listIdx,
			page: page,
			stype: $('#stype').val(),
			sword : $('#sword').val()
		},
		success : function(res){
			$("#area").html(res);
		},
		error : function(e){
			console.log(e);
		}
	})
};

function myList(){
	//console.log(listIdx);
	$.ajax({
		url : '/dataro/member/myList',
		type : 'get',
		data : {
			listIdx: listIdx,
			stype: $('#stype').val(),
			sword : $('#sword').val()
		},
		success : function(e) {
			$("#area").html(e);
		},
		error : function(e){
			console.log(e);
		}
	});
	return false;
}
</script>
</body>
</html>