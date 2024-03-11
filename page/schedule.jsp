<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>

<%
    request.setCharacterEncoding("utf-8");
    
    String account_idx = (String) session.getAttribute("account_idx");
    String date = request.getParameter("date");

    // 세션 체크
    if(account_idx == null){
        out.println("<script>alert('로그인 세션 만료');</script>");
        out.println("<script>location.href = '/login.jsp'</script>");
        return;
    }

    // 데이테베이스 연결
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/scheduler", "sehyun", "sehyun6685@");
    
    // 권한, 부서 가져오기
    ResultSet result = connect.prepareStatement("SELECT rank, department FROM account WHERE idx = " + account_idx).executeQuery();
    result.next();
    String account_rank = result.getString(1);
    String account_department = result.getString(2);

    ArrayList<String> schedules = new ArrayList();
    ArrayList<String> departmentSchedules = new ArrayList();

    // 본인 스케줄
    String sql2 = "SELECT time, content, idx FROM schedule WHERE account_idx = ? AND date = ?;";
    PreparedStatement query2 = connect.prepareStatement(sql2);
    query2.setString(1, account_idx);
    query2.setString(2, date);
    ResultSet result2 = query2.executeQuery();

    while(result2.next()){
        String tmp = "{";
        tmp += "time : " + "\"" + result2.getString(1).substring(0,5) + "\"" + ",";
        tmp += "content : " + "\"" + result2.getString(2) + "\"" + ",";
        tmp += "idx : " + "\"" + result2.getString(3) + "\"";
        tmp += "}";
        schedules.add(tmp);
    }

    // 팀장 (팀원 스케줄)
    if(account_rank.equals("leader")) {
        String sql3 = "SELECT schedule.time, schedule.content, schedule.idx, account.name FROM schedule JOIN account ON schedule.account_idx = account.idx WHERE schedule.date = ? AND account.department = ? AND NOT schedule.account_idx = ?";
        PreparedStatement query3 = connect.prepareStatement(sql3);
        query3.setString(1, date);
        query3.setString(2, account_department);
        query3.setString(3, account_idx);
        ResultSet result3 = query3.executeQuery();
        
        while(result3.next()) {
            String tmp = "{";
            tmp += "time : " + "\"" + result3.getString(1).substring(0,5) + "\"" + ",";
            tmp += "content : " + "\"" + result3.getString(2) + "\"" + ",";
            tmp += "idx : " + "\"" + result3.getString(3) + "\"" + ",";
            tmp += "name : " + "\"" + result3.getString(4) + "\"";
            tmp += "}";
            departmentSchedules.add(tmp);
        }
    }
%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="/../style/init.css">
    <link rel="stylesheet" href="/../style/schedule.css">
</head>

<body class="schedule-body">
    <div class="schedule-box">
        <div class="schedule-box-date" id="date"></div>
        <div class="schedule-box-list" id="list"></div>
        <button class="schedule-box-cancel" id="scheduleModalCancel">닫기</button>
    </div>
</body>

