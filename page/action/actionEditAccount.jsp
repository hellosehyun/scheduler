<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>


<% 
    try{
        request.setCharacterEncoding("utf-8");

        String pw = request.getParameter("pw");
        String pwConfirm = request.getParameter("pwConfirm");
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String department = request.getParameter("department");
        String rank = request.getParameter("rank");
        String account_idx = (String) session.getAttribute("account_idx");

        // 세션 체크
        if(account_idx == null){
            throw new Exception("로그인 세션 만료");
        }

        // 유효성 체크
         if (!pw.matches("^[a-zA-Z0-9!@#$%^&*()_+{}\\[\\]:;<>,.?~\\\\/\\-=|]{4,20}$")) {
            throw new Exception("유효하지 않은 비밀번호");
        }
        if(!pwConfirm.equals(pw)){
            throw new Exception("비밀번호 불일치");
        }
        if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,30}$")) {
            throw new Exception("유효하지 않은 이메일");
        }
        if(!name.matches("^[a-zA-Z가-힣]{1,10}$")){
            throw new Exception("유효하지 않은 이름");
        }
        List<String> departmentList = Arrays.asList("design", "plan");
        if(!departmentList.contains(department)){
            throw new Exception("유효하지 않은 부서");
        }
        List<String> rankList = Arrays.asList("member", "leader");
        if(!rankList.contains(rank)){
            throw new Exception("유효하지 않은 직급");
        }

        // 데이테베이스 연결
        Class.forName("com.mysql.jdbc.Driver");
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/scheduler", "sehyun", "sehyun6685@");

        // 해당 id, email 중복 계정 체크
        String sql = "UPDATE account SET pw = ?, email = ?, name = ?, department = ?, rank = ? WHERE idx = ?;";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, pw);
        query.setString(2, email);
        query.setString(3, name);
        query.setString(4, department);
        query.setString(5, rank);
        query.setString(6, account_idx);
        query.executeUpdate();

        out.println("<script>location.href='/mypage.jsp'</script>");
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