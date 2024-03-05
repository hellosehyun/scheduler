<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../style/init.css">
    <link rel="stylesheet" href="../style/login.css">
</head>

<body class="login-body">
    <form id="form" class="login-form" action="/action/actionLogin.jsp">
        <div class="login-form-title">로그인</div>
        <input class="login-form-input" name="id" id="id" placeholder="아이디를 입력해주세요" type="text">
        <input class="login-form-input" name="pw" id="pw" placeholder="비밀번호를 입력해주세요" type="password">
        <button class="login-form-submit" id="loginBtn">로그인</button>
        <div class="login-form-find">
            <a class="login-form-find-item" href="findId.jsp">아이디 찾기</a>
            <a class="login-form-find-item" href="findPw.jsp">비밀번호 찾기</a>
        </div>
        <div class="login-form-line"></div>
        <a class="login-form-register" href="register.jsp">회원가입</a>
    </form>
</body>
<script>
    document.getElementById("loginBtn").addEventListener("click", function(event){
        event.preventDefault()

        var id = document.getElementById("id").value
        var pw = document.getElementById("pw").value

        if(id.length <= 0){
            alert("유효하지 않은 아이디")
            return
        }
        if(pw.length <= 0){
            alert("유효하지 않은 비밀번호")
            return
        }

        document.getElementById("form").submit()
    })
</script>
</html>