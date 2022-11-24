<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>게시판목록</title>
</head> 
<body>
<div id="wrap">
	<div class="content login border trhov">
		<h2>보낸 쪽지함</h2>
		<form method="post" name="Frm" id="Frm" onsubmit="return myList();"> 
			<div id="srchDiv">
				<span class="srchSelect">
					<select id="stype" name="stype">
						<option value="all" ${param.stype  == 'all'? 'selected' : '' } >전체</option>
						<option value="nickname" ${param.stype  == 'nickname'? 'selected' : '' }>닉네임</option>
						<option value="message_content" ${param.stype  == 'message_content'? 'selected' : '' } >내용</option>
					</select>
				</span>
				<span class="searchWord">
					<input type="text" id="sword" name="sword" value="${param.sword }"  title="검색어 입력">
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
						<th>보낸 날짜</th>
						<th><input type="checkbox" id="myListAllChk"></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty data.list }">
						<tr>
							<td class="first" colspan="5">보낸 쪽지가 없습니다.</td>
						</tr>
					</c:if>
					<c:forEach var="vo" items="${data.list }" varStatus="status">
						<tr>
							<td>${vo.nickname}</td>
							<td>${vo.id}</td>
							<td class="titlee"><a href="javascript:modalFadeIn('${vo.message_content}','${vo.nickname}' )">${vo.message_content}</a></td>
							<td class="date"><fmt:formatDate value="${vo.senddate }" pattern="yyyy-MM-dd"/></td>
							<td><input type="checkbox" class="myListChkBox" name="message_no" value="${vo.message_no }"></td>
						</tr>
					</c:forEach>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="5" style="text-align:right;">
							<a id ="delAtag" class="myListMsgBtn" href="javascript:deleteMsg();" >쪽지삭제</a>
						</td>
					</tr>
				</tfoot>
			</table>
			<input type="hidden" name="type" value="send">
		</form>
		
		<div>
			<ul class='paging'>
				<c:if test="${data.prev == true }"> 
					<a href="javascript:getPage(${data.startPage-1})">이전</a>
				</c:if>
				<c:forEach var="p" begin="${data.startPage }" end="${data.endPage }">
					<a href="javascript:getPage(${p})"  class="${messageVO.page  == p ? 'current' : '' }">${p }</a>
				</c:forEach>
				<c:if test="${data.next == true }">
					<a href="javascript:getPage(${data.endPage+1})">다음</a>
				</c:if>
			</ul> 
		</div>
		     
		<div class="msgRepModal">
			<div class="modal-msgRepcontent">
				<a class="btn-close" href="javascript:modalFadeOut();"><img src="/resources/dataro/img/close.png"></a>
				<table class="list">
					<tr>
						<td colspan="2" style="text-align:center"><strong><span id="nick"></span></strong> 님에게 보낸 쪽지</td>
					</tr>
					<tr style="border:1px solid black;">
						<td colspan="2" id="message_content" style="text-overflow:clip; white-space: initial;"></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<script>
function deleteMsg(){
	//console.log($('#delFrm').serialize());
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
			alert(`삭제할 쪽지를 체크해주세요 :)`);
		}
	});
}

//체크박스 전체 체크하기.
$("#myListAllChk").click(function() {
	if ($("#myListAllChk").prop("checked")) {
		$(".myListChkBox").prop("checked", true);
	} else {
		$(".myListChkBox").prop("checked", false);
	}
});

//삭제 버튼 클릭
$("#delAtag").click(function(){
	if ($(".myListChkBox:checked").length > 0 ){
		deleteMsg();
	} else {
		alert("삭제할 쪽지를 선택해주세요.");;
	}
});

function modalFadeIn(msgContent, nick){
	$('.msgRepModal').fadeIn();
	$('#nick').text(nick);
	$('#message_content').text(msgContent);
}

function modalFadeOut(){
	$('.msgRepModal').fadeOut();
}

if(${empty data.list}){
	$('#delAtag').hide();
} else {
	$('#delAtag').show();
}
</script>
</body>
</html>