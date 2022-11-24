<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>게시판목록</title>
<style>
#wrap .modal-content table tr td {
	white-space: initial;
	text-overflow: initial;
	border: 1px solid black;
	border-collapse: collapse;
}
</style>
</head> 
<body>
<div id="wrap">
	<div class="content login border trhov">
		<h2>받은 쪽지함</h2>
		<form method="post" id="Frm" name ="Frm" onsubmit="return myList();"> 
			<div id="srchDiv">
				<span class="srchSelect">
					<select id="stype" name="stype">
						<option value="all" ${param.stype  == 'all'? 'selected' : '' }>전체</option>
						<option value="nickname" ${param.stype  == 'nickname'? 'selected' : '' }>닉네임</option>
						<option value="message_content" ${param.stype  == 'message_content'? 'selected' : '' }>내용</option>
					</select>
				</span>
				<span class="searchWord">
					<input type="text" id="sword" name="sword" value="${param.sword }" >
				</span>
			</div>
		</form>
		
		<form id="delFrm">
		<table class="list mpList">
			<colgroup>
				<col width="80px" />
				<col width="80px" />
				<col width="*" />
				<col width="150px" />
				<col width="70px" />
			</colgroup>
			<thead>
				<tr>
					<th>닉네임</th>
					<th>아이디</th>
					<th>쪽지 내용</th>
					<th>받은 날짜</th>
					<th><input type="checkbox" id="myListAllChk"></th>
				</tr>
			</thead>
			
			<tbody>
				<c:if test="${empty data.list }">
					<tr>
						<td class="first" colspan="5">받은 쪽지가 없습니다.</td>
					</tr>
				</c:if>
			<c:forEach var="vo" items="${data.list }" varStatus="status">
				<tr>
					<td>${vo.nickname}</td>
					<td>${vo.id}</td>
					<td class="titlee">
						<a href="javascript:modalFadeIn('${vo.message_content}', '${vo.nickname}', '${vo.send_member_no}', '${vo.message_no }')">
						<c:if test="${!empty vo.readdate }">
						<img src="/resources/dataro/img/read.png" style="height:10px;">
						</c:if>
						${vo.message_content}
						</a>
					</td>
					<td class="date"><fmt:formatDate value="${vo.senddate }" pattern="yyyy-MM-dd"/></td>
					<td><input type="checkbox" class="myListChkBox" name="message_no" value="${vo.message_no }"></td>
				</tr>
			</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="5" style="text-align:right;">
						<a id ="delAtag"  class="myListMsgBtn" href="javascript:deleteMsg();" >쪽지삭제</a>
					</td>
				</tr>
			</tfoot>
		</table>
		<input type="hidden" name="type" value="receive">
		</form>
		
		<div>
			<ul class='paging'>
				<c:if test="${data.prev == true }"> 
					<a href="javascript:getPage(${data.startPage-1})"> 이전 </a>
				</c:if>
				<c:forEach var="p" begin="${data.startPage }" end="${data.endPage }">
					<a href="javascript:getPage(${p})" class="${messageVO.page  == p ? 'current' : '' }">${p }</a>
				</c:forEach>
				<c:if test="${data.next == true }">
					<a href="javascript:getPage(${data.endPage+1})" > 다음 </a>
				</c:if>
			</ul> 
		</div>
		     
	<!-- 쪽지 답장 모달 -->		     
	<div class="msgRepModal">
		<div class="modal-msgRepcontent">
			<a class="btn-close" href="javascript:modalFadeOut();"><img src="/resources/dataro/img/close.png"></a>
			<input type="hidden" id="send_member_no" name="send_member_no" value="${loginInfo.member_no }" >
			<input type="hidden" id="receive_member_no" name="receive_member_no" value="">
			<table class="list">
				<tr>
					<td colspan="2" style="text-align:center"><span id="sep"></span>&nbsp;&nbsp;<strong><span id="nick"></span></strong></td>
				</tr>
				<tr style="border:1px solid black;">
					<td colspan="2" id="message_C" style="text-overflow:clip; white-space: initial;"></td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="text" id="msgbox" name="message_content" placeholder="답장을 입력하세요." style="width: 100%;display:none;">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<a href="#" id="btn-send" class="myListMsgBtn">답장</a>
						<a href="#" id="btnSend"  class="myListMsgBtn" style="display:none">전송</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
</div>
<script>
function modalFadeIn(msgContent, nick, no, msgno){
	$.ajax({
		url : '/dataro/message/readProcess',
		type : 'post',
		data : {
			message_no : msgno
		},
		success : function(e) {
			//if (e === 1) alert("읽음 처리가 완료되었습니다.");
		},
		error : function(e){
			console.log(e);
			alert("쪽지 읽음처리 실패");
		}
	});
	$('.msgRepModal').fadeIn();
	$('#message_C').text(msgContent);
	$('#nick').text(nick);
	$('#sep').text("FROM");
	$('#receive_member_no').val(no);
}

//체크박스 전체 체크하기.
$("#myListAllChk").click(function() {
	if ($("#myListAllChk").prop("checked")) {
		$(".myListChkBox").prop("checked", true);
	} else {
		$(".myListChkBox").prop("checked", false);
	}
});

// 답장하기 버튼 클릭시, '답장 텍스트 박스', '전송하기 버튼' show
$('#btn-send').click(function(){
	$('#btn-send').hide();
	$('#msgbox').show();
	$('#btnSend').show();
	$('#sep').text("TO");
})

$('#btnSend').click(function(){
	if (confirm('쪽지를 보내시겠습니까?')) {
		$.ajax({
			url: '/dataro/message/sendMessage.do',
			data: {
				send_member_no: ${loginInfo.member_no },
				receive_member_no: $('#receive_member_no').val(),
				message_content: $('#msgbox').val()
			},
			success: function (res) {
				if (res == 1) {
					alert('쪽지가 정상적으로 전송되었습니다.');
				} else {
					alert('쪽지 전송 오류');
				}
				$('.msgRepModal').fadeOut();
				$("#msgbox").val('');
				$('#btn-send').show();
				$('#btnSend').hide();
				$('#msgbox').hide();
			}
		})
	} else {
		alert('쪽지를 보내는데 실패하셨습니다.');
	};
})

// 삭제 버튼 클릭
$("#delAtag").click(function(){
	if ($(".myListChkBox:checked").length > 0 ){
		deleteMsg();
	} else {
		alert("삭제할 쪽지를 선택해주세요.");;
	}
});
	
	
function deleteMsg(){
	$.ajax({
		url : '/dataro/message/deleteProcess',
		type : 'post',
		data : $('#delFrm').serialize(),
		success : function(e) {
			if (e === 1)
			alert(`쪽지가 삭제되었습니다`);
			myList();
		},
		error : function(e){
			alert(`삭제할 쪽지를 체크해주세요 : )`);
		}
	});
}

function modalFadeOut(){
	$('.msgRepModal').fadeOut();
	$('#btn-send').show();
	$('#btnSend').hide();
	$('#msgbox').hide();
	$("#msgbox").val('');
}

if(${empty data.list}){
	$('#delAtag').hide();
} else {
	$('#delAtag').show();
}

</script>

</body>
</html>