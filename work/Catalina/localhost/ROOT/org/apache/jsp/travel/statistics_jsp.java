/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/9.0.87
 * Generated at: 2024-07-16 01:14:09 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.travel;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;
import org.json.JSONObject;
import org.json.JSONArray;
import java.io.PrintWriter;
import java.sql.*;

public final class statistics_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(1);
    _jspx_dependants.put("/travel/../db_connect.jsp", Long.valueOf(1715653235823L));
  }

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.LinkedHashSet<>(4);
    _jspx_imports_packages.add("java.sql");
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = new java.util.LinkedHashSet<>(3);
    _jspx_imports_classes.add("java.io.PrintWriter");
    _jspx_imports_classes.add("org.json.JSONObject");
    _jspx_imports_classes.add("org.json.JSONArray");
  }

  private volatile javax.el.ExpressionFactory _el_expressionfactory;
  private volatile org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public java.util.Set<java.lang.String> getPackageImports() {
    return _jspx_imports_packages;
  }

  public java.util.Set<java.lang.String> getClassImports() {
    return _jspx_imports_classes;
  }

  public javax.el.ExpressionFactory _jsp_getExpressionFactory() {
    if (_el_expressionfactory == null) {
      synchronized (this) {
        if (_el_expressionfactory == null) {
          _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
        }
      }
    }
    return _el_expressionfactory;
  }

  public org.apache.tomcat.InstanceManager _jsp_getInstanceManager() {
    if (_jsp_instancemanager == null) {
      synchronized (this) {
        if (_jsp_instancemanager == null) {
          _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
        }
      }
    }
    return _jsp_instancemanager;
  }

  public void _jspInit() {
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
      throws java.io.IOException, javax.servlet.ServletException {

    if (!javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
      final java.lang.String _jspx_method = request.getMethod();
      if ("OPTIONS".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        return;
      }
      if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSP들은 오직 GET, POST 또는 HEAD 메소드만을 허용합니다. Jasper는 OPTIONS 메소드 또한 허용합니다.");
        return;
      }
    }

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("application/json; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write('\n');
      out.write('\n');
      out.write('\n');
      out.write('\n');

Connection conn = null;
String url = "jdbc:mariadb://localhost:3306/occ";
String id = "root";                     //MySQL에 접속을 위한 계정의 ID
String pwd = "1234";            //MySQL에 접속을 위한 계정의 암호
try{
Class.forName("org.mariadb.jdbc.Driver");
conn = DriverManager.getConnection(url, id, pwd);
}catch(Exception e){
e.printStackTrace();
}

      out.write('\n');
      out.write('\n');

    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");
    PrintWriter outWriter = response.getWriter();

    String to_date = request.getParameter("to_date");
    String from_date = request.getParameter("from_date");
    int agency_id = Integer.parseInt(request.getParameter("agency_id"));

    JSONObject jsonResponse = new JSONObject();
    JSONArray listArray = new JSONArray();

    try {
        String sqlQuery = "SELECT " +
                "COUNT(reservation_id) AS total_reservations, " +
"COUNT(CASE WHEN hotel_reservation_status != 3 AND travel_reservation_status != 3 AND NOT (hotel_reservation_status = 2 AND travel_reservation_status = 2) THEN 1 ELSE NULL END) AS active_reservations, " +
                "COUNT(CASE WHEN hotel_reservation_status = 2 AND travel_reservation_status = 2 THEN 1 ELSE NULL END) AS confirmed_reservations, " +
                "COUNT(CASE WHEN hotel_reservation_status = 3 OR travel_reservation_status = 3 THEN 1 ELSE NULL END) AS canceled_reservations, " +
                "FORMAT(ROUND(SUM(CASE WHEN hotel_reservation_status != 3 AND travel_reservation_status != 3 THEN hotel_price ELSE 0 END), 2), 'N2') AS total_price, " +
                "SUM(CASE WHEN hotel_reservation_status != 3 AND travel_reservation_status != 3 THEN night_count ELSE 0 END) AS total_night_count " +
                "FROM inquiry_info_list " +
                "WHERE check_out_date BETWEEN ? AND ? " +
                "AND agency_id = ?;";
        
        try (PreparedStatement ps = conn.prepareStatement(sqlQuery)) {
            ps.setString(1, from_date);
            ps.setString(2, to_date);
            ps.setInt(3, agency_id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    jsonResponse.put("total_reservations", rs.getInt("total_reservations"));
                    jsonResponse.put("active_reservations", rs.getInt("active_reservations"));
                    jsonResponse.put("confirmed_reservations", rs.getInt("confirmed_reservations"));
                    jsonResponse.put("canceled_reservations", rs.getInt("canceled_reservations"));
                    jsonResponse.put("total_price", rs.getString("total_price") != null ? rs.getString("total_price") : "0");
                    jsonResponse.put("total_night_count", rs.getInt("total_night_count"));
                }
            }
        }

        sqlQuery = "SELECT " +
                "a.hotel_id, " +
                "b.hotel_name, " +
                "COUNT(CASE WHEN a.travel_reservation_status = 2 AND a.hotel_reservation_status = 2 THEN 1 ELSE NULL END) AS confirm, " +
        "COUNT(CASE WHEN hotel_reservation_status != 3 AND travel_reservation_status != 3 AND NOT (hotel_reservation_status = 2 AND travel_reservation_status = 2) THEN 1 ELSE NULL END) AS active_reservations, " +
                "COUNT(a.reservation_id) AS total_reservations, " +
                "COUNT(CASE WHEN a.travel_reservation_status = 3 OR a.hotel_reservation_status = 3 THEN 1 ELSE NULL END) AS cancel, " +
                "FORMAT(ROUND(SUM(CASE WHEN a.hotel_reservation_status != 3 AND a.travel_reservation_status != 3 THEN a.hotel_price ELSE 0 END), 2), 'N2') AS total_price, " +
                "SUM(CASE WHEN a.hotel_reservation_status != 3 AND a.travel_reservation_status != 3 THEN a.night_count ELSE 0 END) AS total_room_nights " +
                "FROM inquiry_info_list a " +
                "INNER JOIN hotel_info_list b ON a.hotel_id = b.hotel_id " +
                "WHERE a.check_out_date BETWEEN ? AND ? " +
                "AND a.agency_id = ? " +
                "GROUP BY a.hotel_id, b.hotel_name;";
        
        try (PreparedStatement ps = conn.prepareStatement(sqlQuery)) {
            ps.setString(1, from_date);
            ps.setString(2, to_date);
            ps.setInt(3, agency_id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    JSONObject cancel = new JSONObject();
                    cancel.put("hotel_id", rs.getString("hotel_id"));
                    cancel.put("hotel_name", rs.getString("hotel_name"));
                    cancel.put("confirm", rs.getInt("confirm"));
                    cancel.put("active_reservations", rs.getInt("active_reservations"));
                    cancel.put("total_reservations", rs.getInt("total_reservations"));
                    cancel.put("cancel", rs.getInt("cancel"));
                    cancel.put("total_price", rs.getString("total_price") != null ? rs.getString("total_price") : "0");
                    cancel.put("total_room_nights", rs.getInt("total_room_nights"));
                    listArray.put(cancel);
                }
            }
        }
        jsonResponse.put("listArray", listArray);
        jsonResponse.put("success", true);
    } catch (Exception e) {
        e.printStackTrace();
        jsonResponse.put("success", false);
        jsonResponse.put("error", e.getMessage());
    } finally {
        outWriter.print(jsonResponse.toString());
        outWriter.close();
    }
    conn.close();

      out.write('\n');
      out.write('\n');
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
