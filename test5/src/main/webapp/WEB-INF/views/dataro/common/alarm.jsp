<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
#alarmtable tr td{
	white-space: nowrap; /*nowrap 줄바꿈을 하지 않음.*/
	overflow: hidden;
	text-overflow: ellipsis;
	padding: 5px 10px;
	border: 1px solid white;
	border-collapse: collapse;
}
#alarmtable tr:nth-child(odd) {
	background-color: #a9ddfb85;
}
#alarmtable label {
	display: inline-block;
	border: 1px solid white;
	padding: 2px 12px 2px 2px;
	border-radius: 50px;
	cursor: pointer;
	background: #D6EEEE;
}
#alarmtable label input{
	opacity: 0;font-weight:bold;font-size:10px;color:gray;
}
#msgReadBtn{
	cursor: pointer;
}
</style>
<div style="display:inline-block; height:200px; overflow-y:scroll;">
<form id="messageFrm">
	<table id="alarmtable">
		<colgroup>
			<col width="100px" />
			<col width="*" />
			<col width="120px" />
		</colgroup>
		<tr>
			<td colspan="3" class="gmarket" style="font-weight:bold;font-size:17px;">New Message</td>
		</tr>
		<c:choose>
			<c:when test="${empty unreadList }">
				<tr>
					<td colspan="3">읽지 않은 쪽지가 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach var="vo" items="${unreadList }" >
					<tr>
						<td>${vo.nickname}</td>
						<td>${vo.message_content}</td>
						<td><input type="checkbox" class="messagecheck" name="message_no" value="${vo.message_no }"></td>
					</tr>
				</c:forEach>
				<tr>
					<td colspan="2" style="text-align:right; font-weight:bold;font-size:13px;color:gray;"></td>
					<td><label ><input type="checkbox" id="allChkBox" >전체 선택</label></td>
				</tr>
				<tr>
					<td colspan="3" id="msgReadBtn" >쪽지 읽기</td>
				</tr>
			</c:otherwise>
		</c:choose>
	</table>
</form>
</div>

<script>

// '쪽지 읽기' 버튼 클릭시 읽음처리.
$("#msgReadBtn").click(function(){
	if ($(".messagecheck:checked").length > 0 ){
		alert($("#messageFrm").serialize());
		readProcess();
		location.reload(); 
	} else {
		alert("쪽지를 선택해주세요.");;
	}
}); 

// 체크박스 전체 체크하기.
$("#allChkBox").click(function() {
	if ($("#allChkBox").prop("checked")) {
		$(".messagecheck").prop("checked", true);
	} else {
		$(".messagecheck").prop("checked", false);
	}
});

// 안읽은 쪽지 화면에서 체크표시한 message_no들을 ajax로 해당 url로 넘김. 
function readProcess(){
	$.ajax({
		url : '/dataro/message/readProcess',
		type : 'post',
		data : $("#messageFrm").serialize(),
		success : function(e) {
			if (e === 1) alert("읽음 처리가 완료되었습니다.");
		},
		error : function(e){
			console.log(e);
			alert("쪽지 읽음처리 실패");
		}
	});
};
</script>
