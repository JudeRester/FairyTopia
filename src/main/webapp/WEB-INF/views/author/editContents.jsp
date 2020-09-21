<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css"
	rel="stylesheet">

<!-- summernote reference -->
<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<!-- include summernote-ko-KR -->
<script src="/resources/js/summernote-ko-KR.js"></script>
<!-- summer note end -->
<script>
	$(document).ready(
			function() {
				$.urlParam = function(name) {
					var results = new RegExp('[\?&]' + name + '=([^&#]*)')
							.exec(window.location.href);
					if (results == null) {
						return null;
					} else {
						return results[1] || 0;
					}
				}
			
				getInfo();
				getPages();
				
				$('#summernote').summernote({
					height : 1280 / 3 * 2,
					width : 1280,
					focut : true,
					lang : 'ko-kr'
				});
				load();
				function snImageUpload(file, editor) {
					data = new FormData();
					data.append("file", file);
					data.append("path", path);
					$.ajax({
						data : data,
						type : "POST",
						url : "summernoteImageUpload",
						contentType : false,
						processData : false,
						success : function(data) {
							$(editor).summernote('insertImage',
									data.url);
							path = data.path;
						}
					});
				}
				
				$('#saveInfo').click(function() {
					var dto = $('#cwpForm').serialize();
					dto = dto + '&workplace_id=' + $.urlParam('workplace_id');
					console.log(dto);
					$.ajax({
						url : '/author/updateInfo',
						type : 'post',
						data : dto,
						success : function(data) {
							$('#myModal').modal('toggle');
						},
						error : function() {
							console.log("실패");
						}
					});
				});

				$('#addPage').click(function(){
					key =parseInt($('#addPage').children().val())+1;
					dto = {workplace_id : $.urlParam('workplace_id'),
							pageNum : key};
					$.ajax({
						url : '/author/newPage',
						type : 'post',
						data : dto,
						success : function(data) {
							str = '<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">'
								 +'<!-- 페이지 --><div class="panel panel-default">'
								 +'<div class="panel-heading" role="tab" id="heading'+key+'">'
								 +'<h4 class="panel-title"><!-- 페이지 번호 -->'
								 +'<a data-toggle="collapse" data-parent="#accordion" href="#collapse'+key+'"'
								 +' aria-expanded="true" aria-controls="collapse'+key+'">'+key+'페이지</a>';
							$('#page-list').append(str);
							$('#addPage').children().val(key)
							$('#no-page').remove();
						},
						error : function() {
							console.log("실패");
						}
					});
					
				});
			});

	function getInfo() {
		var data = {
			workplace_id : $.urlParam('workplace_id')
		};
		$.ajax({
			data : data,
			type : "post",
			url : "/author/getInfo",
			success : function(data) {
				if ($.isEmptyObject(data)) {
					$('#myModal').modal();
				} else {
					$('#fairytale_name').val(data.fairytale_name);
					$('#fairytale_detail').val(data.fairytale_detail);
				}
			}
		});
	}

	function getPages() {
		var data = {
			workplace_id : $.urlParam('workplace_id')
		};
		$.ajax({
			data : data,
			type : "post",
			url : "/author/getWorkingPages",
			success : function(data) {
				$('#page-list').empty();
				console.log("start page file list");
				if ($.isEmptyObject(data)) {
					$('#page-list').html(
							'<p id="no-page">페이지가 없습니다.</p>');
				} else {
					$.each(data,function(key, value) {
						str = '<div class="panel-group" id="accordion" role="tablist"	aria-multiselectable="true">'
								+ '<!-- 페이지 --><div class="panel panel-default"><div class="panel-heading" role="tab" id="heading'+key+'">'
								+ '<h4 class="panel-title">'
								+ '<!-- 페이지 번호 --><a data-toggle="collapse" data-parent="#accordion" href="#collapse'+key+
								+'" aria-expanded="true" aria-controls="collapse'+key+'">'
								+ key
								+ '페이지</a> <label for="page_'+key+'">';
						$('#addPage').children().val(key);
						str = str + '</div></div>';
						$('#page-list').append(str);
					});
				}
				console.log("end page file list");
			}
		});
	};

	function load(){
		dto = {workplace_id : $.urlParam('workplace_id'),
				pageNum : $.urlParam('page')};
		$.ajax({
			data : dto,
			type : "post",
			url : "/author/loadPage",
			success : function(data){
				$('.note-editable').html(data);
				}
			});
		}
