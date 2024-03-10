<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%
    String account_idx = (String) session.getAttribute("account_idx");

    if(account_idx == null){
        out.println("<script>location.href = '/login.jsp'</script>");
    }
    else{
        out.println("<script>location.href = '/scheduler.jsp'</script>");
    }
%>