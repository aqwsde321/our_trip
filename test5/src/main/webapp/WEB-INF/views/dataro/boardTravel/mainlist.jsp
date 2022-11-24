<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:forEach var ="list" items="${list}" varStatus="status">
	<div class="cnt_set color1">
		<div class="color1">
			<br>
			<h5>${list.title}</h5>
			<br>
			<div><strong>글번호 : ${list.board_no} ㅣ 회원ID : ${list.id}</strong></div>
			<br>
			<span>
				<c:forEach var ="cate" items="${list.categoryList}">
					<c:if test="${!empty cate.region_name }">
						<label class="hash gmarket">#${cate.region_name }</label>
					</c:if>
					<c:if test="${!empty cate.hashtag_name }">
						<label class="hash gmarket">#${cate.hashtag_name }</label>
					</c:if>
				</c:forEach>
			</span>
		</div>
		<div class="img_area color1">
			<a href="view.do?board_no=${list.board_no}&board_name=${list.board_name}">
				<img src ="/upload/${list.filename_server }" height="100%" width="100%" id="idImg" >
			</a>
			<ul>
				<li>
					<span><b>${list.likecount}</b></span>
					<span>좋아요</span>
				</li>
				<li>
					<span><b>${list.replycount}</b></span>
					<span>댓글수</span>
				</li>
				<li>
					<span><b>${list.viewcount}</b></span>
					<span>조회수</span>
				</li>
			</ul>
		</div>
		<ul class="courselist color1" >
			<li class="maplist">
				<c:forEach var="mvo" items="${list.placeList}">
					<span>●&nbsp;</span><span>${mvo.place_name}</span><br>
				</c:forEach>
			</li><br>
		</ul>    
	</div>
</c:forEach>