</script>
<style>
.page {
	padding-bottom: 10px;
}

#page-list{
   overflow-y: scroll;
   width: 190px; 
   height: 870px;
}

#page-list {
	-ms-overflow-style: none;
}
#page-list::-webkit-scrollbar{
 	display:none; 
}



.page b {
	color: gray;
}

.set {
	border: 1px solid #cecece;
	text-align: center;
	margin-left: 50px;
}

.set a {
	color: #5c5c5c;
	text-decoration: none;
	font-size: 20px;
}

.set a:hover {
	color: #5c5c5c;
	text-decoration: none;
}

#myModal {
	padding-top: 200px;
}

.modal-body .form-group {
	margin-bottom: 20px;
}

.modal-footer a {
	color: black;
	text-decoration: none;
}

.modal-footer a:hover {
	text-decoration: none;
}
#header{
	margin:30px;
}
</style>
</head>
<body>
	<div class="container" style="margin: 0px;">
		<div class="row" id="header">
			<div class="col-xs-1">
				<a href="" class="btn btn-default" role="button"> <b>편집내용 저장</b>
				</a>
			</div>
			<div class="col-xs-2 text-center">
				<a href="" class="btn btn-default" role="button"> <b>투고하기</b>
				</a>
			</div>

			<div class="col-xs-8 set">
				<a href="" class="btn btn-link" role="button" data-toggle="modal"
					data-target="#myModal"> 기본정보 설정 </a>
			</div>
		</div>

		<hr />

		<div class="row" >
			<div class="col-xs-2">
				<div class="page">
					<a href="#" class="btn btn-default" role="button" id="addPage">
						<input type='hidden' value='-1' /> <b>페이지 추가</b>
					</a>
				</div>

				<div id="page-list">페이지가 없습니다</div>
				<!--panel-group-->
			</div>

			<div class="col-xs-9">
				<div class="edit">
					<textarea name="content" id="summernote"></textarea>
				</div>
			</div>
		</div>

		<hr />

	</div>

	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">

				<div class="modal-header text-center">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4>도서 기본정보 설정</h4>
				</div>

				<form class="form-horizontal" id="cwpForm">
					<div class="modal-body">
						<div class="form-group">
							<label for="inputname" class="col-sm-3 control-label"> 동화
								제목 </label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="fairytale_name"
									name="fairytale_name" placeholder="동화 제목을 기입해주세요.">
							</div>
						</div>

						<div class="form-group">
							<label for="inputtext" class="col-sm-3 control-label"> 동화
								줄거리 </label>
							<div class="col-sm-8">
								<textarea class="form-control" id="fairytale_detail"
									name="fairytale_detail" placeholder="동화 줄거리를 기입해주세요."></textarea>
							</div>
						</div>

						<!-- <div class="form-group">
							<label for="inputtext" class="col-sm-3 control-label">장르</label>
							<div class="col-sm-4">
								<div class="dropdown">
									<button class="btn btn-default dropdown-toggle" type="button"
										id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
										장르 <span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu"
										aria-labelledby="dropdownMenu">
										<li role="presentation"><a role="menuitem" tabindex="-1"
											href="#">전래동화</a></li>
										<li role="presentation"><a role="menuitem" tabindex="-1"
											href="#">환상동화</a></li>
										<li role="presentation"><a role="menuitem" tabindex="-1"
											href="#">생활동화</a></li>
										<li role="presentation"><a role="menuitem" tabindex="-1"
											href="#">학습동화</a></li>
										<li role="presentation"><a role="menuitem" tabindex="-1"
											href="#">활동그림책</a></li>
									</ul>
								</div>
							</div>
						</div> -->
					</div>
				</form>

				<div class="modal-footer">
					<a href="#" id="saveInfo">
						<h4 class="text-center">
							<b>저장</b>
						</h4>
					</a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>