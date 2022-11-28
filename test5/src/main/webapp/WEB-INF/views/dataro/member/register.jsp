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
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
<div id="wrap">
<%@ include file="/WEB-INF/views/dataro/common/subheader.jsp" %>
	<div class="content login page">
		<form action="register" method="post" name ="register" enctype="multipart/form-data" onsubmit="return checkform();">
			<table>
				<tr>
					<td><h1>Register</h1></td>
				</tr>
				<tr>
					<td><input type="text" id="id" name="id" placeholder="Id" maxlength='20' required></td>
				</tr>
				<tr>
					<td><div id="area1"></div></td>
				</tr>
				<tr>
					<td><input type="text" id="nickname" name="nickname" placeholder="Nickname" maxlength='8' required></td>
				</tr>
				<tr>
					<td><input type="password" id="pw1" name="pw1" placeholder="Password" required></td>
				</tr>
				<tr>
					<td><input type="password" id="pwd" name="pwd" placeholder="Confirm Password" required></td>
				</tr>
				<tr>
					<td class=""><div id="area2"></div></td>
				</tr>
				<tr>
					<td>
						<input type="text" id="email" size="10" placeholder="Email" name="email" required/>@<input type="text" id="email2" name="email2" size="10" required/>
						<select id="email_select" >
							<option value="1" selected>선택하기</option>
							<option value="gmail.com" id="1">gmail.com</option>
							<option value="naver.com" id="2">naver.com</option>
							<option value="hanmail.net" id="3">hanmail.net</option>
							<option value="kakao.com" id="4">kakao.com</option>
							<option value="icloud.com" id="5">icloud.com</option>
							<option value="2">직접입력</option>
     					</select>
					</td>
				</tr>
				<tr>
					<td><div id="area3"></div></td>
				</tr>
				
				<tr>
					<td><input type="file" name="filename" onchange="readInputFile(this)"></td>
				</tr>
				<tr>
					<td><h5>사진을 첨부하지 않으시면 기본이미지가 적용됩니다.</h5></td>
				</tr>
				<tr>
					<td style="padding:0 0 120px 0;"><input type="submit" value="가입" class="Btn"></td>
				</tr>
			</table>
		</form>
	</div>
</div>

<script type='text/javascript' src="/resources/dataro/js/register.js"></script>
<script>
// 아이디 중복체크 
var id;
$('#id').focusout(function(){
	id = $('#id').val().trim();
	checkID = false;
	if (id === '' ){
		$("#area1").html('아이디를 입력해주세요.').css('color','red').css('font-size','small');
	}
	else{
		$.ajax({
			url : 'checkId',
			type : 'post',
			data : {
				"id" : id
			},
			success : function(e) {
				if (e === 1) {
					$("#area1").html('동일한 아이디가 있습니다.').css('color','red').css('font-size','small');
					$('#id').val('');
					$('#id').focus();
				}
				else{
					$("#area1").html('사용가능한 아이디입니다.').css('color','green').css('font-size','small');
					checkID = true;
				}
			},
			error : function(){
				alert('id check ERROR');
			}
		});
	}
	
})
</script>
</body>
</html>