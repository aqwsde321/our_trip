/* 등록 관련 [시작] */
// 등록 클릭시
function goSave(){
	
	if(!$('#title').val()){
		alert("제목을 입력해주세요.");
		return false;
	}
	if(count == 0){
		alert("지도에서 코스를 선택해주세요.(1~5개 선택가능)");
		return false;
	}else{
		if(confirm('등록하시겠습니까?')){
			send(courseArr);
		} 
	}
};

// ^^  코스 정보를 ajax로 보내고, 게시물 작성 정보를 form으로 보내기
function send(courseArr){
	if(typeof(no) === "undefined"){ // 새글 작성시 board_no 없음
		no = 0;		
	}

	$.ajax({
		url : "/dataro/map/mapinsert.do",
		type : "post",
		data: {
			board_no : no,
			'json' : JSON.stringify(courseArr)
		},
		dataType: 'json',
		success : function(){
		},
		error: function(){
			console.log("send에러");
		},
        complete : function() {
			AH.submit();
	    }
	})
};
/* 등록 관련 [끝] */


/* 글쓰기 관련 [시작] */
// 코스 추가시 위치정보+내용+사진 작성가능한 칸 생성
var pic =1;
function writebox(index,places){
	count++;  // map.js 에서 선언 makMake.js도 사용
	var html ='<div class="set">'
		html +='<div class="map_list">'
		html +=	'<span class="markerbg marker_' + (index+1) + '"></span>'+
				'<h5>' + places.place_name + '</h5>'+
				'<span class="info">'+
				'<span class="tel"><i class="fa\-solid fa\-phone"></i>' + places.phone  + '</span>' +
				'<span><i class="fa-solid fa-location-dot"></i>' +  places.address_name  + '</span>'
		html +=	'</span>'   
		html +='</div>'
		html +='<textarea placeholder="내용 입력" name="contents"> </textarea>'
		html +='<div class="pic_wrap">'
		html +='	<div class="pic">'
		html +='		<input type="file" class="file_input'+ pic +'" name="filename" id="inputFile'+pic+'" onchange="readInputFile(this)">'
	pic++;
		html +='		<img src="/resources/dataro/img/no-image.jpg">'
		html +='		<span class="delete" ><i class="fa-solid fa-circle-minus"></i></span>'
		html +='	</div>'
		html +='	<div class="pic">'
		html +='		<input type="file" class="file_input'+ pic +'" name="filename" id="inputFile'+pic+'" onchange="readInputFile(this)">'
		html +='		<img src="/resources/dataro/img/no-image.jpg">'
		html +='		<span class="delete" ><i class="fa-solid fa-circle-minus"></i></span>'
		html +='	</div>'
		html +='</div>'
		html +='<span class="course_delete">코스삭제</span>'
		html +='</div>'
	pic++;
	$('.scroll').append(html);
}

//첨부파일에 추가한 사진미리보기
function readInputFile(input){

	// files 로 해당 파일 정보 얻기.
	var file = input.files;

	// file[0].name 은 파일명 입니다.
	// 정규식으로 확장자 체크
	if(!/\.(gif|jpg|jpeg|png)$/i.test(file[0].name)) {
		alert('gif, jpg, png 파일만 선택해 주세요.\n\n현재 파일 : ' + file[0].name);
	}
	
	// 체크를 통과했다면 종료.
	else {
		var className = input.className;
		
		if(input.files && input.files[0]){
			var reader = new FileReader();
			reader.onload = function(e){
				$('.'+className+'').prev("input").val("");
				$('.'+className+'').next('img').attr("src", e.target.result);
			}
			reader.readAsDataURL(input.files[0]);
		}
		return;
	};
	
	// 체크에 걸리면 선택된  내용 취소 처리를 해야함.
	// 파일선택 폼의 내용은 스크립트로 컨트롤 할 수 없습니다.
	// 그래서 그냥 새로 폼을 새로 써주는 방식으로 초기화 합니다.
	// 이렇게 하면 간단 !?
	input.outerHTML = input.outerHTML;
};

