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
		<form action="editUserInfo" method="post" name ="register" enctype="multipart/form-data" onsubmit="return checkform();">
			<table>
				<tr>
					<td><h1>회원정보수정</h1></td>
				</tr>
				<tr>
					<td><input type="text" id="id" name="id" value="${loginInfo.id }" readonly style="background-color: #ced4da"></td>
				</tr>
				<tr>
					<td><input type="text" id="nickname" name="nickname" placeholder="Nickname" value="${loginInfo.nickname }" maxlength='8' required></td>
				</tr>
				<tr>
					<td><input type="password" id="pw1" name="pw1" placeholder="Password" required></td>
				</tr>
				<tr>
					<td><input type="password" id="pwd" name="pwd" placeholder="Confirm Password" required></td>
				</tr>
				<tr>
					<td><div id="area2"></div></td>
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
					<td><input type="submit" value="수정하기" class="Btn"></td>
				</tr>
				<tr><td>&nbsp</td></tr>
				<tr>
					<td style="text-align:right;"><a href="javascript:modalFadeIn();" style="color:blue;">탈퇴하기&nbsp&nbsp&nbsp&nbsp</a></td>
				</tr>
			</table>
		</form>
		<form action="leave" method="post">
			<div class="leavemodal">
				<div class="modal-leavecontent">
					<a class= "btn-close" href="javascript:modalFadeOut();">X</a>
					<h1>회원탈퇴</h1>
					${loginInfo.nickname } 님, 안녕하세요! <br>
					계정을 삭제하려고 하신다니 아쉽습니다. <br>
					<br><img src="/resources/dataro/img/sadCat.jpg" style="width:200px; display:block; position:relative; left:70px; border-radius: 20px;" /><br>
					회원 탈퇴를 원하시면 비밀번호를 입력해 주세요. <br/><br/>
					<input type="password" placeholder="Password" name="pwd"> <br>
					<input type="hidden"  name="id" value="${loginInfo.id }">
					<br/>
					<input type="submit" value="탈퇴하기" class="leaveBtn">
				</div>
			</div>
		</form>
	</div>
</div>

<script type='text/javascript' src="/resources/dataro/js/register.js"></script>
<script>
var dbEmail = '${loginInfo.email }';
var sepEmail = dbEmail.lastIndexOf('@');
var dbEmail1 = dbEmail.substring(0,sepEmail);
var dbEmail2 = dbEmail.substring(sepEmail+1);
$('#email').val(dbEmail1);
$('#email2').val(dbEmail2);

function modalFadeIn(){
	$('.leavemodal').fadeIn();
}
function modalFadeOut(){
	$('.leavemodal').fadeOut();
}
</script>
</body>
</html>