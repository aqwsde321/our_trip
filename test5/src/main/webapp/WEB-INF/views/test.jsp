<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.wrapper {

    display: grid;

    grid-template-columns: repeat(3, 1fr);

}
</style>
<script src="https://kit.fontawesome.com/f55e2ec119.js" crossorigin="anonymous"></script>
</head>
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<body>
<i class="fa-solid fa-bell-on"></i>
<i class="fa-solid fa-bell"></i>
<i class="fa-regular fa-bell-exclamation"></i><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><!--! Font Awesome Pro 6.2.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2022 Fonticons, Inc. --><path d="M224 0c-17.7 0-32 14.3-32 32V51.2C119 66 64 130.6 64 208v18.8c0 47-17.3 92.4-48.5 127.6l-7.4 8.3c-8.4 9.4-10.4 22.9-5.3 34.4S19.4 416 32 416H416c12.6 0 24-7.4 29.2-18.9s3.1-25-5.3-34.4l-7.4-8.3C401.3 319.2 384 273.9 384 226.8V208c0-77.4-55-142-128-156.8V32c0-17.7-14.3-32-32-32zm45.3 493.3c12-12 18.7-28.3 18.7-45.3H224 160c0 17 6.7 33.3 18.7 45.3s28.3 18.7 45.3 18.7s33.3-6.7 45.3-18.7z"/></svg>
<i class="fa-regular fa-circle-user"></i>사진보기 <br> ${list} <br><br>
	<c:forEach var="img" items="${list}" varStatus="status">
		${img}
		<br>
		<a download href="../../../upload/${img}"><img src ="../../../upload/${img}" height="10%" width="10%"></a>
		<br>
		<a href="javascript:del('${img}')"><img src ="../../upload/${img}" height="10%" width="10%"></a>
		<br>
		<img src ="../upload/${img}" height="10%" width="10%">
		<br>
		<img src ="/upload/${img}" height="10%" width="10%">
		<br>
		하나끝
		<br>
		
	</c:forEach>
<script>
function del(img){
	$.ajax({
		url : "/filedelete.do",
		type : "post",
		data: {
			use : img
		},
		success : function(r){
			console.log(r);
		},
		error: function(e){
			console.log(e);
	    }
	})
}
</script>
<!-- <button id="apple" onclick="test(this)">사과</button>
<button id="banana" onclick="test(this)" value="gg">바나나</button>
<div id="zz1" onclick="test(this)" value="1">zzz</div>
<button id="melon" onclick="test(this)">메론</button>
 
<script>
    function test(e) {
    	console.log(e)
    	console.log(this)
    	console.log($(this).id())
    	var a = $(this).find("button");
    	console.log(a)
        alert(document.getElementById(e.getAttribute('id')).getAttribute('id'));
    }
</script> -->
<%--
<div class="wrapper">

    <div>1</div>

    <div>2</div>

    <div>3</div>

    <div>4</div>

    <div>5</div>

    <div>6</div>

</div>
 <form action="/dataro/message/SM" method="post" id="thisForm">
			<div class="modal">
				<div class="modal-content">
					<a class="btn-close" href="javascript:modalFadeOut();">x</a>
					<table>
						<input type="hidden" id="send_member_no" name="send_member_no" value="${loginInfo.member_no }" >
						<input type="hidden" id="receive_member_no" name="receive_member_no" value="">
						<tr>
							<td style="text-align:right">From&nbsp</td>
							<td style="text-align:left" id="nick" name="nick"></td>
						</tr>
						
						<tr>
							<td colspan="2" id="message_C" name="message_C"></td>
						</tr>
						<tr>
							<td colspan="2"><textarea style="display:none" id="msgbox" name="message_content" cols="30" rows="5"></textarea></td>
						</tr>
						<tr><td></td></tr>
						<tr>
							<td colspan="2">
								<a href="#" id="btn-send">답장하기</a>
								<input type="button" id="btnSend" style="display:none" value="전송하기">
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
	
<img src="/upload/123.png" style="height: 40px;" onclick="OnloadImg(this.src)">

<div class="alarmmodal">dd
</div>	
	<div class="modal-alarmcontent">
		<a class="btn-close" href="#none"><img src="/resources/dataro/img/close.png"></a>
		<div id="areaForUser"></div>
	</div>
	
	
		

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
$('.alarmmodal').click(function(){
		$.ajax({
			url : '/dataro/member/alarm',
			type : 'post',
			data : {},
			success : function(e) {  
				$("#areaForUser").html(e); // return "board/alarm"; 으로 해놔서, 해당 jsp가 해당 공간에 띄어짐.
				$('.alarmmodal').fadeIn();
				console.log(1);
			},
			error: function(e){
				console.log(e);
			}
		});
});
 function OnloadImg(url){

  var img=new Image();

  img.src=url;

  var img_width=img.width;

  var win_width=img.width+25;

  var height=img.height+30;

  var OpenWindow=window.open('','_blank', 'width='+img_width+', height='+height+', menubars=no, scrollbars=auto');

  OpenWindow.document.write("<style>body{margin:0px;}</style><img src='"+url+"' width='"+win_width+"'>");

 } --%>

</script>


<script>
/*  naver api 영화 이용
window.onload = function(){
	
    mapSet();     
}

function mapSet(){
	
	$.ajax({
        url: '/movie/list',
        type: 'get',
        data: {	
        	"word": "공조"	
        		},        
        success: function (list) {		
        	console.log(list);
        	console.log(list.items);
        	console.log(list.items[1]);
        	console.log(list.items[1].title);
			alert(list.items[1].title)
        }
    });
	
}
 */
</script>
</body>
</html>