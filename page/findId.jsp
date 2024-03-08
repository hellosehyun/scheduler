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
    <div class="find-form">
        <div class="find-form-title">
            아이디 찾기
        </div>
        <input id="email" class="find-form-input" placeholder="이메일을 입력해주세요" type="text">
        <input id="name" class="find-form-input" placeholder="이름을 입력해주세요" type="text">
        <div class="find-form-box">
            <a class="find-form-box-find" href="/findPw.jsp">
                비밀번호 찾기
            </a>
            <button class="find-form-box-cancel" id="cancel">
                취소
            </button>
            <button class="find-form-box-submit" id="submit">
                검색
            </button>
        </div>
        <div class="find-form-line"></div>
        <a class="find-form-register" href="/register.jsp">
            회원가입
        </a>
    </div>
</body>
<script>
    function validateData(email, name) {
        var regex = /^[^\s]+$/

        if(!regex.test(email)){
            alert("이메일 입력 필수")
            return false
        }
        if(!regex.test(name)){
            alert("이름 입력 필수")
            return false
        }
        return true
    }
    document.getElementById("cancel").addEventListener("click", function(event) {
        event.preventDefault()
        location.href = "/login.jsp"
    })
    document.getElementById("submit").addEventListener("click", function(event) {
        event.preventDefault()

        var email = document.getElementById("email").value
        var name = document.getElementById("name").value

        if(validateData(email, name)){
            location.href = "/action/actionFindId.jsp?email=" + email + "&name=" + name
        }
    })
</script>

</html>