//첨부파일 올린 사진 취소
$(document).on("click",".delete",function(){
	$(this).prev('img').attr("src","/resources/dataro/img/no-image.jpg");
	$(this).siblings('input').val("");
})

// 선택한 코스 마커+위치정보+내용+사진 삭제
$(document).on("click",".course_delete",function(){
	var course_delete_div = $(this).parent("div");
	
	if(confirm('코스 삭제?')) {
		courseIdx=0;
		courseArr.splice(course_delete_div.index(),1);
		count--;
		course_delete_div.remove();
		
		if(markerShow){
			displayCouses(courseArr);
		}else{
			searchPlaces();
		}
	}
})
/* 글쓰기 관련 [시작] */


/* 지역 선택 관련 [시작] */
//지역 소분류 보이기
$("#region").change(function(){
	var region_name = $(this).val();
	$('#'+region_name).siblings('span').css({"display": "none"});
	$('#'+region_name).css({"display": ""});
	
});

// 지역 소분류 html로 만들고 안보이게
function regionDetailShow(region_name){
	
	$.ajax({
		url:"/dataro/boardTravel/region_detail",
		data:{
			rs:region_name
		},
		success:function(res){
			//$('#'+region_name).remove();
			//$(".region_detail").find("input").remove();
			//$(".region_detail").find("label").remove();
			var html = '<span id="'+region_name+'" style="display: none;">'
			for(var i=0;i<res.regionDetailList.length;i++){
				var isClass = regionarr.indexOf(res.regionDetailList[i].region_no) >= 0 ? "class='on'" : "";
				var isChecked = regionarr.indexOf(res.regionDetailList[i].region_no) >= 0 ? "checked" : "";
		    	
				html += '<label for="region'+res.regionDetailList[i].region_no+'" '+isClass+'>'+res.regionDetailList[i].region_name
				html +='<input type="checkbox" name="region_no_arr" id="region'+res.regionDetailList[i].region_no+'" value="'+res.regionDetailList[i].region_no+'" '+isChecked+'>'
				html +='</label>'
			}
			html += '</span>'
			$(".region_detail").append(html);
		
		}
	})
}

//지도소분류 체크css / 체크시 체크한 정보 화면에 따로 표시

$(document).on("click",".region_detail label",function(){
	// 두번클릭한걸로 인식해서 if문 넣어주기
	var regName = $(this).parent()[0].id + " " + $(this).text();
	if($(this).find("input[type='checkbox']").is(':checked')){
		$(this).toggleClass("on");
		if($(this).hasClass("on")){
			var html ='<li id='+$(this).attr('for')+'>'+regName;
				html +='<a onclick="delCondition(\''+$(this).attr('for')+'\')"><i class="fa-solid fa-circle-xmark"></i>';
				html +='</a>';
				html +='</li>';
			$('.region_result').append(html);
			document.getElementById('keyword').value = regName;
			searchPlaces();	
		}else{
			$("li#"+$(this).attr('for')).remove();
		}
	}
})

function delCondition(e){
	$("li#"+e).remove();
	$("label[for='"+e+"']").removeClass('on');
	$("input#"+e).prop("checked",false);
}
/* 클릭 두번되는거 싫어서 input에 만들다가 다른 방식으로 고침
function addCondition(e){
	var regName = e.parentElement.parentElement.getAttribute('id')+" "+e.parentElement.innerText;
	var regId = e.getAttribute('id');
	console.log(e.checked);
	if(e.checked){
		e.parentElement.className ='on'
		var html ='<li id='+regId+'>'+regName;
			html +='<a onclick="delCondition(\''+regId+'\')"><i class="fa-solid fa-circle-xmark"></i>';
			html +='</a>';
			html +='</li>';
		$('.region_result').append(html);	
		document.getElementById('keyword').value = regName;
		searchPlaces();	
	}else{
		e.parentElement.className =''
		$("li#"+regId).remove();
	}
}
*/
/* 지역 선택 관련 [끝] */


// 해쉬태그 체크박스 선택관련
$(".hash label").click(function(){
	//두번클릭한걸로 인식해서 if문 넣어주기
	if($(this).find("input[type='checkbox']").is(':checked')){
		$(this).toggleClass("on")
	}
})