/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/9.0.87
 * Generated at: 2024-07-02 05:53:46 UTC
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
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

public final class signup_jsp extends org.apache.jasper.runtime.HttpJspBase
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
    _jspx_imports_classes = new java.util.LinkedHashSet<>(4);
    _jspx_imports_classes.add("java.io.PrintWriter");
    _jspx_imports_classes.add("org.json.JSONObject");
    _jspx_imports_classes.add("java.security.MessageDigest");
    _jspx_imports_classes.add("java.security.NoSuchAlgorithmException");
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

    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    String travel_pw = request.getParameter("travel_pw");
    String agency_name = request.getParameter("agency_name");

    // SHA-256 해시 생성
    String hashedPassword = null;
    try {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(travel_pw.getBytes("UTF-8"));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        hashedPassword = hexString.toString();
    } catch (Exception e) {
        jsonResponse.put("success", false);
        jsonResponse.put("error_message", "Password hashing failed.");
        outWriter.print(jsonResponse.toString());
        return;
    }
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        // agency_name으로 agency_id 조회
        String queryAgencyId = "SELECT agency_id FROM travel_info_list WHERE agency_name = ?";
        ps = conn.prepareStatement(queryAgencyId);
        ps.setString(1, agency_name);
        rs = ps.executeQuery();

        if (rs.next()) {
            String agency_id = rs.getString("agency_id");

            // travel_member_list에 데이터 삽입
            String sql = "INSERT INTO travel_member_list(travel_email, travel_pw, travel_name, travel_tel, agency_id) VALUES(?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, request.getParameter("travel_email"));
            ps.setString(2, hashedPassword);
            ps.setString(3, request.getParameter("travel_name"));
            ps.setString(4, request.getParameter("travel_tel"));
            ps.setString(5, agency_id);

            ps.executeUpdate();

            jsonResponse.put("success", true);
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("error_message", "Invalid agency name.");
        }
    } catch (Exception e) {
        jsonResponse.put("success", false);
        jsonResponse.put("error_message", e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        outWriter.print(jsonResponse.toString());
    }

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
