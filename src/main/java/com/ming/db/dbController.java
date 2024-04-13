package com.ming.db;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;


/**
 * Servlet implementation class dbController
 */
@WebServlet("/dbController")
public class dbController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	private Statement stmt1;
	private ResultSet rs1;
	private static final String SELECT = "SELECT";
	private static final String INSERT = "INSERT";
	private static final String UPDATE = "UPDATE";

	ExternalDbConn dbconn = ExternalDbConn.getInstance();
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public dbController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		JSONObject jsonObj = new JSONObject();
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		try{
			
			String query = request.getParameter("query");

			if(query != null) {
				stmt1 = dbconn.getStmt();
				
				if(query.toUpperCase().startsWith(SELECT)) {
					rs1 = stmt1.executeQuery(query);
					ResultSetMetaData rsmd = rs1.getMetaData();
					
					// 쿼리의 열(컬럼) 개수 ex) bbs의 경우 id,title,owner,content,create_date,category 6개
					int columnCount = rsmd.getColumnCount();
					
//					JSONArray array = new JSONArray();
					List<HashMap<String,Object>> array = new ArrayList<HashMap<String,Object>>();
					List<String> headers = new ArrayList<String>();

					// 밑에선 로우별로 다 도니까 header만 따로 빼서 순차적으로 보내기
					// 한번에 보내도 되는데 header를 따로 빼주는 이유 - List는 순서있는 목록이나 HashMap은 순서 없는 목록이기 때문
					for(int i=1; i <= columnCount; i++)  {
						// 각 컬럼의 이름을 headers list에 담기
						String name = rsmd.getColumnName(i);
						headers.add(name);
					}
					
					// 각로우마다 돌면서 컬럼명:값의 형태로 HashMap에 담아 List에 순차적으로 저장해줌
					while(rs1.next()){
						HashMap<String, Object> obj = new HashMap<String, Object>();
						// JSONObject obj = new JSONObject();
						
						for(int i=1; i <= columnCount; i++)  {
							
							String name = rsmd.getColumnName(i);
							
							obj.put(name,rs1.getObject(i) + "");
						}
						
						array.add(obj);
						
					}
							
					jsonObj.put("list", array);
					jsonObj.put("headers", headers);
					
					// JSONObject(jsonObj) 객체를 PrintWriter를(out) 사용하여 JSON 형식의 응답 화면에 출력하기
					out.print(jsonObj);
				    
					
				}else if(query.toUpperCase().startsWith(INSERT)){
					int result = stmt1.executeUpdate(query);
					dbconn.getConn().commit();
					System.out.println("인서트 성공");
					
					jsonObj.put("result", result);
					out.print(jsonObj);
					
				}else if(query.toUpperCase().startsWith(UPDATE)) {
					if(!query.toUpperCase().contains("WHERE")) {
						System.out.println("UPDATE구문의 WHERE 조건 필수 작성 요망");
					}else {
						int result = stmt1.executeUpdate(query);
						dbconn.getConn().commit();
						System.out.println("업데이트 성공");
						
						jsonObj.put("result", result);
						out.print(jsonObj);
					}
				}
			}

		}catch(SQLException ee){
			try {
				dbconn.getConn().rollback();
				
			} catch (SQLException e) {
				e.printStackTrace();
				
			}

			jsonObj.put("msg", ee.getMessage());
			out.print(jsonObj);
			System.out.println(ee.toString());
			
		}
	}
	

}
