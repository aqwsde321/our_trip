<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>omok double play.jsp</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&family=Dongle:wght@700&family=Noto+Sans+KR&display=swap" rel="stylesheet">
<link href="/resources/omok/css/style.css" rel="stylesheet">

<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript">
var turnSelect = ${turnSelect };
var dbRoomNum = ${dbRoomNum };
</script>
</head>
<body>
<div class="wrap">
	<div class="cnt_wrap play">
		<h2>2인용</h2> 
		<h5>${dbRoomNum*(-1)} 번 방</h5>	
		<div id="ts"></div> 
		<h5> 당신은 ${turnSelect!=1? "<img src='/resources/omok/image/0/2.png'>": "<img src='/resources/omok/image/0/3.png'>" }입니다.</h5>
		<h5>상대방은 ${turnSelect==1? "<img src='/resources/omok/image/0/2.png'>": "<img src='/resources/omok/image/0/3.png'>" }입니다.</h5>
		<div id="div"></div>
		<div class="endbtn">
			<form name="END" action="end" method="post">
				<input type="hidden" name="roomNum" value="${dbRoomNum }">
				<input type="submit"  value="게임 종료">
			</form>
			<!-- <a href="javascript:mapSet()">ajax</a> -->
		</div>
	</div>
</div>
<script src="/resources/omok/js/print2.js"></script>
 
</body>
</html>