<%@page import="com.ming.db.ExternalDbConn"%>
<%@ page language="java" contentType="text/html; charset=euc-kr"

    pageEncoding="EUC-KR"%>

<%@ page import="java.util.*" %>

<%@ page import="java.sql.*" %>

<%@ page import="javax.sql.*" %>

<%@ page import="java.net.*" %>

<%@ page import="java.io.*"%>


<%

	ExternalDbConn dbconn = ExternalDbConn.getInstance();

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<title>query</title>

<script
  src="https://code.jquery.com/jquery-2.2.4.js"
  integrity="sha256-iT6Q9iMJYuQiMWNd9lDyBUStIq/8PuOW33aOqmvFpqI="
  crossorigin="anonymous">
</script>
<script>

// 	function chk(){

// 		var con = document.form1.query.value;



// 		if(con == ""){

// 			alert("쿼리문을 입력하세요~~");

// 			document.form1.query.focus();

// 			return;

// 		}

// 		document.form1.submit();

// 	}



function reset() {
	let queryResult = $("#queryResult");
	let queryText = $("#query");
	
	queryResult.empty();
	queryText.empty();
}

function chk() {

	let sqlQuery = $('textarea[name=query]').val();
	
	let param = {
		"query":sqlQuery,
	}
	
	console.log(param);
	$.ajax({
		url : "dbController",
		type : "POST",
		data : param,
		dataType : "json",
		success : function(data) {
			console.log(data);
			
			let queryResult = $("#queryResult");
			
			// list가 있으면 select
			if(data.list){
				// 먼저 리스트를 정의해
				const list = data.list;
				
				// 그 리스트를 반복하면서 데이터를 먼저 만들어줘, 근데 여기서 우선 체크해야할게 헤더를 그려야겠지?
				let headers = data.headers;
				let headerHtml = '';
				let bodyHtml = '';
				
				 headerHtml = '<tr">';
				for(let i =0; i<headers.length; i++){
					headerHtml += '<th style="border: 1px solid black; text-align:center;">' + headers[i] + '</th>';	
				}
				headerHtml += '</tr>';
				for(let i=0; i<list.length; i++){
					// 여기가 로우를 넣어준건가여?넹
					const obj = list[i];
					
						// 무조건 배열의 순서가 같다고 볼수 없기 때문에 headers에 있는 key값을 이용해 순서를 맞춰줌
						bodyHtml += '<tr">';
						for(idx in headers){
							// 헤더의 키값(id,title 등)을 obj에서 꺼내서 넣는역할 obj[key] -> value를 추출함
							bodyHtml += '<td style="border: 1px solid black; text-align:center;">' + obj[headers[idx]] + '</td>';
						}
						bodyHtml += '</tr>';
				}

				queryResult.empty();
				queryResult.html('<table>' + headerHtml + bodyHtml + '</table>');

			} else {
				if(data.result){
					// list가 없고 result가 있으면 insert , update, delete
					queryResult.html('처리결과 : ' + data.result + '건');
				}else {
					queryResult.html('에러 : ' + data.msg);
				}
			}
		},
		error : function(e) {
			console.log(e)
			alert("SQL 문법 오류");
			
		}
	});

}

</script>

</head>



<body>

<p>
	<font  color="#FF6600" size="5">
		<b>query</b>
	</font>
	<span>ver ming1.0</span>
</p>

<form name="form1" methos="post" action="">
	<table border="0" cellpadding="0" cellspacing="0">
	
	<tr>
		<td valign="top">
			<textarea name="query" cols="80" rows="15"><%=request.getParameter("query") != null ? request.getParameter("query") : ""%></textarea><br>
			<div style="display:flex; justify-content: space-between;">
				<input type="button" style="width:200px;" value="쿼리전송" onClick="chk()">
				<input type="button" style="width:200px;" value="초기화" onClick="reset()">
			</div>
		</td>
		<td width="50"></td>
		
		<td valign="top">
			<div>
				<b><쿼리 수행 내역></b><br>	
				<%=request.getParameter("query") != null ? request.getParameter("query") : ""%>
			</div>
			<div id="queryResult"></div>
			
		</td>
	</tr>
	
	</table>

</form>


</body>

</html>