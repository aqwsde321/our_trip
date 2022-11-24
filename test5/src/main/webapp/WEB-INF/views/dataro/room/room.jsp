<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="/resources/dataro/css/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/css/style.css"/>
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type='text/javascript' src="https://cdn.rawgit.com/abdmob/x2js/master/xml2json.js"></script>
<title>CHAT</title>

</head>
<body>

<div id="wrap">
<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp" %>
	<div class="content room_view chat">
		<article>
			<h3>${view.room_title }</h3>
			<div class="cnt">${view.room_content }</div>
		</article>
		<div id="chatArea">
			<div class="chat_list">
				<ul>
				</ul>
				<div id="endPoint" style="height:10px; background-colar:black;"></div>
			</div>
		</div>
		<div id="chatFrm">
			<input type="hidden" id ="" name="room_no" value="${view.room_no }">
			<input type="hidden" name="member_no" value="${loginInfo.member_no }">
			<input type="hidden" name="id" value="${loginInfo.id }">
			<input type="text" id="content" name="content">
			<a id="enter" href="javascript:enterChat();">Click</a>
		</div>
	</div>
</div>
<a href="#endPoint" id="my_btn" style="height:1px; opacity: 0;">버튼</a>
<script>
$(function(){
	getchat();
	
});

function enterChat(){
	$.ajax({
		url:"/dataro/room/chatWrite",
		type:'post',
		data:{
			room_no:${view.room_no },
			member_no:${loginInfo.member_no },
			member_id:'${loginInfo.id  }',
			content:$("#content").val()
		},
		success:function(res){
			if (res == 'success') {
				//document.getElementById('my_btn').click();
				$("#content").val('');
				//$("#chatArea").scrollTop($("#chatArea").height()); //스크롤 맨 위로.. 아직 안됨. 고쳐야 함.
				//$("#content").focus();
			} else {
				alert('채팅 fail;');
			}
		},
		error: function (e) {
			console.log("getchat error");
			console.log(e);
		}
	}); 
}

// 엔터키 채팅
$("#content").on("keyup",function(key){
    if(key.keyCode==13) {
        enterChat();
    }
});

var pre_len=0;

function getchat(){
	$.ajax({
		url:"/dataro/room/chatlist",
		type:'post',
		data:{
			room_no:${view.room_no},
			pre_len: pre_len
		},
		success:function(list){
			if(list.length != 0){
				var html = '';
				for (var chat=pre_len;chat<list.length; chat++){
					html += '<li '
					if(${loginInfo.member_no} == list[chat].member_no){
						html += 'class="me"'
					}
					html += '><span class="inner">'
					
					if(${loginInfo.member_no} != list[chat].member_no){
						html += '<span style="font-weight:bold">' + list[chat].member_id +' </span>'
					}	
					html += '<span> '+list[chat].content+' </span>'
					html += '<span class="date"> ['+list[chat].chat_w_str+']</span>'
					html += '</span></li>'
				}
				$(".chat_list ul").append(html);
				pre_len = list.length;
				//document.getElementById('my_btn').click();
				$("#chatArea").scrollTop($("#chatArea")[0].scrollHeight);
				$("#content").focus();
			}
		},
		error: function (e) {
			console.log("getchat error");
			console.log(e);
		},
		complete : function() {
			setTimeout(getchat,500);
	    }
	})
}

</script>
</body>
</html>