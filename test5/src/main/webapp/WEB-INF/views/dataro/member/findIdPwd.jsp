<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OurTrip</title>
<link rel="stylesheet" href="/resources/dataro/css/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/css/style.css"/>
<link rel="stylesheet" href="/resources/dataro/css/login.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
<div id="wrap">
<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp" %>
	<div class="content login bord">
		<div style="text-align:center; padding:100px 0 0 0;">
			<a href="#" id="fId">아이디 찾기</a>
			<a href="#" id="fPwd">비밀번호 찾기</a>
		</div>
		<div id="area"></div>
	</div>
</div>
<script>
$('#fId').click(function(){
	$.ajax({
		url : "findId",
		type:'get',
		success : function(e){
			$("#area").html(e);
		}
	});
});
$('#fPwd').click(function(){
	$.ajax({
		url : "findPwd",
		type:'get',
		success : function(e){
			$("#area").html(e);
		}
	})
});

</script>
</body>
</html>