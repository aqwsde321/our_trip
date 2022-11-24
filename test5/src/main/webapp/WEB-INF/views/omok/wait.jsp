<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>omok wait.jsp</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&family=Dongle:wght@700&family=Noto+Sans+KR&display=swap" rel="stylesheet">
<link href="/resources/omok/css/style.css" rel="stylesheet">
</head>
<body>
	<div class="wrap">
		<div class="cnt_wrap wait">
			<h2>select game mode</h2>
			<form action="play" method="post">	
				<button type="submit"  name="playerNum" value="0">
					<img src="/resources/omok/image/2/cat1.jpg" width="100px" alt="">
					<b>1인용</b>
				</button>
				<button type="submit"  name="playerNum" value="1" >
					<img src="/resources/omok/image/2/cat2.jpg" width="100px" alt="">
					<b>2인용</b>
				</button>
			</form>
		</div>
	</div>
</body>
</html>