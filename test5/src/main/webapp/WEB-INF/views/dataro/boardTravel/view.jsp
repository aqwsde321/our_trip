<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OurTrip</title>
<link href="/resources/dataro/css/reset.css" rel="stylesheet">
<link href="/resources/dataro/css/style.css" rel="stylesheet">
<link href="/resources/dataro/css/view.css" rel="stylesheet">
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b93e1f37ba26daefa16850e15e3b7c31"></script>
</head>
<body>
<div id="wrap">
	<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp"%>
	<div class="content view">
		<div>
			<span class="user">
				<h4 style="padding-top: 20px;">
					<c:if test="${!empty loginInfo.member_no }">
						<a class="btn-sendclick" href="javascript:message(${data.board.member_no }, '${data.board.id }')">
							<span class="user_img"><img src="/upload/${data.member.m_filename_server}"></span>
							<span>${data.board.id }</span>	
						</a>
					</c:if>
					<c:if test="${empty loginInfo.member_no }">
						<a class="btn-sendclick" href="javascript:Gologin();">
							<span class="user_img"><img src="/upload/${data.member.m_filename_server}"></span>
							<span>${data.board.id }</span>
						</a>
					</c:if>
				</h4>
			</span>
			<span class="title"><h1>${data.board.title}</h1></span>
			<span id="count">
				<span><img src="/resources/dataro/img/viewCount.png"></span>
				<span>${data.board.viewcount }</span>
				<c:if test="${!empty loginInfo.member_no }">
					<a href="javascript:clickBoardLike();" id="likeCount"></a>
					<a href="javascript:clickDislike();" id="dislikeCount"></a>
				</c:if>
				<c:if test="${empty loginInfo.member_no }">
					<a href="javascript:Gologin();" id="likeCount"></a>
					<a href="javascript:Gologin();" id="dislikeCount"></a>
				</c:if>
			</span>
		</div>

		<hr style="border: solid 1px black;">

		<div class="category">
			<c:forEach items="${data.categoryList }" var="cate">
				<c:if test="${!empty cate.region_name }">
					<label class="hash gmarket">#${cate.region_name }</label>
				</c:if>
				<c:if test="${!empty cate.hashtag_name }">
					<label class="hash gmarket">#${cate.hashtag_name }</label>
				</c:if>
			</c:forEach>
		</div>
		
		<div id="mapRoom">
			<!-- 지도나오는곳 -->
			<div id="map" style="width: 660px; height: 500px; float: left;"></div>
			
			<!-- 방 목록 나오는곳 -->
			<div id="section">
				<c:if test="${!empty loginInfo.member_no }">
					<a href="#">
						<div class="mkroom btn-makeclick gmarket" id ="makeclick" style="font-weight: bold;">방 만들기</div>
					</a>
				</c:if>
				<c:if test="${empty loginInfo.member_no }">
					<div class="mkroom btn-makeclick gmarket" style="font-weight: bold;">
						<a href="javascript:Gologin()">방 만들기</a>
					</div>
				</c:if>
				<c:if test="${empty data.roomList }">
					<br>등록된 방이 없습니다.
					<br>방을 생성하여 새로운 여행 친구들을 만나보세요:D
           		</c:if>
				<c:if test="${!empty data.roomList }">
					<div class="tt">
						<table>
							<colgroup>
								<col width="80px" />
								<col width="*" />
								<col width="80px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
							</colgroup>
							<tr>
								<th>방번호</th>
								<th>방제목</th>
								<th>방장</th>
								<th>시작일</th>
								<th>종료일</th>
								<th>참여인원</th>
							</tr>
							<c:forEach items="${data.roomList }" var="room" varStatus="status">
								<tr>
									<td>${status.index+1}</td>
									<td>${room.room_title}
										<c:if test="${!empty room.room_pwd }">
											<img src="/resources/dataro/img/padlock.png">
										</c:if>
									</td>
									<td>${room.roommaker_id}</td>
									<td>${room.room_startdate}</td>
									<td>${room.room_enddate}</td>
									<td>${room.room_participant_count }명
										<input type="hidden" value="room.room_no" class="no">
										<input type="button" value="${room.room_participant_no > 0 ? '참여중' : '참여하기'  }" onClick='joinRoom("${room.room_pwd }", ${room.room_no }, ${status.index+1});'>
									</td>
								</tr>
							</c:forEach>
						</table>
					</div>
				</c:if>
			</div>
		</div>

		<!-- 코스 설명 들어갈 부분 -->
		<div class="course">
			<div class="write_detail">
				<div class="scroll"></div>
			</div>
		</div>

		<div id="footer" class="reply">
			<c:if test="${empty loginInfo.member_no}">
				<input type="text" placeholder="댓글은 로그인 후 작성 가능합니다." style="width: 80%" readonly>
			</c:if>
			<c:if test="${!empty loginInfo.member_no}">
				<input type="text" name="content" id="content" placeholder="댓글을 작성해주세요." style="width: 80%" onkeyup="enterkey(-1)">
				<a href="javascript:goSave();">
					<img src="/resources/dataro/img/replyWrite.png" title="댓글 작성">
				</a>
			</c:if>
			<!-- 댓글 나오는 부분 -->
			<div id="replyArea"></div>
		</div>

		<c:if test="${loginInfo.member_no == data.board.member_no }">
			<div class="btnSet">
				<form name="editFrm" method="post" action="/dataro/boardTravel/updateView.do" style="display:inline;">
					<input type="hidden" name="board_no" value="${boardVO.board_no }">
					<input type="hidden" name="board_name" value="${boardVO.board_name }">
					<input type="hidden" name="title" value="${data.board.title}">
					<a href="javascript:viewEdit()" class="btn">수정</a>
				</form>
				<form name="delFrm" method="post" action="/dataro/boardTravel/viewDelete.do" style="display:inline;">
					<input type="hidden" name="board_no" value="${boardVO.board_no }">
					<input type="hidden" name="board_name" value="${boardVO.board_name }">
					<a href="javascript:viewDel()" class="btn">삭제</a>
				</form>
			</div>
		</c:if>
	</div>
