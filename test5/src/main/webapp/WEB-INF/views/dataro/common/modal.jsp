<%@ page language="java" pageEncoding="UTF-8"%>

<!-- 쪽지보내기 모달 -->
<div class="msgmodal">
	<div class="modal-msgcontent">
		<a class="btn-msgclose" href="javascript:">
			<img src="/resources/dataro/img/close.png">
		</a>
		<h3>Send Message<img src="/resources/dataro/img/message.png"></h3>
		<input type="hidden" id="send_member_no" name="send_member_no" value="${loginInfo.member_no }">
		<input type="hidden" id="receive_member_no" name="receive_member_no" value="">
		보내는 사람 
		<input type="text" name="send_member_id" value="${loginInfo.id }" readonly>
		<br> 받는 사람 
		<input type="text" name="receive_member_id" id="receive_member_id" value="" readonly>
		<input type="text" id="message_content" placeholder="보낼 메세지를 입력하세요." style="width: 100%">
		<div style="padding-top:5px;">
			<a class="btn-send" href="javascript:sendMessage();">보내기</a>
		</div>
	</div>
</div>

<!-- 댓글 수정 모달 -->
<div class="commentmodal">
	<div class="modal-commentcontent">
		<a class="btn-close" href="javascript:">
			<img src="/resources/dataro/img/close.png">
		</a>
		<h3>Edit Reply</h3>
		<input type="text" id="replyUpdate" placeholder="수정할 내용을 입력하세요." style="width: 100%">
		<input type="hidden" id="modal_rno" value="">
		<div style="padding-top:5px;">
			<a class="btn-edit" href="javascript:replyEdit();">수정</a>
		</div>
	</div>
</div>
	
<script>
//아이디 클릭하면 메세지모달 띄우기
function message(no, id) {
	$('.msgmodal').fadeIn();
	$("#receive_member_no").val(no);
	$("#receive_member_id").val(id);
}

//메세지모달 X버튼 누름
$('.btn-msgclose').click(function () {
	$('.msgmodal').fadeOut();
	$("#messageContent").val('');
})

//댓글수정 모달 X버튼 누름
$('.btn-close').click(function () {
	$('.commentmodal').fadeOut();
	$("#replyUpdate").val('');
})

function setReply_no(no) {
	$('.commentmodal').fadeIn();
	$("#modal_rno").val(no);
}

function replyEdit() {
	var page = $("#page").val();
	//console.log(page);
	if (confirm("댓글을 수정하시겠습니까?")) {
		$.ajax({
			url: '/dataro/reply/update.do',
			type: 'POST',
			data: {
				reply_no: $("#modal_rno").val(),
				content: $("#replyUpdate").val()
			},
			success: function (res) {
				if(res.trim()=='success'){
					//alert('댓글이 정상적으로 수정되었습니다.');
					getReply(page);
					$('.commentmodal').fadeOut();
				} else {
					alert('댓글 수정 실패');
				}
			}
		})
	}
}

function sendMessage() {
	if (confirm("쪽지를 전송하시겠습니까?")) {
		$.ajax({
			url: '/dataro/message/sendMessage.do',
			data: {
				send_member_no: $("#send_member_no").val(),
				receive_member_no: $("#receive_member_no").val(),
				message_content: $("#message_content").val()
			},
			success: function (res) {
				if (res == 1) {
					//alert('쪽지가 정상적으로 전송되었습니다.');
				} else {
					alert('로그인 후 이용가능합니다');
				}
				$('.msgmodal').fadeOut();
				$("#message_content").val('');
			}
		})
	}
}
</script>