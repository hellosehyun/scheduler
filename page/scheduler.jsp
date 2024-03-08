<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.time.LocalDate" %>

<%!
    public Integer getMonthDay(Integer year, Integer month) { // 해당 year 과 month의 일 수 반환
        List<Integer> case1 = Arrays.asList(1,3,5,7,8,10,12);
        List<Integer> case2 = Arrays.asList(4,6,9,11);

        if (case1.contains(month))
            return 31;
        else if (case2.contains(month))
            return 30;
        else {
            if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
                return 29;
            else
                return 28;
        }
    }
    public Integer getFirstDay(Integer year, Integer month) { // 해당 year과 month의 1일의 index 반환
        Integer sum = 0;

        for (Integer i = 1583; i < year; i++) {
            if ((i % 4 == 0 && i % 100 != 0) || i % 400 == 0)
                sum += 2;
            else
                sum += 1;
        }
        Integer first = (sum + 6) % 7;

        for (Integer i = 1; i < month; i++) {
            first += getMonthDay(year, i) % 7;
        }
        return first % 7;
    }
    public ArrayList getCalander(Integer year, Integer month) {
        Integer monthDay = getMonthDay(year, month);
        Integer firstDay = getFirstDay(year, month);

        Integer prevMonth = month - 1 <= 0 ? 12 : month - 1;
        Integer prevYear = month - 1 <= 0 ? year - 1 : year;
        Integer prevMonthDay = getMonthDay(prevYear, prevMonth);
        Integer prevFirstDay = getFirstDay(prevYear, prevMonth);

        Integer nextMonth = month + 1 > 12 ? 1 : month + 1;
        Integer nextYear = month + 1 > 12 ? year + 1 : year;

        ArrayList<String> result = new ArrayList();

        for (Integer i = prevMonthDay - (firstDay - 1) ; i < prevMonthDay + 1 ; i++){
            String date = "\"" + prevYear + "-" + String.format("%02d", prevMonth)+ "-" + String.format("%02d", i) + "\"";
            result.add(date);
        }
        for (Integer i = 1 ; i <= monthDay ; i++) {
            String date = "\"" + year + "-" + String.format("%02d", month)+ "-" + String.format("%02d", i) + "\"";
            result.add(date);
        }
        for (Integer i = 1 ; result.size() < 42; i++) {
            String date = "\"" + nextYear + "-" + String.format("%02d", nextMonth)+ "-" + String.format("%02d", i) + "\"";
            result.add(date);
        }
        
        return result;
    }
%>

<%
    request.setCharacterEncoding("utf-8");

    LocalDate now = LocalDate.now();
    String account_idx = (String) session.getAttribute("account_idx");
    Integer year;
    Integer month;
    
    if(request.getParameter("year") == null){
        year = now.getYear();
    } else {
        year = Integer.parseInt(request.getParameter("year"));
    }

    if(request.getParameter("month") == null){
        month = now.getMonthValue();
    } else {
        month = Integer.parseInt(request.getParameter("month"));
    }

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

    // 날짜 계산
    ArrayList<String> calander = new ArrayList(getCalander(year, month));
    ArrayList<String> schedules = new ArrayList();
    ArrayList<String> departmentSchedules = new ArrayList();

    // 본인 스케줄
    String sql2 = "SELECT date FROM schedule WHERE account_idx = ? AND date between ? and ?;";
    PreparedStatement query2 = connect.prepareStatement(sql2);
    query2.setString(1, account_idx);
    query2.setString(2, calander.get(0).split("\"")[1]);
    query2.setString(3, calander.get(calander.size() - 1).split("\"")[1]);
    ResultSet result2 = query2.executeQuery();

    while(result2.next()){
        schedules.add("\"" + result2.getString(1) + "\"");
    }

    // (팀장)
    if(account_rank.equals("leader")) {
        String sql3 = "SELECT schedule.date FROM schedule JOIN account ON schedule.account_idx = account.idx WHERE schedule.date BETWEEN ? AND ? AND account.department = ? AND NOT schedule.account_idx = ?";
        PreparedStatement query3 = connect.prepareStatement(sql3);
        query3.setString(1, calander.get(0).split("\"")[1]);
        query3.setString(2, calander.get(calander.size() - 1).split("\"")[1]);
        query3.setString(3, account_department);
        query3.setString(4, account_idx);
        ResultSet result3 = query3.executeQuery();
        
        while(result3.next()){
            departmentSchedules.add("\"" + result3.getString(1) + "\"");
        }
    }
%>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../style/init.css">
    <link rel="stylesheet" href="../style/scheduler.css">
</head>

