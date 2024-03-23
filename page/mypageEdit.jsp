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
    ResultSet result = connect.prepareStatement("SELECT name, email, rank, department FROM account WHERE idx = " + account_idx).executeQuery();
    result.next();
    String info = "{";
    info += "name" + ":" + "\"" + result.getString(1) + "\"" + ",";
    info += "email" + ":" + "\"" + result.getString(2) + "\"" + ",";
    info += "rank" + ":" + "\"" + result.getString(3) + "\"" + ",";
    info += "department" + ":" + "\"" + result.getString(4) + "\"" + "}";
%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../style/init.css">
    <link rel="stylesheet" href="../style/mypageEdit.css">
</head>

<body class="mypageEdit-body">
    <div class="mypageEdit-box">
        <a href="/scheduler.jsp" class="mypageEdit-box-title">
            <span>스케</span><span class="mypageEdit-box-title-lightBlue">줄러</span>
        </a>
        <div class="mypageEdit-box-subhead">내 정보</div>
        <div class="mypageEdit-box-item">
            <div class="mypageEdit-box-item-left">이름</div>
            <input id="name" placeholder="이름을 입력해주세요"  class="mypageEdit-box-item-right" type="text">
        </div>
        <div class="mypageEdit-box-item">
            <div class="mypageEdit-box-item-left">이메일</div>
            <input id="email" placeholder="이메일을 입력해주세요" type="email" class="mypageEdit-box-item-right">
        </div>
        <div class="mypageEdit-box-item">
            <div class="mypageEdit-box-item-left">비밀번호</div>
            <input id="pw" placeholder="비밀번호를 입력해주세요" class="mypageEdit-box-item-right" type="password">
        </div>
        <div class="mypageEdit-box-item">
            <div class="mypageEdit-box-item-left">비밀번호 확인</div>
            <input id="pwConfirm" placeholder="비밀번호를 다시 입력해주세요" class="mypageEdit-box-item-right" type="password">
        </div>
        <div class="mypageEdit-box-item">
            <div class="mypageEdit-box-item-left">부서</div>
            <select class="mypageEdit-box-item-right" id="department">
                <option value="design">디자인팀</option>
                <option value="plan">기획팀</option>
            </select>
        </div>
        <div class="mypageEdit-box-item">
            <div class="mypageEdit-box-item-left">직급</div>
            <select class="mypageEdit-box-item-right" id="rank">
                <option value="member">팀원</option>
                <option value="leader">팀장</option>
            </select>
        </div>
        <div class="mypageEdit-box-manage">
            <button class="mypageEdit-box-manage-cancel" id="cancel">취소</button>
            <button class="mypageEdit-box-manage-save" id="save">저장</button>
        </div>
    </div>
</body>

<script>
    function validateData(pw, pwConfirm, email, name, department, rank) {
        var pwRegex = /^[a-zA-Z0-9!@#$%^&*()_+{}[\]:;<>,.?~\\/\-=|]{8,20}$/
        var emailRegex = /^(?=.{1,30}$)[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
        var nameRegex = /^[a-zA-Z가-힣]{2,10}$/

        if(!pwRegex.test(pw)){
            alert("유효하지 않은 비밀번호 (8자 ~ 20자)")
            return false
        }
        if(pw !== pwConfirm){
            alert("비밀번호 불일치")
            return false
        }
        if(!emailRegex.test(email)){
            alert("유효하지 않은 이메일")
            return false
        }
        if(!nameRegex.test(name)){
            alert("유효하지 않은 이름 (2자 ~ 10자)")
            return false
        }
        if(!['design', 'plan'].includes(department)){
            alert("유효하지 않은 부서")
            return false
        }
        if(!['leader', 'member'].includes(rank)){
            alert("유효하지 않은 직급")
            return false
        }
        return true
    }

    var info = <%=info%>

    document.getElementById("name").value = info.name
    document.getElementById("email").value = info.email
    document.getElementById("department").options.selectedIndex = Array.from(document.getElementById("department").children).findIndex((i) => i.value === info.department)
    document.getElementById("rank").options.selectedIndex = Array.from(document.getElementById("rank").children).findIndex((i) => i.value === info.rank)

    document.getElementById("save").addEventListener("click", function() {
        var pw = document.getElementById("pw").value
        var pwConfirm = document.getElementById("pwConfirm").value
        var email = document.getElementById("email").value
        var name = document.getElementById("name").value
        var department = document.getElementById("department").value
        var rank = document.getElementById("rank").value

        if(validateData(pw, pwConfirm, email, name, department, rank)){
            location.href = "/action/actionEditAccount.jsp?pw=" + pw + "&pwConfirm=" + pwConfirm + "&email=" + email + "&name=" + name + "&department=" + department + "&rank=" + rank
        }
    })
    document.getElementById("cancel").addEventListener("click", function() {
        location.href = "/mypage.jsp"
    })
</script>

</html>