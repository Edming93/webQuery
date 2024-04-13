package com.ming.db;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

/**

 * @author Administrator

 *

 * To change the template for this generated type comment go to

 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments

 */

public class ExternalDbConn {

	private Connection conn;

	private ExternalDbConn() {

		try {
			Class.forName("org.mariadb.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Driver 검색 실패!");

			System.exit(-1);
		}

		try{
			conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/bbs1", "root", "1234");
		}catch(SQLException ee){
			System.out.println("Connection 객체 생성 실패!");

			System.exit(-1);
		}

	}

	public static ExternalDbConn getInstance() {
		return new ExternalDbConn();
	}

	public Connection getConn(){
		return conn;

	}

	public Statement getStmt(){
		Statement stmt = null;

		try{
			stmt = conn.createStatement();
		}catch(SQLException ee){
			System.out.println("Statement 객체 생성 실패!");
		}
		return stmt;
	}

	public PreparedStatement getPstmt(String query){
		PreparedStatement pstmt = null;
		try{
			pstmt = conn.prepareStatement(query);
		}catch(SQLException ee){
			System.out.println("PrepareStatement 객체 생성 실패!");
		}
		return pstmt;
	}

	public CallableStatement getCstmt(String procedure){
		CallableStatement cstmt = null;

		try{
			cstmt = conn.prepareCall(procedure);
		}catch(SQLException ee){
			System.out.println("CallableStatement 객체 생성 실패!");
		}
		return cstmt;

	}

	public void close(){
		if(conn != null){
			try{
				if(!conn.isClosed()){
					conn.close();
				}
			}catch(SQLException ee){
				System.out.println("Connection 객체 해제 실패!");
			}
			conn = null;
		}

	}

}