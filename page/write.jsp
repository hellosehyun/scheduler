<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%
    String account_idx = (String) session.getAttribute("account_idx");

    // 세션 체크
    if(account_idx == null){
        out.println("<script>alert('로그인 세션 만료');</script>");
        out.println("<script>location.href = '/login.jsp'</script>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="/../style/init.css">
    <link rel="stylesheet" href="/../style/write.css">
</head>

<body class="write-body">
    <div class="write-form">
        <div class="write-form-title">일정 추가하기</div>
        <input id="writeModalDate" class="write-form-input" type="date">
        <input id="writeModalTime" class="write-form-input" type="time">
        <input id="writeModalContent" class="write-form-input" placeholder="내용을 입력해주세요" type="text">
        <div class="write-form-box">
            <button class="write-form-box-cancel" id="writeModalCancel">취소</button>
            <button class="write-form-box-submit" id="writeModalSumbit">일정 추가하기</button>
        </div>
    </div>
</body>

<script>
    function getCurTime(type){
        var diff = 1000 * 60 * 60 * 9
        if (type === "date"){
            return new Date((new Date()).getTime() + diff).toISOString().slice(0,10)
        }
        if (type === "time"){
            return new Date((new Date()).getTime() + diff).toISOString().slice(11,16)
        }
    }
    function validateData(date, time, content) {
        var dateRegex =  /^\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/
        var timeRegex = /^(0[0-9]|1[0-9]|2[0-3]):(0[1-9]|[0-5][0-9])$/
        var contentRegex = /^.{1,30}$/

        if(!dateRegex.test(date)){
            alert("유효하지 않은 날짜")
            return false
        }
        if(!timeRegex.test(time)){
            alert("유효하지 않은 시간")
            return false
        }
        if(!contentRegex.test(content)){
            alert("유효하지 않은 내용 (최대 30자)")
            return false
        }
        
        return true
    }


    document.getElementById("writeModalDate").value = getCurTime("date")
    document.getElementById("writeModalTime").value = getCurTime("time")

    document.getElementById("writeModalCancel").addEventListener("click", function(){
        window.parent.displayOffModal()
    })
    document.getElementById("writeModalSumbit").addEventListener("click", function(){
        var date = document.getElementById("writeModalDate").value
        var time = document.getElementById("writeModalTime").value
        var content = document.getElementById("writeModalContent").value

        if(validateData(date, time, content)){
            parent.window.location.href = "action/actionWrite.jsp?date=" + date + "&time=" + time + "&content=" + content
        }
    })

</script>

</html>