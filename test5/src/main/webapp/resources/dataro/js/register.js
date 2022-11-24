var checkID = true;
var checkPW = true;
var checkEM = true;

function checkform(){
	//console.log(checkID && checkPW && checkEM);
	if (checkID && checkPW && checkEM) return true;
	else return false;
}

$('#goMain').click(function (){
	location.href="/dataro/boardTravel/main.do";
})
	
// 비밀번호는 공백을 허용하므로 trim()을 집어넣으면 안 된다. 
$('#pw1').focusout(function(){
	checkPw()
})
$('#pwd').focusout(function(){
	checkPw()
})

// 비밀번호 체크 함수
var reg = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
var pw1;
var pwd;
function checkPw() {
	pw1 = $('#pw1').val();
	pwd = $('#pwd').val();
	checkPW = false;
	if (pw1 === ''){
		$("#area2").html('비밀번호를 입력해 주세요.').css('color','red').css('font-size','small');
		$('#pw1').focus();
	} else if(pwd === ''){
		$("#area2").html('비밀번호를 입력해 주세요.').css('color','red').css('font-size','small');
		$('#pwd').focus();
	} 
	else{
		if(!reg.test(pw1)) {
			$("#area2").html('비밀번호는 숫자, 영문, 특수문자 조합으로 8자리 이상으로 입력해주세요.').css('color','red').css('font-size','small');
			$("#pw1").focus();
		}
		else if (pw1 != pwd){
			$("#area2").html('비밀번호가 같지 않습니다.').css('color','red').css('font-size','small');
		} else {
			$("#area2").html('비밀번호가 동일합니다.').css('color','green').css('font-size','small');
			checkPW = true;
		}
	}
}


// 이메일 옵션 선택
var emailselect;
$('#email_select').change(function(){
	checkEM = false;
	$("#area3").html('');
	emailselect = $('#email_select').val();
	
	// 직접입력 선택 시,
	if(emailselect == "2"){
		$("#email2").val(""); //값 초기화
		$("#email2").prop("readonly",false); 
	} 
	// 선택하기 선택 시,
	else if(emailselect == "1"){
		$("#email2").val(""); //값 초기화
		$("#email2").prop("readonly",false); 
	} 
	// 옵션 안의 이메일을 선택했을 경우,
	else {
		$("#email2").val(emailselect); 
		$("#email2").prop("readonly",true); 
		checkEmail()
	}
});

// 이메일 직접입력시 중복체크
$('#email').focusout(function (){
	checkEmail();
});
$('#email2').focusout(function (){
	checkEmail();
});

// 이메일 중복 체크 함수
var email;
var email2;
function checkEmail(){
	$("#area3").html('');
	checkEM = false;
	email = $('#email').val();
	email2 = $('#email2').val();
	if (email != '' && email2 != ''){
		var emailT = email + '@'+ email2;
		$.ajax({
			url : 'checkEmail',
			type : 'post',
			data : {
				"email" : emailT
			},
			success : function(e) {
				if (e > 0) {
					$("#area3").html('동일한 이메일주소가 있습니다.').css('color','red').css('font-size','small');
				}
				else if (e == 0){
					$("#area3").html('사용가능한 이메일입니다.').css('color','green').css('font-size','small');
					checkEM = true;
				}else if (e == -1){
					$("#area3").html('기존 이메일입니다.').css('color','green').css('font-size','small');
					checkEM = true;
				}
			},
			error : function(){
				alert('email check ERROR');
			}
		});
	}
};