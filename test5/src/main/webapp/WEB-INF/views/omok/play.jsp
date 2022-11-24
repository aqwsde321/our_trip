<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>omok sole play.jsp</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&family=Dongle:wght@700&family=Noto+Sans+KR&display=swap" rel="stylesheet">
<link href="/resources/omok/css/style.css" rel="stylesheet">

<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript">
var roomNum = ${roomNum };
</script>
</head>
<body>
<div class="wrap">
	<div class="cnt_wrap play">
		<h2>1인용</h2>
		<div id="div"></div>
		<div class="endbtn">
			<form name="END" action="end" method="post">
				<input type="hidden" name="roomNum" value="${roomNum }">
				<input type="submit"  value="게임 종료">
			</form>
		</div>
	</div>
</div>
<script src="/resources/omok/js/print.js"></script>
</body>
</html>