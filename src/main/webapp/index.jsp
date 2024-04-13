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
			
			// list 가 있으면 select
			if(data.list){
				// 먼저 리스트를 정의해
				const list = data.list;
				
				// 그리스트를 반복하면서 데이터를 먼저 만들어줘, 근데 여기서 우선 체크해야할게 헤더를 그려야겠지?
				let headers = data.headers;
				let headerHtml = '';
				let bodyHtml = '';
				 headerHtml = '<tr>';
				for(let i =0; i<headers.length; i++){
					headerHtml += '<th>' + headers[i] + '</th>';	
				}
				headerHtml += '</tr>';
				for(let i=0; i<list.length; i++){
					// 여기가 로우를 넣어준건가여?넹
					const obj = list[i];
					
						// 무조건 배열의 순서가 같다고 볼수 없기 때문에
						// 그 외엔 데이터를 만들어줘야쥬
						bodyHtml += '<tr>';
						for(idx in headers){
							// 헤더의 키값을 obj에서 꺼내서 넣는역할
							bodyHtml += '<td>' + obj[headers[idx]] + '</td>';
						}
						bodyHtml += '</tr>';
					
				}
				queryResult.empty();
				queryResult.html('<table>' + headerHtml + bodyHtml + '</table>');
				
			} else {
				// 없으면 insert , update, delete
				$("#queryResult").html('처리결과 : ' + data.result + '건');
			}
			
		},
		error : function(e) {
			console.log("여기같운데");
			console.log("{}", e);
			alert(e);
		}
	});

}

</script>

</head>



<body>

<p><font  color="#FF6600" size="5"><b>query</b></font>&nbsp;&nbsp;ver 1.2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:window.close()">닫기</a></p>

<form name="form1" methos="post" action="">

<table border="0" cellpadding="0" cellspacing="0">

<tr><td>

<textarea name="query" cols="80" rows="15"><%=request.getParameter("query")%></textarea><br>

<input type="button" value="       쿼리전송       " onClick="chk()">

</td>

<td width="50"></td>

<td valign="top" id="queryResult"><b><현재 쿼리 수행 내역></b><br>



</td></tr>

</table>

</form>


</body>

</html>