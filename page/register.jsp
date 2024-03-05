<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../style/init.css">
    <link rel="stylesheet" href="../style/register.css">
</head>

<body class="register-body">
    <form id="form" class="register-form" action="/action/actionRegister.jsp">
        <div class="register-form-title">회원가입</div>
        <input name="id" id="id" class="register-form-input" placeholder="아이디를 입력해주세요" type="text">
        <input name="pw" id="pw" class="register-form-input" placeholder="비밀번호를 입력해주세요" type="password">
        <input name="pwConfirm" id="pwConfirm" class="register-form-input" placeholder="비밀번호를 다시 입력해주세요" type="password">
        <input name="email" id="email" class="register-form-input" placeholder="이메일을 입력해주세요" type="email">
        <input name="name" id="name" class="register-form-input" placeholder="이름을 입력해주세요" type="text">
        <select name="department" id="department" class="register-form-select" name="" id="">
            <option class="register-form-select-default" disabled selected>
                부서를 선택해주세요
            </option>
            <option value="design">
                디자인팀
            </option>
            <option value="plan">
                기획팀
            </option>
        </select>
        <select name="rank" id="rank" class="register-form-input" name="" id="">
            <option class="register-form-select-default" disabled selected>
                직급을 선택해주세요
            </option>
            <option value="member">
                팀원
            </option>
            <option value="leader">
                팀장
            </option>
        </select>
        <button class="register-form-submit" id="registerBtn">회원가입</button>
        <a class="register-form-login" href="login.jsp">계정이 있으신가요?</a>
    </form>
</body>

<script>
    document.getElementById("registerBtn").addEventListener("click", function(event){
        event.preventDefault()

        var id = document.getElementById("id").value
        var idRegex = /^[a-zA-Z0-9]{1,20}$/

        var pw = document.getElementById("pw").value
        var pwRegex = /^[a-zA-Z0-9!@#$%^&*()_+{}\[\]:;<>,.?~\\/\-=|]{4,20}$/

        var pwConfirm = document.getElementById("pwConfirm").value

        var email = document.getElementById("email").value
        var emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,30}$/

        var name = document.getElementById("name").value
        var nameRegex = /^[a-zA-Z가-힣]{1,10}$/

        var department = document.getElementById("department").value
        var rank = document.getElementById("rank").value

        if(!idRegex.test(id)){
            alert("유효하지 않은 아이디")
            return
        }
        if(!pwRegex.test(pw)){
            alert("유효하지 않은 비밀번호")
            return
        }
        if(pw !== pwConfirm){
            alert("비밀번호 불일치")
            return
        }
        if(!emailRegex.test(email)){
            alert("유효하지 않은 이메일")
            return
        }
        if(!nameRegex.test(name)){
            alert("유효하지 않은 이름")
            return
        }
        if(!['design', 'plan'].includes(department)){
            alert("유효하지 않은 부서")
            return
        }
        if(!['leader', 'member'].includes(rank)){
            alert("유효하지 않은 직급")
            return
        }

        document.getElementById("form").submit()
    })
</script>

</html>