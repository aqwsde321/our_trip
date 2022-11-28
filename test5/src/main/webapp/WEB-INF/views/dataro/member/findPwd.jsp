<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OurTrip</title>
<link rel="stylesheet" href="/resources/dataro/css/reset.css"/>
<link rel="stylesheet" href="/resources/dataro/css/login.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
<div id="wrap">
	<div class="content login Fidpw">
		<table>
			<tr>
				<th style="font-weight:bold; font-size:30px; padding:10px;">비밀번호 찾기</th>
			</tr>
			<tr>
				<td><input type="text" id="id" name="id" placeholder="Id" ></td>
			</tr>
			<tr>
				<td><span id="area1" style="color: red; font-size: small; display: none;">아이디를 입력해주세요.</span></td>
			</tr>
			<tr>
				<td><input type="text" id="email" name="email" placeholder="Email" maxlength='40'></td>
			</tr>
			<tr>
				<td><span id="area2" style="color: red; font-size: small; display: none;">이메일을 입력해 주세요.</span></td>
			</tr>
			<tr>
				<td><a class="Btn bord" id="findPwd">비밀번호 찾기</a></td>
			</tr>
		</table>
	</div>
</div>
<script>
$('#id').focusout(function(){
	if ($('#id').val().trim() ===''){
		$("#area1").show();
		$('#id').focus();
	} else {
		$("#area1").hide();
	} 
});
$('#email').focusout(function(){
	if ($('#email').val() ===''){
		$("#area2").show();
		$('#email').focus();
	} else {
		$("#area2").hide();
	} 
})
$('#findPwd').click(function(){
	$.ajax({
		url:'findPwd',
		type : 'post',
		data: {
			id : $("#id").val(),
			email : $("#email").val()
		},
		success : function(res) {
			if (res.trim() == '') {
				alert('회원정보가 올바르지 않습니다.');
			} else {
				alert('임시비밀번호는 '+res+' 입니다');
			}
		}
	});
});
</script>
</body>
</html>