<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<link rel="stylesheet" href="/resources/dataro/css/qna.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="/resources/dataro/smarteditor/js/HuskyEZCreator.js"></script>
<script src="/resources/dataro/js/function.js"></script>
</head>
<body>
<div id="wrap">
	<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp"%>
	    
	<div class="sub">
		<div class="size">
			<h3 class="sub_title">QnA</h3>
			
			<div class="bbs">
				<form method="post" name="frm" id="frm" action="update.do"> <!-- enctype="multipart/form-data" -->
					<input type="hidden" name="board_no" value="">
					<table class="board_write">
						<tbody>
							<tr>
								<th>제목</th>
								<td>
									<input type="text" name="title" id="title" class="wid100" value="${data.title }"/>
								</td>
							</tr>
							<tr>
								<th>내용</th>
								<td>
									<textarea name="content" id="content">${data.content }</textarea>
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