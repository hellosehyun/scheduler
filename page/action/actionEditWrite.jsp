<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<% 
    try{
        request.setCharacterEncoding("utf-8");

        String date = request.getParameter("date"); 
        String time = request.getParameter("time");
        String content = request.getParameter("content");
        String schedule_idx = request.getParameter("idx");
        String account_idx = (String) session.getAttribute("account_idx");

        // 세션 체크
        if(account_idx == null){
            throw new Exception("로그인 세션 만료");
        }

        // 유효성 체크
        if (!date.matches("^\\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$")){
            throw new Exception("유효하지 않은 날짜");
        }
        if (!time.matches("^(0[0-9]|1[0-9]|2[0-3]):(0[1-9]|[0-5][0-9])$")) {
            throw new Exception("유효하지 않은 시간");
        }
        if (!content.matches("^.{1,30}$")) {
            throw new Exception("유효하지 않은 내용");
        }

        // 데이테베이스 연결
        Class.forName("com.mysql.jdbc.Driver");
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/scheduler", "sehyun", "sehyun6685@");

        // schedule의 account_idx 와 session의 account_idx 비교 및 데이터 추가
        String sql = "UPDATE schedule SET date = ?, time = ?, content = ? WHERE account_idx  = ? AND idx = ?";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, date);
        query.setString(2, time);
        query.setString(3, content);
        query.setString(4, account_idx);
        query.setString(5, schedule_idx);
        query.executeUpdate();

        // 페이지 이동
        out.println("<script>location.href = '/scheduler.jsp'</script>");
    } catch (Exception error) {
        if (error.getMessage().equals("로그인 세션 만료")){
            out.println("<script>alert('" + error.getMessage() + "');</script>");
            out.println("<script>location.href = '/'</script>");
            return;
        }
        else {
            out.println("<script>alert('" + error.getMessage() + "')</script>");
            out.println("<script>history.back()</script>");
            return;
        }
    }
%>