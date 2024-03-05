<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%
    session.invalidate();
    out.println("<script>location.href = '/'</script>");
%>