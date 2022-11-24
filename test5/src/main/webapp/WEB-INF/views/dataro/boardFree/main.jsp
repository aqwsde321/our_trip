<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="/resources/dataro/css/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/css/style.css"/>
<link rel="stylesheet" href="/resources/dataro/contents.css"/>
<link rel="stylesheet" href="/resources/dataro/css/free.css" >
<link href="https://www.flaticon.com/authors/freepik" title="Freepik">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Lobster&display=swap" >
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" integrity="sha384-DyZ88mC6Up2uqS4h/KRgHuoeGwBcD4Ng9SiP4dIRy0EXTlnuz47vAwmeGwVChigm" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css" integrity="sha512-1sCRPdkRXhBV2PBLUdRb4tMg1w2YPf37qatUFeS7zlBy7jJI8Lf4VHwWfZZfpXtYSLy85pkm9GaYVYMfw5BC1A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<title>DATARO</title>
</head>
<body>
<div id="wrap">
<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp" %>

	<div class="content">
		<div class="sub size">
			<h3 class="sub sub_title">자유게시판</h3>
			
			<div class="bbs">
				<span><strong>총 ${data.totalCount }개</strong>  |  ${freeVO.page }/${data.totalPage }페이지</span>
				<table class="list">
					<colgroup>
					<col width="80px" />
					<col width="*" />
					<col width="100px" />
					<col width="100px" />
					<col width="200px" />
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>조회수</th>
							<th>작성자</th>
							<th>작성일</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty data.list }"><!-- null이든, size가 0이든 empty -->	
							<tr>
								<td class="first" colspan="5">등록된 글이 없습니다.</td>
							</tr>
						</c:if>
						
						<c:if test="${not empty data.list }"><!-- 쓸 필요X, for문이라 없으면 안돔 -->
							<c:forEach items="${data.list }" var="list" varStatus="idx" >      
							<tr>
								<td>${data.totalCount- idx.index - ((FreeVO.page-1) * FreeVO.pageRow)}</td>
								<td class="txt_l" style="text-align:left;">
									<a href="view.do?board_no=${list.board_no }">${list.title }<c:if test="${list.replycount>0 }"> [${list.replycount }]</c:if><c:if test="${!empty list.filename_server }">&nbsp;&nbsp;<i class="fa-sharp fa-solid fa-image"></i></c:if></a>
								</td>
								<td>${list.viewcount }</td>
								<td class="writer">${list.id }</td>
								<td class="date"><fmt:formatDate value="${list.writedate }" pattern="yyyy-MM-dd HH:mm"/></td>
							</tr>
							</c:forEach> 
						</c:if> 
					</tbody>
				</table>
				<div class="btnSet"  style="text-align:right;">
					<a class="btn" href="javascript:goWrite();">글작성 </a>
				</div>
				<!-- 페이징 처리 -->
				<div class="pagenate clear">
					<ul class='paging'>
					<c:if test="${data.prev==true }">
						<li><a href="${data.startPage-1 }"><</a></li>
					</c:if>
					<c:forEach var="num" begin="${data.startPage }" end="${data.endPage }">
						<li><a href="${num }" class="${freeVO.page == num? 'current' : '' }">${num }</a></li>
					</c:forEach>
					<c:if test="${data.next==true }">
						<li><a href="${data.endPage+1 }">></a></li>
					</c:if>
					</ul> 
				</div>
				
				
				<div class="bbsSearch">
					<form method="get" name="searchForm" id="searchForm" action="main.do"><!-- action안쓰면 현재페이지로 감 -->
						<span class="srchSelect">
							<select id="stype" name="stype" class="dSelect" title="검색분류 선택">
								<option value="title">제목</option>
								<option value="id">회원ID</option>
							</select>
						</span>
						<span class="searchWord">
							<input type="text" id="sval" name="sword" value="${param.sword }"  title="검색어 입력">
							<input type="button" id="" value="검색" title="검색">
						</span>
					</form>
					<form id="actionForm" action="main.do" method="get">
						<input type="hidden" name="page" value= "${freeVO.page}">
						<input type="hidden" name="pageRow" value="${freeVO.pageRow}">
						<input type="hidden" name="stype" value="${param.stype }">
						<input type="hidden" name="sword" value="${param.sword }">
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
	var actionForm = $("#actionForm");
	$(".paging li a").on("click", function(e){
		e.preventDefault();
		actionForm.find("input[name='page']").val($(this).attr("href"));
		actionForm.submit();
	});
	
	function goWrite(){
		<c:if test="${empty loginInfo}">
			alert('로그인 후 작성가능합니다.');
		</c:if>
		<c:if test="${!empty sessionScope.loginInfo}">
			location.href="write.do";
		</c:if>
	}
</script>	
</body>
</html>