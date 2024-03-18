<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="/../style/init.css">
    <link rel="stylesheet" href="/../style/find.css">
</head>

<body class="find-body">
    <div class="find-form">
        <div class="find-form-title">비밀번호 찾기</div>
        <input id="email" class="find-form-input" placeholder="이메일을 입력해주세요" type="text">
        <input id="id" class="find-form-input" placeholder="아이디를 입력해주세요" type="text">
        <div class="find-form-box">
            <a class="find-form-box-find" href="/findId.jsp">아이디 찾기</a>
            <button class="find-form-box-cancel" id="cancel">취소</button>
            <button class="find-form-box-search" id="search">검색</button>
        </div>
        <div class="find-form-line"></div>
        <a class="find-form-register" href="/register.jsp">회원가입</a>
    </div>
</body>

<script>
    function validateData(email, id) {
        var emailRegex = /^(?=.{1,30}$)[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
        var nameRegex = /^.{1,20}$/

        if(!regex.test(email)){
            alert("이메일 입력 필수")
            return false
        }
        if(!regex.test(id)){
            alert("아이디 입력 필수 (최대 20자)")
            return false
        }
        return true
    }

    document.getElementById("cancel").addEventListener("click", function(event) {
        location.href = "/login.jsp"
    })
    document.getElementById("search").addEventListener("click", function(event) {
        var email = document.getElementById("email").value
        var id = document.getElementById("id").value

        if(validateData(email, id)){
            location.href = "/action/actionFindPw.jsp?email=" + email + "&id=" + id
        }
    })
</script>

</html>