<script>
    function getColorTable(departmentSchedules) {
        var colorTable = {}
        var colors = ["#F8E8EE", "#D2E9E9", "#E3F4F4", "#F8F6F4", "#C6D6A6", "#D7E9FD", "#F8E4C1", "#FEDCD2", "#F5E8DD"]
        var names = Array.from(new Set(departmentSchedules.map((i) => i.name)))

        for (var i = 0 ; i < names.length ; i++){
            colorTable[names[i]] = colors[i]
        }
        return colorTable
    }
    function getScheduleNode(schedule) {
        var node = document.createElement("div")
        node.className = "schedule-box-list-item"
        
        var node2 = document.createElement("div")
        node2.className = "schedule-box-list-item-detail"
        var node3 = document.createElement("div")
        node3.className = "schedule-box-list-item-detail-item"
        node3.value = schedule.time
        node3.innerText = Number(schedule.time.split(":")[0]) >= 12 ? "오후 " + ((Number(schedule.time.split(":")[0]) - 12) || 12).toString().padStart(2,"0") + ":" + schedule.time.split(":")[1] : "오전 " + schedule.time
        node2.appendChild(node3)

        var node4 = document.createElement("div")
        node4.className = "schedule-box-list-item-content"
        node4.innerText = schedule.content

        var node5 = document.createElement("div")
        node5.className = "schedule-box-list-item-manage"
        var node6 = document.createElement("button")
        node6.className = "schedule-box-list-item-manage-edit"
        node6.innerText = "수정"
        node6.addEventListener("click", function() {
            node.classList.add("unavailable")
            node.after(getEditNode(schedule, date, node))
        })

        var node7 = document.createElement("button")
        node7.className = "schedule-box-list-item-manage-delete"
        node7.innerText = "삭제"
        node7.addEventListener("click", function() {
            if(confirm("정말 삭제하시겠습니까?")) {
                window.parent.location.href = "/action/actionDeleteWrite.jsp?idx=" + schedule.idx
            }
        })
        node5.append(node6, node7)
        
        node.append(node2, node4, node5)

        return node
    }
    function getDeparmentNode(schedule) {
        var node = document.createElement("div")
        node.className = "schedule-box-list-item"
        node.style.backgroundColor = colorTable[schedule.name]
        
        var node2 = document.createElement("div")
        node2.className = "schedule-box-list-item-detail"
        var node3 = document.createElement("div")
        node3.className = "schedule-box-list-item-detail-item"
        node3.value = schedule.time
        node3.innerText = Number(schedule.time.split(":")[0]) >= 12 ? "오후 " + ((Number(schedule.time.split(":")[0]) - 12) || 12).toString().padStart(2,"0") + ":" + schedule.time.split(":")[1] : "오전 " + schedule.time
        var node4 = document.createElement("div")
        node4.className = "schedule-box-list-item-detail-item"
        node4.innerText = schedule.name
        node2.append(node3, node4)

        var node5 = document.createElement("div")
        node5.className = "schedule-box-list-item-content"
        node5.innerText = schedule.content
        
        node.append(node2, node5)

        return node
    }
    function getEditNode(schedule, date, parentNode) {
        var node = document.createElement("div")
        node.className = "schedule-box-list-itemEdit"

        var node2 = document.createElement("div")
        node2.className = "schedule-box-list-itemEdit-when"
        var node3 = document.createElement("input")
        node3.className = "schedule-box-list-itemEdit-when-input"
        node3.type = "date"
        node3.value = date
        var node4 = document.createElement("input")
        node4.className = "schedule-box-list-itemEdit-when-input"
        node4.type = "time"
        node4.value = schedule.time
        node2.append(node3,node4)

        var node5 = document.createElement("input")
        node5.className = "schedule-box-list-itemEdit-input"
        node5.type = "text"
        node5.value = schedule.content
        node5.placeholder = "내용을 입력해주세요"

        var node6 = document.createElement("div")
        node6.className = "schedule-box-list-itemEdit-manage"
        var node7 = document.createElement("button")
        node7.className = "schedule-box-list-itemEdit-manage-submit"
        node7.innerText = "저장"
        node7.addEventListener("click", function() {
            if(validateData(node3.value, node4.value, node5.value)){
                window.parent.location.href = "/action/actionEditWrite.jsp?date=" + node3.value + "&time=" + node4.value + "&content=" + node5.value + "&idx=" + node9.value
            }
        })
        var node8 = document.createElement("button")
        node8.className = "schedule-box-list-itemEdit-manage-cancel"
        node8.innerText = "취소"
        node8.addEventListener("click", function() {
            parentNode.classList.remove("unavailable")
            node.remove()
        })
        var node9 = document.createElement("div")
        node9.style.display = "none"
        node9.value = schedule.idx
        node6.append(node7,node8)

        node.append(node2, node5, node6, node9)
        
        return node
    }
    function getScheduleNodeList(schedules, departmentSchedules) {
        var result = []

        for (var schedule of schedules) {
            result.push(getScheduleNode(schedule))
        }
        for (var departmentSchedule of departmentSchedules) {
            result.push(getDeparmentNode(departmentSchedule))
        }
        result.sort(function(a,b) {
            var timeA = new Date("2000-01-01 " + a.getElementsByClassName("schedule-box-list-item-detail-item")[0].value)
            var timeB = new Date("2000-01-01 " + b.getElementsByClassName("schedule-box-list-item-detail-item")[0].value)

            if(timeA > timeB)
                return 1
            if(timeA < timeB)
                return -1
            return 0
        })

        return result
    }
    function displayScheduleNodeList(scheduleNodeList) {
        for(var node of scheduleNodeList){
            document.getElementById("list").appendChild(node)
        }
    }
    function displayDate(date){
        document.getElementById("date").innerText = Number(date.split("-")[0]) + "년 " + Number(date.split("-")[1]) + "월 " + Number(date.split("-")[2]) + "일 일정"
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
            alert("유효하지 않은 내용")
            return false
        }
        
        return true
    }

    var date = <%="\"" + date + "\""%>
    var schedules = <%=schedules%>
    var departmentSchedules = <%=departmentSchedules%>
    var colorTable = getColorTable(departmentSchedules)

    displayDate(date)
    displayScheduleNodeList(getScheduleNodeList(schedules, departmentSchedules))

    document.getElementById("scheduleModalCancel").addEventListener("click", function(event){
        window.parent.displayOffModal()
    })
</script>

</html>