<body>
    <iframe src="#" class="scheduler-modal unavailable" id="modal">
    </iframe>
    <div class="scheduler-calander">
        <a href="/scheduler.jsp" class="scheduler-calander-title">
            <span>스케</span><span class="scheduler-calander-title-lightBlue">줄러</span>
        </a>
        <nav class="scheduler-calander-nav">
            <button id="writeBtn" class="scheduler-calander-nav-itemBlue">일정 추가하기</button>
            <button id="mypageBtn" class="scheduler-calander-nav-itemBlue">내정보</button>
            <button id="logoutBtn" class="scheduler-calander-nav-item">로그아웃</button>
        </nav>
        <div class="scheduler-calander-year">
            <button id="prevYearBtn" class="scheduler-calander-year-btn">&lt;</button>
            <span class="scheduler-calander-year-number" id="year"></span>
            <button id="nextYearBtn" class="scheduler-calander-year-btn">&gt;</button>
        </div>
        <div class="scheduler-calander-month" id="month">
        </div>
                
        <div class="scheduler-calander-table">
            <div class="scheduler-calander-table-days">
                <div class="scheduler-calander-table-days-item">일</div>
                <div class="scheduler-calander-table-days-item">월</div>
                <div class="scheduler-calander-table-days-item">화</div>
                <div class="scheduler-calander-table-days-item">수</div>
                <div class="scheduler-calander-table-days-item">목</div>
                <div class="scheduler-calander-table-days-item">금</div>
                <div class="scheduler-calander-table-days-item">토</div>
            </div>
        <div class="scheduler-calander-table-date" id="table">
        </div>
    </div>
</div>
</body>

<script>
    function getCount(arr) {
        return arr.reduce((prev, curr) => {
            prev[curr] = ++prev[curr] || 1;
            return prev;
        }, {});
    }
    function getCurTime(type){
        var diff = 1000 * 60 * 60 * 9
        if (type === "date"){
            return new Date((new Date()).getTime() + diff).toISOString().slice(0,10)
        }
        if (type === "time"){
            return new Date((new Date()).getTime() + diff).toISOString().slice(11,16)
        }
    }
    function displayMonthBtn(year, month){
        for(var i = 1 ; i <= 12 ; i++){
            var node = document.createElement("button")
            node.className = "scheduler-calander-month-btn"
            node.innerText = i + "월"
            node.value = i
            if (i === month){
                node.classList.add("scheduler-calander-month-btn-checked")
            }
            node.addEventListener("click", function(event) {
                location.href = "scheduler.jsp?year=" + year.toString() + "&month=" + event.target.value
            })
            document.getElementById("month").appendChild(node)
        }
    }
    function displayYear(year){
        document.getElementById("year").innerText = year + "년"
    }
    function displayCalander(calander, month, today){
        for (var i of calander) {
            var item = document.createElement("div")
            item.className = "scheduler-calander-table-date-item"
            item.id = i

            var day = document.createElement("div")
            day.className = "scheduler-calander-table-date-item-day"
            day.innerText = Number(i.split("-")[2])
            item.appendChild(day)

            // 현재 월에 벗어난 월 폰트 색상
            if(Number(i.split("-")[1]) !== month && i !== today)
                day.classList.add("scheduler-calander-table-date-item-outside")
            // 오늘 날짜 스타일
            if (i === today) {
                item.classList.add("scheduler-calander-table-date-item-today")
                day.classList.add("scheduler-calander-table-date-item-day-today")
            }
            document.getElementById("table").appendChild(item)
        }
    }
    function displaySchedulesCount(schedulesCount) {
        for (var i in schedulesCount){
            var count = schedulesCount[i]
            var element = document.getElementById(i)

            var node = document.createElement("div")
            node.className = "scheduler-calander-table-date-item-count"
            node.innerText = count + "개의 일정"
            element.appendChild(node)
            element.classList.add("scheduler-calander-table-date-item-clickable")
        }
    }
    function displayDepartmentSchedulesCount(departmentSchedulesCount){
        for (var i in departmentSchedulesCount){
            var count = departmentSchedulesCount[i]
            var element = document.getElementById(i)

            var node = document.createElement("div")
            node.className = "scheduler-calander-table-date-item-count"
            node.innerText = count + "개의 팀원일정"
            element.appendChild(node)
            element.classList.add("scheduler-calander-table-date-item-clickable")
        }
    }
    function offModalScreen() {
        document.getElementById("modal").src = ""
        document.getElementById("modal").classList.add('unavailable')
    }

    var year = <%=year%>
    var month = <%=month%>
    var rank = <%="\"" + account_rank + "\""%>
    var calander = <%=calander%>
    var schedulesCount = getCount(<%=schedules%>)
    var departmentSchedulesCount = getCount(<%=departmentSchedules%>)

    displayMonthBtn(year, month)
    displayYear(year)
    displayCalander(calander, month, getCurTime("date"))
    displaySchedulesCount(schedulesCount)
    if(rank === "leader") displayDepartmentSchedulesCount(departmentSchedulesCount)

    document.getElementById("logoutBtn").addEventListener("click", function() {
        location.href = "/action/actionLogout.jsp"
    })
    document.getElementById("mypageBtn").addEventListener("click", function() {
        location.href = "mypage.jsp"
    })
    document.getElementById("writeBtn").addEventListener("click", function() {
        document.getElementById("modal").src = "write.jsp"
        document.getElementById("modal").classList.remove('unavailable')
    })
    document.getElementById("prevYearBtn").addEventListener("click", function() {
        location.href = "scheduler.jsp?year=" + (year - 1).toString() + "&month=" + (month).toString()
    })
    document.getElementById("nextYearBtn").addEventListener("click", function() {
        location.href = "scheduler.jsp?year=" + (year + 1).toString() + "&month=" + (month).toString()
    })
    Array.from(document.getElementsByClassName("scheduler-calander-table-date-item-clickable")).forEach((btn) => {btn.addEventListener("click", function(event) {
        document.getElementById("modal").src = "schedule.jsp?date=" + event.target.id
        document.getElementById("modal").classList.remove('unavailable')
    })})
</script>

</html>