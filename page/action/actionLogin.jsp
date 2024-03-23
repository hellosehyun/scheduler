<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<% 
    try{
        request.setCharacterEncoding("utf-8");

        String id = request.getParameter("id"); 
        String pw = request.getParameter("pw");

        if(!id.matches("^.{1,20}$")){
            throw new Exception("아이디 입력 필수 (최대 20자)");
        }
        if(!pw.matches("^.{1,20}$")){
            throw new Exception("비밀번호 입력 필수 (최대 20자)");
        }

        // 데이테베이스 연결
        Class.forName("com.mysql.jdbc.Driver");
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/scheduler", "sehyun", "sehyun6685@");

        // 해당 id, pw 유무 체크
        String sql = "SELECT idx, rank FROM account WHERE id=? AND pw=?;";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, id);
        query.setString(2, pw);
        ResultSet result = query.executeQuery();

        if(!result.next()){
            throw new Exception("계정 없음");
        }

        // session 지급
        String account_idx = result.getString(1);
        String account_rank = result.getString(2);
        session.setAttribute("account_idx", account_idx);
        session.setMaxInactiveInterval(60 * 30);

        // 페이지 이동
        out.println("<script>location.href = '/scheduler.jsp'</script>");
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