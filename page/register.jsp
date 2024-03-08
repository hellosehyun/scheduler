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
    <div class="register-form">
        <div class="register-form-title">회원가입</div>
        <input id="id" class="register-form-input" placeholder="아이디를 입력해주세요" type="text">
        <input id="pw" class="register-form-input" placeholder="비밀번호를 입력해주세요" type="password">
        <input id="pwConfirm" class="register-form-input" placeholder="비밀번호를 다시 입력해주세요" type="password">
        <input id="email" class="register-form-input" placeholder="이메일을 입력해주세요" type="email">
        <input id="name" class="register-form-input" placeholder="이름을 입력해주세요" type="text">
        <select id="department" required class="register-form-select">
            <option value="" hidden>
                부서를 선택해주세요
            </option>
            <option value="design">
                디자인팀
            </option>
            <option value="plan">
                기획팀
            </option>
        </select>
        <select id="rank" required class="register-form-select">
            <option value="" hidden>
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
    </div>
</body>

<script>
    function validateData(id, pw, pwConfirm, email, name, department, rank) {
        var idRegex = /^[a-zA-Z0-9]{1,20}$/
        var pwRegex = /^[a-zA-Z0-9!@#$%^&*()_+{}\[\]:;<>,.?~\\/\-=|]{4,20}$/
        var emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,30}$/
        var nameRegex = /^[a-zA-Z가-힣]{1,10}$/

        if(!idRegex.test(id)){
            alert("유효하지 않은 아이디")
            return false
        }
        if(!pwRegex.test(pw)){
            alert("유효하지 않은 비밀번호")
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
            alert("유효하지 않은 이름")
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
    document.getElementById("registerBtn").addEventListener("click", function(event){
        event.preventDefault()

        var id = document.getElementById("id").value
        var pw = document.getElementById("pw").value
        var pwConfirm = document.getElementById("pwConfirm").value
        var email = document.getElementById("email").value
        var name = document.getElementById("name").value
        var department = document.getElementById("department").value
        var rank = document.getElementById("rank").value

        if(validateData(id, pw, pwConfirm, email, name, department, rank)){
            location.href = "/action/actionRegister.jsp?id=" + id + "&pw=" + pw + "&pwConfirm=" + pwConfirm + "&email=" + email + "&name=" + name + "&department=" + department + "&rank=" + rank
        }
    })
</script>

</html>