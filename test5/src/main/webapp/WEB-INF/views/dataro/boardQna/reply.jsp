<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, user-scalable=yes">
<title>DATARO</title>
<link rel="stylesheet" href="/resources/dataro/css/style.css"/>
<link rel="stylesheet" href="/resources/dataro/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/contents.css"/>
<link rel="stylesheet" href="/resources/dataro/css/qna.css"/>
</head>
<body>
<div id="wrap">
<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp" %>   
	<div class="sub">
		<div class="size">
			<h3 class="sub_title">QnA</h3>
		
			<div class="bbs">
				<form method="post" name="frm" id="frm" action="reply.do" enctype="multipart/form-data">
					<input type="hidden" name="gno" value="${data.gno }">
					<input type="hidden" name="ono" value="${data.ono }">
					<input type="hidden" name="nested" value="${data.nested }">
					<!--<input type="hidden" name="member_no" value="${loginInfo.member_no }">--> 
					<table class="board_write">
						<tbody>
							<tr>
								<th>제목</th>
								<td><input type="text" name="title" id="title" class="wid100" value=""/></td>
							</tr>
							<tr>
								<th>내용</th>
								<td><textarea name="content" id="content"></textarea></td>
							</tr>
							<tr>
								<th>첨부파일</th>
								<td><input type="file" name="filename"></td>
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
	frm.submit();
}
</script>
</body>
</html>