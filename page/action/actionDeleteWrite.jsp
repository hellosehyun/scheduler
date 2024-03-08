<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<% 
    try{
        request.setCharacterEncoding("utf-8");

        String schedule_idx = request.getParameter("idx");
        String account_idx = (String) session.getAttribute("account_idx");

        // 세션 체크
        if(account_idx == null){
            out.println("<script>alert('로그인 세션 만료');</script>");
            out.println("<script>location.href = '/login.jsp'</script>");
            return;
        }

        // 데이테베이스 연결
        Class.forName("com.mysql.jdbc.Driver");
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/scheduler", "sehyun", "sehyun6685@");

        // schedule의 account_idx 와 session의 account_idx 비교 및 데이터 추가
        String sql = "DELETE FROM schedule WHERE account_idx = ? AND idx = ?";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, account_idx);
        query.setString(2, schedule_idx);
        query.executeUpdate();

        // 페이지 이동
        out.println("<script>location.href = '/scheduler.jsp'</script>");
    } catch (Exception error) {
        out.println("<script>alert('" + error.getMessage() + "');</script>");
        out.println("<script>history.back()</script>");
    }
%>