<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%
    String account_idx = (String) session.getAttribute("account_idx");

    // 세션 체크
    if(account_idx == null){
        out.println("<script>alert('로그인 세션 만료');</script>");
        out.println("<script>location.href = '/login.jsp'</script>");
    }
%>

<head>
    <link rel="stylesheet" href="../style/write.css">
</head>

<div class="write-body">
    <form id="writeModalForm" class="write-form" action="action/actionWrite.jsp">
        <div class="write-form-title">일정 추가하기</div>
        <input id="writeModalDate" name="date" class="write-form-input" type="date">
        <input id="writeModalTime" name="time" class="write-form-input" type="time">
        <input id="writeModalContent" name="content" class="write-form-input" placeholder="내용을 입력해주세요" type="text">
        <div class="write-form-box">
            <button class="write-form-box-cancel" id="writeModalCancel">취소</button>
            <button class="write-form-box-submit" id="writeModalSumbit">일정 추가하기</button>
        </div>
    </form>
</div>

<script>
    document.getElementById("writeModalCancel").addEventListener("click", function(event){
        event.preventDefault();
        document.getElementById("writeModal").classList.add('unavailable')
    })
    document.getElementById("writeModalSumbit").addEventListener("click", function(event){
        event.preventDefault();

        var date = document.getElementById("writeModalDate").value
        var dateRegex =  /^\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/

        var time = document.getElementById("writeModalTime").value
        var timeRegex = /^(0[0-9]|1[0-9]|2[0-3]):(0[1-9]|[0-5][0-9])$/

        var content = document.getElementById("writeModalContent").value
        var contentRegex = /^.{1,30}$/

        if(!dateRegex.test(date)){
            alert("유효하지 않은 날짜")
            return
        }
        if(!timeRegex.test(time)){
            alert("유효하지 않은 시간")
            return 
        }
        if(!contentRegex.test(content)){
            alert("유효하지 않은 내용")
            return
        }

        document.getElementById("writeModalForm").submit()
    })

</script>

</html>