</div>

<!-- 방비밀번호 모달 -->
<div class="roompwdmodal">
	<div class="modal-roompwdcontent">
		<a class="btn-roompwdclose" href="javascript:">
			<img src="/resources/dataro/img/close.png">
		</a>
		<h3>Enter Password</h3>
		<div style="padding-top:5px;">
			<input type="text" id="text_pwd" name="room_pwd">
		</div>
		<div style="padding-top:5px;">
			<a class="btn-send" href="javascript:roomPwdCheck();">참여하기</a>
		</div>
	</div>
</div>


<!-- 방만들기 모달 -->
<div class="roommodal">
	<div class="modal-roomcontent">
		<a class="btn-roomclose" href="javascript:">
			<img src="/resources/dataro/img/close.png">
		</a>
		
		<h3>Make Room</h3>
		<input type="hidden" id="board_name" name="board_name" value="${data.board.board_name }">
		<input type="hidden" id="board_no" name="board_no" value="${data.board.board_no}">
		<input type="hidden" id="roommaker_id" name="roommaker_id" value="${loginInfo.id }">
		<input type="hidden" id="room_participant_no" name="room_participant_no" value="${loginInfo.member_no }">
		*방 제목
		<input type="text" id="room_title" name="room_title" style="width: 100%">
		<br> *방 내용
		<textarea id="room_content" name="room_content" style="width: 100%"></textarea>
		<br><b>[여행 시작날짜와 종료날짜를 선택해주세요]</b>
		<br> *시작날짜 : 
		<input type="date" id="room_startdate" name="room_startdate">
		<br> *종료날짜 :
		<input type="date" id="room_enddate" name="room_enddate">
		<br> 비밀번호 : 
		<input type="password" id="room_pwd" name="room_pwd">
		<div style="padding-top:5px;">
			<a class="btn-make" href="javascript:makeRoom();">방만들기</a>
		</div>
	</div>
</div>

<!-- 방으로 보내기 post -->
<form name="goroom" action="/dataro/room/room.do" method="post">
	<input type="hidden" id="go_room" name="room_no" value="">
</form>


<!-- 이미지 팝업 모달 -->
<div class="imgmodal">
	<button>&times;</button>
	<div class="modalBox">
		<img src="" alt="">
	</div>
</div>

<%@ include file="/WEB-INF/views/dataro/common/modal.jsp" %>

<script type='text/javascript' src="/resources/dataro/js/map.js"></script>
<script type='text/javascript' src="/resources/dataro/js/mapView.js"></script>

<script>
$(function () {
	//댓글 1페이지 불러오기
	getReply(1);
	clickBoardLike();
	clickDislike();

	getCourse('view');
});


/* 댓글관련 [시작]*/
function getReply(page) {

	$.ajax({
		url: "/dataro/reply/list.do",
		data: {
			'board_no': ${ data.board.board_no },
			'board_name' : '${data.board.board_name}',
			'page' : page,
			member_no : login_member_no
		},
		success: function(res) {
	
			$("#replyArea").html(res);
		},
		error: function(e) {
			console.log(e);
		}
	});
};

