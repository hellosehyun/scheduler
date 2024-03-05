<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../style/init.css">
    <link rel="stylesheet" href="../style/find.css">
</head>

<body class="find-body">
    <form class="find-form" action="">
        <div class="find-form-title">
            비밀번호 찾기
        </div>
        <input class="find-form-input" placeholder="이메일을 입력해주세요" type="text">
        <input class="find-form-input" placeholder="아이디를 입력해주세요" type="password">
        <div class="find-form-box">
            <a class="find-form-box-find" href="findId.jsp">
                아이디 찾기
            </a>
            <button class="find-form-box-cancel" id="cancelBtn">
                취소
            </button>
            <button class="find-form-box-submit" type="submit">
                검색
            </button>
        </div>
        <div class="find-form-line"></div>
        <a class="find-form-register" href="register.jsp">
            회원가입
        </a>
    </form>
</body>
<script>
    document.getElementById("cancelBtn").addEventListener("click", function(event) {
        event.preventDefault()
        location.href = "login.jsp"
    })
</script>

</html>