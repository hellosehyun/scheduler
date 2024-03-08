<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>

<% 
    try{
        request.setCharacterEncoding("utf-8");

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

        // 계정, 세션 삭제
        connect.prepareStatement("DELETE FROM account WHERE idx = " + account_idx).executeUpdate();
        session.invalidate();

        // 페이지 이동
        out.println("<script>location.href = '/login.jsp'</script>");
    } catch (Exception error) {
        out.println("<script>alert('" + error.getMessage() + "');</script>");
        out.println("<script>history.back()</script>");
    }
%>