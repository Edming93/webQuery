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

// 			alert("�������� �Է��ϼ���~~");

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
			
			// list �� ������ select
			if(data.list){
				// ���� ����Ʈ�� ������
				const list = data.list;
				
				// �׸���Ʈ�� �ݺ��ϸ鼭 �����͸� ���� �������, �ٵ� ���⼭ �켱 üũ�ؾ��Ұ� ����� �׷��߰���?
				let headers = data.headers;
				let headerHtml = '';
				let bodyHtml = '';
				 headerHtml = '<tr>';
				for(let i =0; i<headers.length; i++){
					headerHtml += '<th>' + headers[i] + '</th>';	
				}
				headerHtml += '</tr>';
				for(let i=0; i<list.length; i++){
					// ���Ⱑ �ο츦 �־��ذǰ���?��
					const obj = list[i];
					
						// ������ �迭�� ������ ���ٰ� ���� ���� ������
						// �� �ܿ� �����͸� ����������
						bodyHtml += '<tr>';
						for(idx in headers){
							// ����� Ű���� obj���� ������ �ִ¿���
							bodyHtml += '<td>' + obj[headers[idx]] + '</td>';
						}
						bodyHtml += '</tr>';
					
				}
				queryResult.empty();
				queryResult.html('<table>' + headerHtml + bodyHtml + '</table>');
				
			} else {
				// ������ insert , update, delete
				$("#queryResult").html('ó����� : ' + data.result + '��');
			}
			
		},
		error : function(e) {
			console.log("���ⰰ�");
			console.log("{}", e);
			alert(e);
		}
	});

}

</script>

</head>



<body>

<p><font  color="#FF6600" size="5"><b>query</b></font>&nbsp;&nbsp;ver 1.2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:window.close()">�ݱ�</a></p>

<form name="form1" methos="post" action="">

<table border="0" cellpadding="0" cellspacing="0">

<tr><td>

<textarea name="query" cols="80" rows="15"><%=request.getParameter("query")%></textarea><br>

<input type="button" value="       ��������       " onClick="chk()">

</td>

<td width="50"></td>

<td valign="top" id="queryResult"><b><���� ���� ���� ����></b><br>



</td></tr>

</table>

</form>


</body>

</html>