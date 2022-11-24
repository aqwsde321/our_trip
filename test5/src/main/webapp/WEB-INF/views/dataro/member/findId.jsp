<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DATARO</title>
<link rel="stylesheet" href="/resources/dataro/css/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/css/login.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
<div id="wrap">
	<div class="content login Fidpw">
			<table>
				<tr>
					<th style="font-weight:bold; font-size:30px; padding:10px;">아이디 찾기</th>
				</tr>
				<tr>
					<td><input type="text" id="email" name="email" placeholder="Email" maxlength='20'></td>
				</tr>
				<tr>
					<td><span id="area2" style="color: red; font-size: small; display: none;">이메일을 입력해 주세요.</span></td>
				</tr>
				<tr>
					<td><a class="Btn bord" id="findId">아이디 찾기</a>
				</tr>
			</table>
	</div>
</div>
<script>
$('#email').focusout(function(){
	if ($('#email').val() === '' ){
		$("#area2").show();
		$('#email').focus();
	} else {
		$("#area2").hide();
	} 
});

$('#findId').click(function(){
	$.ajax({
		url:'findId',
		type : 'post',
		data: {
			email : $("#email").val()
			//,nickname : $("#nickname").val()
		},
		success : function(res) {
			if (res.trim() == '') {
				alert('입력하신 정보는 존재하지 않습니다.');
			} else {
				alert('아이디는 "'+res.trim()+'" 입니다.');
			}
		}
	});
});
</script>
</body>
</html>