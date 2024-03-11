<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<% 
    try{
        request.setCharacterEncoding("utf-8");

        String email = request.getParameter("email"); 
        String id = request.getParameter("id");

        if(!email.matches("^[^\\s]+$")){
            throw new Exception("이메일 입력 필수");
        }
        if(!id.matches("^[^\\s]+$")){
            throw new Exception("아이디 입력 필수");
        }

        // 데이테베이스 연결
        Class.forName("com.mysql.jdbc.Driver");
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/scheduler", "sehyun", "sehyun6685@");

        // 해당 email, id 의 계정 체크
        String sql = "SELECT pw FROM account WHERE email=? AND id=?;";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, email);
        query.setString(2, id);
        ResultSet result = query.executeQuery();

        if(!result.next()){
            throw new Exception("계정 없음");
        }

        // 비밀번호 alert
        out.println("<script>alert('해당 계정의 비밀번호는 " + result.getString(1) + "입니다');</script>");

        // 페이지 이동
        out.println("<script>location.href = '/login.jsp'</script>");
    } catch (Exception error) {
        if (error.getMessage().equals("계정 없음")){
            out.println("<script>alert('" + error.getMessage() + "');</script>");
            out.println("<script>history.back()</script>");
            return;
        }
        else {
            out.println("<script>alert('" + error.getMessage() + "');</script>");
            out.println("<script>history.back()</script>");
            return;
        }
    }
%>