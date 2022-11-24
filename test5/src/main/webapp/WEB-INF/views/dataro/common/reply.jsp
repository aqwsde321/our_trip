<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<p class="gmarket">
	<span>
		<strong>
			<img src="/resources/dataro/img/reply.png">댓글(${reply.totalCount })
		</strong>
		| ${replyVO.page}/${reply.totalPage }페이지
	</span>
</p>

<table class="list">
	<colgroup>
		<col width="80px" />
		<col width="140px" />
		<col width="*" />
		<col width="140px" />
		<col width="200px" />
	</colgroup>
	<tbody>
		<c:if test="${empty reply.list}">
			<tr>
				<td class="first" colspan="8">등록된 댓글이 없습니다.</td>
			</tr>
		</c:if>
		<!-- 댓글목록 -->
		<c:if test="${!empty reply.list}">
			<c:forEach var="vo" items="${reply.list }" varStatus="idx">
				<tr>
					<td>${reply.pagingCount-(10*(replyVO.page-1))-idx.index }</td>
					<td class="writer">
						<c:if test="${!empty loginInfo.member_no }">
							<a class="btn-sendclick" href="javascript:message(${vo.member_no }, '${vo.member_id }')">
								${vo.member_id }<img src="/resources/dataro/img/message.png" title="쪽지 보내기">
							</a>
						</c:if>
						<c:if test="${empty loginInfo.member_no }">
							<a class="btn-sendclick" href="javascript:Gologin()">
								${vo.member_id }<img src="/resources/dataro/img/message.png" title="쪽지 보내기">
							</a>
						</c:if>
					</td>
					<td class="txt_l" style="text-align:left">
						${vo.content }
						<c:if test="${vo.board_name=='여행게시판'}">
							<a href="javascript:replyList(${vo.gno })" class="replyList">[답글]
								<c:if test="${vo.replycount>0 }">
									(${vo.replycount })
								</c:if>
							</a>
						</c:if>
						<div class="messageBox" style="display:none; background-color:#eddef2ee; border-radius: 25px; box-shadow: #dadada 1px 1px 0px 0px; text-align:center; ">
							<!-- 답글 입력 폼  -->
							<div id="replyFrm${vo.gno }">
								<c:if test="${empty loginInfo.member_no}">
									<input type="text" placeholder="댓글은 로그인 후 작성 가능합니다." style="width: 70%" readonly>
								</c:if>
								<c:if test="${!empty loginInfo.member_no}">
									<input type="text" class="content2" style="width:70%" placeholder="답글을 작성해주세요." onkeyup="enterkey(${vo.gno })">
									<a href="javascript:goSave2(${vo.gno });">작성 </a>
								</c:if>
							</div>
							<!-- 답글 출력 -->
							<div id="replyList${vo.gno }"></div>
						</div>
					</td>
					<td>
					<c:if test="${loginInfo.member_no == vo.member_no }">
						<a href="javascript:setReply_no(${vo.reply_no });">[수정]</a>
						<a href="javascript:replyDel(${vo.reply_no });">[삭제]</a>
					</c:if>
					<a href="javascript:">
						<c:if test="${vo.islike == 0}">♡</c:if>
						<c:if test="${vo.islike != 0}">♥</c:if>
					</a>
					
					</td>
					<td class="date">
						<c:if test="${empty vo.reply_updatedate }">
							<fmt:formatDate value="${vo.reply_writedate }" pattern="yyyy-MM-dd HH:mm:ss" />
						</c:if>
						<c:if test="${!empty vo.reply_updatedate }">
							<fmt:formatDate value="${vo.reply_updatedate }" pattern="yyyy-MM-dd HH:mm:ss" /> 수정됨
						</c:if>
					</td>
				</tr>
			
			</c:forEach>
		</c:if>
	</tbody>