//^^ 엔터키가 눌렸을 때 검색
function enterkey(no) {
	if (window.event.keyCode == 13) {
		if (no == -1) {
			goSave();
		} else {
			goSave2(no);
		}
	}
}

function goSave() {
	if (confirm('댓글을 작성하시겠습니까?')) {
		var board_name = $("#board_name").val();
		var board_no = $("#board_no").val();
		$.ajax({
			url: "/dataro/reply/insert.do",
			data: {
				board_no: board_no,
				board_name: board_name,
				content: $("#content").val(),
				member_no: login_member_no,
				member_id: '${loginInfo.id}'
			},
			success: function (res) {
				if (res == "success") {
					alert('댓글이 정상적으로 등록되었습니다.');
				} else {
					alert('댓글 등록 실패');
				}
				getReply(1); //댓글 저장후 1페이지 다시 불러옴
				$("#content").val('');

			},
			error: function (e) {
				console.log(e);
				console.log("Gosave error");
			}

		});
	}
}

function replyDel(no) {
	if (confirm("댓글을 삭제하시겠습니까?")) {
		$.ajax({
			url: '/dataro/reply/delete.do',
			type:'post',
			data:{
				reply_no : no
			},
			success: function (res) {
				alert('댓글이 정상적으로 삭제되었습니다.');
				getReply(1);
			}

		})
	}
}
/* 댓글관련 [끝]*/


// .imgmodal안에 button을 클릭하면 .modal닫기
$(".imgmodal button").click(function(){
	$(".imgmodal").hide();
});

// .imgmodal밖에 클릭시 닫힘
$(".imgmodal").click(function (e) {
    if (e.target.className != "imgmodal") {
      return false;
    } else {
      $(".imgmodal").hide();
    }
 });

function popImg(img){
	$(".imgmodal").show();
	// 해당 이미지 가겨오기
	//console.log(img);
	//console.log(img.src);
	var imgSrc = img.src;
	$(".modalBox img").attr("src", imgSrc);
}

//원래작성된 글불러오는용
function updatebox(index, places, img1='no-image.jpg', img2='no-image.jpg') {
	count++;
	var html = '<div class="set">'
	html += '<div class="map_list">'
	html += '<span class="markerbg marker_' + (index + 1) + '"></span>' +
		'<h5>' + places.place_name + '</h5>' +
		'<span class="info">' +
		'<span class="tel"><i class="fa\-solid fa\-phone"></i>' + places.phone + '</span>' +
		'<span><i class="fa-solid fa-location-dot"></i>' + places.address_name + '</span>'
	html += '</span>';
	html += "</div>"
	html += '    <textarea placeholder="내용 입력" name="contents" readonly>' + places.content + '</textarea>'
	html += '    <div class="pic_wrap">'
	html += '        <div class="pic">'
	html += '        <img src="/upload/' + img1 + '" onClick="popImg(this);">'
	html += '        </div>'
	html += '        <div class="pic">'
	html += '        <img src="/upload/' + img2 + '" onClick="popImg(this);">'
	html += '        </div>'
	html += '    </div>'
	html += '</div>'
	$('.scroll').append(html);
}

$('#makeclick').click(function () {
	$('.roommodal').fadeIn();
})

$('.btn-roomclose').click(function () {
	$('.roommodal').fadeOut();
	$("#room_title").val('');
	$("#room_content").val('');
	$("#room_startdate").val('');
	$("#room_enddate").val('');
	$("#room_pwd").val('');
})
$('.btn-roompwdclose').click(function () {
	$('.roompwdmodal').fadeOut();
	$("#room_pwd").val('');
})

var login_member_no;
<c:if test="${empty loginInfo.member_no }">
    login_member_no = -1
</c:if>
<c:if test="${!empty loginInfo.member_no }">
    login_member_no = ${loginInfo.member_no}
</c:if>

var likeCheck = -1;
var dislikeCheck = -1;

function Gologin(){
	alert('로그인 후 이용해주세요:D');
	//location.href="/dataro/member/login";
}
function joinRoom(pwd, no, num) {
	if (confirm(num+'번 방에 참여하시겠습니까?')) {
		$('#go_room').val(no);
		if (pwd) {
			$('.roompwdmodal').fadeIn();
		} else {
			goroom.submit();
		}
	}
}
function roomPwdCheck(){
	$.ajax({
		url: "/dataro/room/pwdCheck.do",
		type: 'post',
		data: {
			board_no: ${ data.board.board_no },
			board_name : '${data.board.board_name}',
			room_no : $('#go_room').val(),
			room_pwd: $('#text_pwd').val()
	    },
		success: function(res) {
			if(res) goroom.submit();
			else alert('비밀번호가 틀렸습니다')
		},
		error: function(e) {
			console.log("방 비번 체크 에러");
			console.log(e);
		}
    });
}

