<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>OurTrip</title>
<link rel="stylesheet" href="/resources/dataro/css/style.css"/>
<link rel="stylesheet" href="/resources/dataro/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/contents.css"/>
<link rel="stylesheet" href="/resources/dataro/css/qna.css"/>
<link href="https://www.flaticon.com/authors/freepik" title="Freepik">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" integrity="sha384-DyZ88mC6Up2uqS4h/KRgHuoeGwBcD4Ng9SiP4dIRy0EXTlnuz47vAwmeGwVChigm" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css" integrity="sha512-1sCRPdkRXhBV2PBLUdRb4tMg1w2YPf37qatUFeS7zlBy7jJI8Lf4VHwWfZZfpXtYSLy85pkm9GaYVYMfw5BC1A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="/resources/dataro/smarteditor/js/HuskyEZCreator.js"></script>
<script src="/resources/dataro/js/function.js"></script>
</head>
<body>
<div id="wrap">
<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp" %>
    
	<div class="sub">
		<div class="size">
			<h3 class="sub_title">QnA</h3>
		
			<div class="bbs">
				<form method="post" name="frm" id="frm" action="insert.do" enctype="multipart/form-data">
					<input type="hidden" name="member_no" value="${loginInfo.member_no }">
					<input type="hidden" name="id" value="${loginInfo.id }">
					<table class="board_write">
						<tbody>
							<tr>
								<th>제목</th>
								<td>
								<input type="text" name="title" id="title" class="wid100" value=""/>
								</td>
							</tr>
							<tr>
								<th>내용</th>
								<td>
								<textarea name="content" id="content" style="width:90%"></textarea>
								</td>
							</tr>
							<tr>
								<th>첨부파일</th>
								<td>
								<input type="file" name="filename">
								</td>
							</tr>
						</tbody>
					</table>
					<div class="btnSet" style="text-align:right;">
						<a class="btn" href="javascript:goSave();">저장 </a>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<script>
function goSave(){
	editor.getById['content'].exec('UPDATE_CONTENTS_FIELD',[]);
	frm.submit();
}

var editor;
$(function(){
	editor = setEditor('content');
})
</script>  
</body>
</html>