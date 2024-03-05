<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>

<% 
    try{
        request.setCharacterEncoding("utf-8");

        String id = request.getParameter("id"); 
        String pw = request.getParameter("pw");
        String pwConfirm = request.getParameter("pwConfirm");
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String department = request.getParameter("department");
        String rank = request.getParameter("rank");

        // 유효성 체크
        if(!id.matches("^[a-zA-Z0-9]{1,20}$")){
            throw new Exception("유효하지 않은 아이디");
        }
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
        String sql = "SELECT id, email FROM account WHERE id = ? OR email = ?;";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, id);
        query.setString(2, email);
        ResultSet result = query.executeQuery();

        if(result.next()){
            if(result.getString(1).equals(id)){
                throw new Exception("해당 아이디의 계정이 이미 존재");
            }
            if(result.getString(2).equals(email)){
                throw new Exception("해당 이메일의 계정이 이미 존재");
            }
        }

        String insertSql = "INSERT INTO account (id, pw, name, email, rank, department) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement insertQuery = connect.prepareStatement(insertSql);
        insertQuery.setString(1, id);
        insertQuery.setString(2, pw);
        insertQuery.setString(3, name);
        insertQuery.setString(4, email);
        insertQuery.setString(5, rank);
        insertQuery.setString(6, department);
        insertQuery.executeUpdate();

        response.sendRedirect("/login.jsp");

    } catch (Exception error) {
        out.println("<script>alert('" + error.getMessage() + "')</script>");
        out.println("<script>history.back()</script>");
    }
%>