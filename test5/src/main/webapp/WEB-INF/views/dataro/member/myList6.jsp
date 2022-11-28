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
		<h2>참여한 채팅방</h2>
		<div class="bbs" style="display:inline-block; height:200px; overflow-y:scroll; padding-top: 10px;">
			<form method="post" name="Form" id="searchForm" action="">
				<table class="list mpList">
					<colgroup>
						<col width="150px" />
						<col width="100px" />
						<col width="*" />
						<col width="150px" />
					</colgroup>
					<thead>
						<tr>
							<th>게시판 이름</th>
							<th>방 번호</th>
							<th>방 제목</th>
							<th>방장 아이디</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty list }">
							<tr>
								<td class="first" colspan="5">참여한 채팅방이 없습니다.</td>
							</tr>
						</c:if>
						<c:forEach var="vo" items="${list }" varStatus="status">
							<tr>
								<td>${vo.board_name}</td>
								<td>${vo.room_no}</td>
								<td class="titlee"><a href="javascript:joinRoomInMyPage(${vo.room_no});">${vo.room_title}</a></td>
								<td>${vo.roommaker_id}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</form>
		</div>
	</div>
</div>

<!-- 방으로 보내기 post -->
<form name="goroom" action="/dataro/room/room.do" method="post">
	<input type="hidden" id="go_room" name="room_no" value="">
</form>

<script>
function joinRoomInMyPage(no) {
	if (confirm(no+'번 방에 참여하시겠습니까?')) {
		$('#go_room').val(no);
		goroom.submit();
	}
}
</script>
</body>
</html>