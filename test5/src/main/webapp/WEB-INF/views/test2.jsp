<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

</head>
<body>
사진업로드

<form action="insert.do" name="AH" id="save" method="post" enctype="multipart/form-data"  onsubmit="return goSave()">
	<input type='file' name='filename'>
</form>
<a href="javascript:goSave()" class="save">등록</a>
<p>${org}, ${sever}</p>
1<br>
<a download href="../../../upload/${sever}"><img src ="../../../upload/${sever}" height="10%" width="10%"></a>
2<br>
<img src ="../../upload/${sever}" height="10%" width="10%">
3<br>
<img src ="../upload/${sever}" height="10%" width="10%">
4<br>
<img src ="/upload/${sever}" height="10%" width="10%">


<script>
function goSave(){
	
	AH.submit()
	
};
</script>
</body>
</html>