function makeRoom() {
	
	if (confirm("방을 생성하시겠습니까?")) {
		$.ajax({
			url: '/dataro/room/makeRoom.do',
			type: 'post',
			data: {
				board_name: $("#board_name").val(),
				board_no: $("#board_no").val(),
				roommaker_id: $("#roommaker_id").val(),
				room_title: $("#room_title").val(),
				room_content: $("#room_content").val(),
				room_startdate: $("#room_startdate").val(),
				room_enddate: $("#room_enddate").val(),
				room_pwd: $("#room_pwd").val(),
				room_participant_no: $("#room_participant_no").val()

			},
			success: function (res) {
				if (res == 1) alert('새로운 방이 생성되었습니다.');
				else alert('로그인 후 이용하세요');

				$(".roommodal").fadeOut();
				$("#room_title").val('');
				$("#room_content").val('');
				$("#room_startdate").val('');
				$("#room_enddate").val('');
				$("#room_pwd").val('');
				window.location.reload();
			}
		})
	}
}


function getReply(page) {

	$.ajax({
		url: "/dataro/reply/list.do",
		data: {
			'board_no': ${ data.board.board_no },
			'board_name' : '${data.board.board_name}',
			'page' : page,
			member_no : login_member_no
		},
		success: function(res) {
	
			$("#replyArea").html(res);
		},
		error: function(e) {
			console.log(e);
		}
	});
};

//^^ 엔터키가 눌렸을 때 검색
function enterkey(no) {
	if (window.event.keyCode == 13) {
		if (no == -1) {
			goSave();
		} else {
			goSave2(no);
		}
	}
}

function goSave() {
	if (confirm('댓글을 작성하시겠습니까?')) {
		var board_name = $("#board_name").val();
		var board_no = $("#board_no").val();
		$.ajax({
			url: "/dataro/reply/insert.do",
			data: {
				board_no: board_no,
				board_name: board_name,
				content: $("#content").val(),
				member_no: login_member_no,
				member_id: '${loginInfo.id}'
			},
			success: function (res) {
				if (res == "success") {
					//alert('댓글이 정상적으로 등록되었습니다.');
				} else {
					alert('댓글 등록 실패');
				}
				getReply(1); //댓글 저장후 1페이지 다시 불러옴
				$("#content").val('');

			},
			error: function (e) {
				console.log(e);
				console.log("Gosave error");
			}

		});
	}
}

function viewEdit() {
	if (confirm("글을 수정하시겠습니까?")) {
		editFrm.submit();
	}
} 
function viewDel() {
	if (confirm("글을 삭제하시겠습니까?")) {
		delFrm.submit();
	}
}

function clickBoardLike() {
	if (login_member_no == -1) {
		$("#likeCount").text("♡");
	} else {
		$.ajax({
			url: "/dataro/boardTravel/initBoardLike.do",
			method: "post",
			data: {
				'board_no': ${ data.board.board_no },
				'board_name' : '${data.board.board_name}',
				'member_no' : login_member_no,
				likeCheck : likeCheck
		    },
			success: function(i) {
				if (i == 0) {
					$("#likeCount").text("♡");
				} else if (i == 1) {
					$("#likeCount").html("♥");
				}
				likeCheck = i;
			},
			error: function(e) {
				console.log(e);
			}
		   
		});
	}
}

function clickDislike() {
	if (login_member_no == -1) {
		$("#dislikeCount").html("<img src='/resources/dataro/img/dislike.png'>");
		
	} else {
		$.ajax({
			url: "/dataro/boardTravel/clickDislike.do",
			method: "post",
			data: {
				'board_no': ${ data.board.board_no },
				'board_name' : '${data.board.board_name}',
				member_no : login_member_no,
				dislikeCheck : dislikeCheck
		    },
			success: function(i) {
				if (i == 0) {
					$("#dislikeCount").html("<img src='/resources/dataro/img/dislike.png'>");
				} else if (i == 1) {
					$("#dislikeCount").html("<img src='/resources/dataro/img/checkDislike.png'>");
				}
				dislikeCheck = i;
			},
			error: function(e) {
				console.log(e);
			}
		});
	}
}

</script>

</body>
</html>