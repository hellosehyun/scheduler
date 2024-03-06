<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%
    request.setCharacterEncoding("utf-8");
    
    String account_idx = (String) session.getAttribute("account_idx");

    // 세션 체크
    if(account_idx == null){
        out.println("<script>alert('로그인 세션 만료');</script>");
        out.println("<script>location.href = '/login.jsp'</script>");
        return;
    }

    String date = request.getParameter("date");
    out.println(date);
%>

<head>
    <link rel="stylesheet" href="../style/date.css">
</head>

<div class="date-body">
    <div class="date-box">
        <div class="date-box-title">
            2022년 3월 1일 일정
        </div>
        <div class="date-box-list">
            <div class="date-box-list-item">
                <!-- <div class="date-box-list-item-time">오전 12 : 30</div>
                <div class="date-box-list-item-content">회의</div>
                <div class="date-box-list-item-manage">
                    <button class="date-box-list-item-manage-edit">수정</button>
                    <button class="date-box-list-item-manage-delete">삭제</button>
                </div> -->
                <div class="date-box-list-item-editState">
                    <div class="date-box-list-item-editState-when">
                        <input class="date-box-list-item-editState-when-input" type="date">
                        <input class="date-box-list-item-editState-when-input" type="time">
                    </div>
                    <input class="date-box-list-item-editState-input" type="text" placeholder="내용을 입력해주세요">
                    <div class="date-box-list-item-editState-manage">
                        <button class="date-box-list-item-editState-manage-submit">저장</button>
                        <button class="date-box-list-item-editState-manage-cancel">취소</button>
                    </div>
                </div>
            </div>
            <div class="date-box-list-item">
                <div class="date-box-list-item-time">오전 12 : 30</div>
                <div class="date-box-list-item-content">회의</div>
                <div class="date-box-list-item-manage">
                    <button class="date-box-list-item-manage-edit">수정</button>
                    <button class="date-box-list-item-manage-delete">삭제</button>
                </div>
                <!-- <div class="date-box-list-item-editState">
                    <div class="date-box-list-item-editState-when">
                        <input class="date-box-list-item-editState-when-input" type="date">
                        <input class="date-box-list-item-editState-when-input" type="time">
                    </div>
                    <input class="date-box-list-item-editState-input" type="text" placeholder="내용을 입력해주세요">
                    <div class="date-box-list-item-editState-manage">
                        <button class="date-box-list-item-editState-manage-submit">저장</button>
                        <button class="date-box-list-item-editState-manage-cancel">취소</button>
                    </div>
                </div> -->
            </div>
        </div>
        <button class="date-box-cancel">닫기</button>
    </div>
</div>

</html>