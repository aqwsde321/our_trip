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
		<div>
			<h2>내가 쓴 글</h2>
			<form method="get" name="Form" id="Form" action="" onsubmit="return myList();">
				<div id="srchDiv">
				<span class="srchSelect">
					<select id="stype" name="stype" value="${param.stype }">
						<option value="title">글제목</option>
					</select>
				</span>
				<span class="searchWord">
					<input type="text" id="sword" name="sword" value="${param.sword }" >
				</span>
				</div>
			</form>
			<table class="list mpList">
				<colgroup>
					<col width="100px" />
					<col width="100px" />
					<col width="*" />
					<col width="80px" />
					<col width="150px" />
				</colgroup>
				<thead>
					<tr>
						<th>게시판 이름</th>
						<th>게시물 번호</th>
						<th>게시물 제목</th>
						<th>조회수</th>
						<th>작성일</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty data.list }">
						<tr>
							<td class="first" colspan="5">작성한 글이 없습니다.</td>
						</tr>
					</c:if>
					<c:forEach var="vo" items="${data.list }" varStatus="status">
						<tr>
							<td>${vo.board_name}</td>
							<td>${vo.board_no}</td>
							<td class="titlee" > <a href="/dataro/boardTravel/view.do?board_no=${vo.board_no}&board_name=${vo.board_name} ">${vo.title}</a></td>
							<td>${vo.viewcount }</td>
							<td class="date"><fmt:formatDate value="${vo.writedate }" pattern="yyyy-MM-dd"/></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
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
		</div>
	</div>
</div>
</body>
</html>