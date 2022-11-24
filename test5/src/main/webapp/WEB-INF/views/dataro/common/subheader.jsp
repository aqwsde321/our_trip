<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="https://kit.fontawesome.com/f55e2ec119.js" crossorigin="anonymous"></script>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
/* 모달ㅋ */
.alarmmodal {
	z-index: 2;
	position: fixed;
	background-color: rgba(0, 0, 0, 0.4);
	top:0;
	left: 0;
	height: 100vh;
	width:100%;
	display: none;
}

.modal-alarmcontent{
	background-color: #fff;
	width: 800px;
	border-radius: 10px;
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%,-50%);
	padding: 30px;
	box-shadow: 0 0 15px rgba(0, 0, 0, 0.15);
	text-align: center;
}
.btn-close{
	position: absolute;
	top: 10px;
	right: 15px;
	cursor: pointer;
}
</style>
<header class="sub_header">

	<div class="content gmarket">
		<h1><a href="/dataro/boardTravel/main.do">DATARO</a></h1>
		<c:if test="${wordsearch == 1}">
			<form id="frm" action="main.do" > 
				<input type="hidden" name="stag" id="stag">
				<input type="text" name="sword" value="">
				<input type="hidden" name="sregion" id="sregion">
			</form>
		</c:if>
		<ul class="menu">
			<li>
				<c:choose>
					<c:when test="${empty loginInfo }">
						<a href="/dataro/member/login" id="toPic">
							<i class="fa-solid fa-circle-user"></i>
						</a> 
						<span class="btn_ex gmarket">로그인</span>
					</c:when>
					<c:otherwise>
						<a href="#">
							<img src ="/upload/${loginInfo.m_filename_server}" id="idIm" style="border-radius:50px; width: 35px; height: 35px;">
						</a>
							<span class="btn_ex gmarket">마이<br>페이지</span>
					</c:otherwise>
				</c:choose>
			</li>
			<li>
				<a href="#" id="alarmForUser">
					<i class="fa-solid fa-envelope"></i>
				</a>
					<span id="ChkNew" class="gmarket" style="font-size:3px; display:none;">new</span>
				<c:if test="${!empty loginInfo }">
				<span class="btn_ex gmarket">새로운<br>쪽지<br><span id="unreadCount"></span>개</span>
				</c:if>
			</li>
			<li>
				<a href="/dataro/boardFree/main.do">
					<i class="fa-solid fa-clipboard"></i>
				</a>  
				<span class="btn_ex gmarket">자유<br>게시판</span>
			</li>
			<li>
				<a href="/dataro/boardQna/main.do" id="wBtn">
					<i class="fa-solid fa-clipboard-question"></i>
				</a>
				<span class="btn_ex gmarket">QnA</span>
			</li>
			<li>
				<a href="/dataro/boardTravel/write.do" id="wBtn">
					<i class="fa-solid fa-marker"></i>
				</a>
				<span class="btn_ex gmarket">여행<br>글쓰기</span>
			</li>
		</ul>
	</div>
</header>

<div class="alarmmodal">
	<div class="modal-alarmcontent">
		<a class="btn-close" href="#none"><img src="/resources/dataro/img/close.png"></a>
		<div id="areaForUser"></div>
	</div>
</div>	

<script>
$(function(){
	unreadCount();
	<c:if test="${!empty loginInfo}">
		ChkNewMsg();
	</c:if>
});

function unreadCount(){
	$.ajax({
		url : '/dataro/message/getUnread.do',
		data : {},
		success : function(e) {  
			$("#unreadCount").html(e); 
			if (e>0) {
				$("#alarmForUser").html('<i class="fa-solid fa-envelope-open-text"></i>');
			}
		},
		error: function(e){
			console.log(e);
		}
	});
}

var pre_cnt= -1;
<c:if test="${!empty loginInfo}">
	pre_cnt= ${msg_cnt};
</c:if>
function ChkNewMsg(){
	$.ajax({
		url : '/dataro/message/getMsgTotalCnt.do',
		data : {
			pre_cnt : pre_cnt
		},
		success : function(e) { 
			if (e>0) {
				pre_cnt = e;
				$("#ChkNew").show();
				unreadCount();
			}
		},
		error: function(e){
			console.log(e);
		},
		complete : function() {
			setTimeout(ChkNewMsg,3000);
	    }
	});
	
}
// X 버튼 클릭시 닫힘
$('.btn-close').click(function(){
	$('.alarmmodal').fadeOut();
});	

// .modal밖에 클릭시 닫힘
$(".alarmmodal").click(function (e) {
	if (e.target.className == "alarmmodal") {
		$(".alarmmodal").hide();
	}
});

// 로그인 후 변경된 사진 클릭시 마이페이지로 가기
$('#idIm').click(function(){
	location.href="/dataro/member/myPage";
});

// 종 아이콘 클릭시 읽지 않은 쪽지 모달팝업
$('#alarmForUser').click(function(){
	if (${!empty loginInfo}) {
		$.ajax({
			url : '/dataro/member/alarm',
			type : 'post',
			data : {},
			success : function(e) {  
				$("#areaForUser").html(e); // return "board/alarm"; 으로 해놔서, 해당 jsp가 해당 공간에 띄어짐.
				$('.alarmmodal').fadeIn();
				$("#ChkNew").hide();
			},
			error: function(e){
				console.log(e);
			}
		});
	} else {
		alert("로그인 후 이용해주세요 :)");
	}
});

//상단 아이콘 호버시 말풍선 나오게
$('.menu li').hover(function(){
	$(this).find(".btn_ex").stop().fadeIn()
},function(){
	$(".btn_ex").stop().fadeOut();
})

// 미로그인시 아이콘 클릭시 뜨는 얼럿
function loginAlert(){
	alert("로그인 후 이용해주세요 :)");
}
</script>