</table>
<!-- 댓글 페이징 처리 -->
<div class="pagenate clear">
	<ul class='paging'>
		<c:if test="${reply.prev==true }">
			<a href="javascript:getReply(${reply.startPage-1 });"></a>
		</c:if>
		<c:forEach var="p" begin="${reply.startPage }" end="${reply.endPage }">
			<a href="javascript:getReply(${p });" class="${replyVO.page == p? 'current' : '' }">${p }</a>
		</c:forEach>
		<c:if test="${reply.next==true }">
			<a href="javascript:getReply(${reply.endPage+1 });">></a>
		</c:if>
	</ul>
	<!-- 댓글 수정한 후 수정댓글에 해당하는 페이지 불러오기 위해 page값을 hidden으로 넘김 -->
	<input type="hidden" id="page" value="${page }">
</div>
<div style="height: 60px;background: white;"></div>
<script>
//답글 누르면 답글 보였다 숨기기
$('.replyList').click(function () {
	$(this).next().toggle();
})

//해당 댓글에 달린 답글 출력
function replyList(gno) {
	$.ajax({
		url: "/dataro/reply/replyList.do",
		data: {
			board_no: ${ replyVO.board_no },
			board_name : '${replyVO.board_name}',
			gno : gno,
			member_no : login_member_no
		},
		success: function(res) {
			var html = "";
			
			if (res.length == 0) {
				html += "등록된 답글이 없습니다.";
			} else {
				if (${!empty loginInfo.member_no }) {
					for (i = 0; i < res.length; i++) {
						html += "<table border='1' style='width: 800px'>";
						html += "	<tr>";
						html += "		<td style='text-align:center; width:20%;'>" ;
						html += "			<a class='btn-sendclick' href='javascript:message(" + res[i].member_no + ",`" + res[i].member_id + "`)'>"+ res[i].member_id +"<img src='/resources/dataro/img/message.png' title='쪽지 보내기'></a></td>";
						html += "		<td style='text-align:center; width:60%;'>" + res[i].content;
						if (login_member_no == res[i].member_no) {
							html += "		<a href='javascript:replyDel(" + res[i].reply_no + ");'>[삭제]</a></td>";
						}
						html += " 		<td style='text-align:center;width:20%;'>" + res[i].reply_w_str + "</td>";
						
						html += "	</tr>";
					}
					html += "</table>";
				} else {
					for (i = 0; i < res.length; i++) {
						html += "<table border='1' style='width: 800px'>";
						html += "	<tr>";
						html += "		<td style='text-align:center; width:20%;'>" ;
						html += "			<a class='btn-sendclick' href='javascript:Gologin()'>" + res[i].member_id + "<img src='/resources/dataro/img/message.png' title='쪽지 보내기'></a></td>";
						html += "		<td style='text-align:center; width:60%;'>" + res[i].content;
						if (login_member_no == res[i].member_no) {
							html += "		<a href='javascript:replyDel(" + res[i].reply_no + ");'>[삭제]</a></td>";
						}
						html += "		<td style='text-align:center;width:20%;'>" + res[i].reply_w_str + "</td>";
						
						html += "	</tr>";
					}
					html += "</table>";
				}
			}
			$("#replyList" + gno).html(html);
		},
		error: function(e) {
			console.log(e);
			console.log("replyList error");
		}
	});
}

//답글 작성
function goSave2(gno) {
	//console.log($("#replyFrm" + gno + " .content2").val());
	//console.log(gno);
	if (confirm('댓글을 작성하시겠습니까?')) {
		$.ajax({
			url: "/dataro/reply/reply.do",
			data: {
				board_no: ${ replyVO.board_no },
				board_name : '${replyVO.board_name}',
				content : $("#replyFrm" + gno + " .content2").val(),
				gno : gno,
				member_no : login_member_no,
				member_id : '${loginInfo.id}'
			},
			success: function(res) {
				if (res == "success") {
					alert('댓글이 정상적으로 등록되었습니다.');
				} else {
					alert('댓글 등록 실패');
				}
				getReply(1); //댓글 저장후 1페이지 다시 불러옴
				$("#replyFrm" + gno + " .content2").val('');
			
			},
			error: function(e) {
				console.log(e);
				console.log("Gosave2 error");
			}
		
		});
	}
}
</script>