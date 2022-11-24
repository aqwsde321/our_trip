<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.net.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, user-scalable=yes">
<meta name="format-detection" content="telephone=no, address=no, email=no">
<meta name="keywords" content="">
<meta name="description" content="">
<title>DATARO</title>
<link rel="stylesheet" href="/resources/dataro/css/style.css"/>
<link rel="stylesheet" href="/resources/dataro/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/contents.css"/>
<link rel="stylesheet" href="/resources/dataro/css/view.css" >
<link rel="stylesheet" href="/resources/dataro/css/free.css" >
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
<div id="wrap">
<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp" %>   
	<div class="sub">
		<div class="size">
			<h3 class="sub_title">자유게시판</h3>
			<input type="hidden" id="board_name" name="board_name" value="${data.board_name }">
			
			<div class="bbs">
				<div class="view">
					<div class="title" style="text-align:left; line-height:1.5em; display:block;">
						<dl>
							<dt>${data.title } </dt>
							<dd class="date" style="text-align:left;">
							작성자 ${data.id } <br>
							작성일  <fmt:formatDate value="${data.writedate }" pattern="yyyy-MM-dd HH:mm:ss"/><br>
							<c:if test="${!empty data.updatedate }">
							수정일  <fmt:formatDate value="${data.updatedate }" pattern="yyyy-MM-dd HH:mm:ss"/>
							</c:if>
							</dd>
						</dl>
					</div>
					<div class="cont" style="text-align:left;">
						<p>${data.content }</p>
					</div>
						<dl class="file">
							<dt>첨부파일 </dt>
							<dd><a download href="/upload/${data.filename_server }"  target="_blank">${data.filename_org }</a></dd>
						</dl>
				          
					<div class="btnSet clear">
						<div class="fl_l">
							<a href="main.do" class="btn">목록으로</a>
							<c:if test="${loginInfo.member_no == data.member_no }">
								<a href="edit.do?board_no=${data.board_no }" class="btn">수정</a>
								<a href="javascript:del(${data.board_no });" class="btn">삭제</a>
							</c:if>
						</div>
					</div>
				</div>
			
				<div>
					<form method="post" name="frm" id="frm" action="" enctype="multipart/form-data" >
						<table class="board_write">
							<colgroup>
							<col width="*" />
							<col width="100px" />
							</colgroup>
							<tbody>
								<tr>
									<td>
										<textarea name="contents" id="contents" style="height:50px;"></textarea>
									</td>
									<td>
										<div class="btnSet"  style="text-align:right;"><a class="btn" href="javascript:goSave();">저장 </a></div>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
					
					<div id="replyArea">
					</div>
					
				</div>
			</div>
		</div>
	</div>
	
<%@ include file="/WEB-INF/views/dataro/common/modal.jsp" %>
</div>
<script>
$(function(){
	getReply(1); 
});

function del(no){
	if(confirm('정말로 삭제하시겠습니까?')){
		$.ajax({
			url : "delete.do",
			type : "post",
			data : {
				board_no : no,
			},
			success : function(res){
				if (res) {
					alert("정상적으로 삭제되었습니다.");
					location.href="main.do";
				} else {
					alert("정상적으로 삭제되었습니다.");
					history.back();
				}
			}
		});
	}
}
   
function getReply(page){
	$.ajax({
		url : "/dataro/reply/list.do",
		data : {
			board_no : ${data.board_no},
			board_name : $("#board_name").val(),
			page : page
		},
		success : function(res){
			$("#replyArea").html(res);
		},
		error: function(e) {
			console.log(e);
		}
	});
}

function goSave(){
	<c:if test="${empty loginInfo}">
		alert('댓글은 로그인 후 작성가능합니다.');
	</c:if>
	
	<c:if test="${!empty loginInfo}">
		if(confirm('댓글을 작성하시겠습니까?')){
			var board_name = $("#board_name").val();
			var board_no = ${data.board_no};
			$.ajax({
				url : "/dataro/reply/insert.do",
				data : {
					board_no : board_no, 
					board_name : board_name,
					content : $("#contents").val(), //jquery
					member_no : ${loginInfo.member_no}, //el
					member_id: '${loginInfo.id}'
				},
				success : function(res){
					if(res.trim()=="success"){
						alert('댓글이 정상적으로 등록되었습니다.');
					} else {
						alert('댓글 등록 실패');
					}
					getReply(1); //댓글 저장후 1페이지 다시 불러옴
					$("#contents").val('');
				},
				error: function (e) {
					console.log(e);
					console.log("Gosave error");
				}
			});
		}
	</c:if>
}

function replyDel(no) {
	if (confirm("댓글을 삭제하시겠습니까?")) {
		$.ajax({
			url: '/dataro/reply/delete.do',
			type: 'POST',
			data:{
				reply_no: no
			},
			success: function (res) {
				if(res.trim()=='success'){
					alert('댓글이 정상적으로 삭제되었습니다.');
					getReply(1);
				} else {
					alert('댓글 삭제 실패');
				}
			}
		})
	}
}
</script>      
</body>
</html>