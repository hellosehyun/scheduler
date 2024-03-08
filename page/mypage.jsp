<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>


<%
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
    
    // 내 정보 가져오기
    ResultSet result = connect.prepareStatement("SELECT id, pw, name, email, rank, department FROM account WHERE idx = " + account_idx).executeQuery();
    result.next();
    String info = "{";
    info += "id" + ":" + "\"" + result.getString(1) + "\"" + ",";
    info += "pw" + ":" + "\"" + "*".repeat(result.getString(2).length()) + "\"" + ",";
    info += "name" + ":" + "\"" + result.getString(3) + "\"" + ",";
    info += "email" + ":" + "\"" + result.getString(4) + "\"" + ",";
    info += "rank" + ":" + "\"" + result.getString(5) + "\"" + ",";
    info += "department" + ":" + "\"" + result.getString(6) + "\"" + "}";
%>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../style/init.css">
    <link rel="stylesheet" href="../style/mypage.css">
</head>

<body class="mypage-body">
    <div class="mypage-box">
        <a href="/scheduler.jsp" class="mypage-box-title">
            <span>스케</span><span class="mypage-box-title-lightBlue">줄러</span>
        </a>
        <button id="back" class="mypage-box-back">스케줄러 페이지로 돌아가기</button>
        <div class="mypage-box-subtitle">내 정보</div>
        <div class="mypage-box-info">
            <div class="mypage-box-info-item">
                <div class="mypage-box-info-item-left">
                    이름
                </div>
                <div class="mypage-box-info-item-right" id="name">
                    홍길동
                </div>
            </div>
            <div class="mypage-box-info-item">
                <div class="mypage-box-info-item-left">
                    이메일
                </div>
                <div class="mypage-box-info-item-right" id="email">
                </div>
            </div>
            <div class="mypage-box-info-item">
                <div class="mypage-box-info-item-left">
                    아이디
                </div>
                <div class="mypage-box-info-item-right" id="id">
                </div>
            </div>
            <div class="mypage-box-info-item">
                <div class="mypage-box-info-item-left">
                    비밀번호
                </div>
                <div class="mypage-box-info-item-right" id="pw">
                </div>
            </div>
            <div class="mypage-box-info-item">
                <div class="mypage-box-info-item-left">
                    부서
                </div>
                <div class="mypage-box-info-item-right" id="department">
                </div>
            </div>
            <div class="mypage-box-info-item">
                <div class="mypage-box-info-item-left">
                    직급
                </div>
                <div class="mypage-box-info-item-right" id="rank">
                </div>
            </div>
        </div>
        <div class="mypage-box-manage">
            <button class="mypage-box-manage-delete" id="delete">회원 탈퇴</button>
            <button class="mypage-box-manage-edit" id="edit">수정</button>
        </div>
    </div>
</body>

<script>
    var info = <%=info%>

    var rankTable = {
        leader : "팀장",
        member : "팀원"
    }
    var departmentTable = {
        design : "디자인팀",
        plan : "기획팀"
    }

    document.getElementById("id").innerText = info.id
    document.getElementById("pw").innerText = info.pw
    document.getElementById("email").innerText = info.email
    document.getElementById("name").innerText = info.name
    document.getElementById("department").innerText = departmentTable[info.department]
    document.getElementById("rank").innerText = rankTable[info.rank]

    document.getElementById("delete").addEventListener("click", function() {
        if(confirm("정말 탈퇴하시겠습니까?")) {
            location.href = "/action/actionDeleteAccount.jsp"
        }
    })
    document.getElementById("edit").addEventListener("click", function() {
        location.href = "/mypageEdit.jsp"
    })
    document.getElementById("back").addEventListener("click", function() {
        location.href = "/scheduler.jsp"
    })
</script>

</html>