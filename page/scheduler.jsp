<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.TreeMap" %>
<%@ page import="java.time.LocalDate" %>

<%!
    public Integer getMonthDay(Integer year, Integer month) {
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
    }

    // 데이테베이스 연결
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/scheduler", "sehyun", "sehyun6685@");
    
    // 권한, 부서 가져오기
    ResultSet rankResult = connect.prepareStatement("SELECT rank, department FROM account WHERE idx = " + account_idx).executeQuery();
    rankResult.next();
    String account_rank = rankResult.getString(1);
    String account_department = rankResult.getString(2);

    // 날짜 계산
    ArrayList<String> calander = new ArrayList(getCalander(year, month));

    // 데이터 가져오기
    ArrayList<ArrayList<String>> schedules = new ArrayList();
    ArrayList<ArrayList<String>> departmentSchedules = new ArrayList();

    // (팀원)
    String sql = "SELECT date, time, content FROM schedule WHERE account_idx = ? AND date between ? and ?;";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, account_idx);
    query.setString(2, calander.get(0).split("\"")[1]);
    query.setString(3, calander.get(calander.size() - 1).split("\"")[1]);
    ResultSet scheduleResult = query.executeQuery();
    
    while(scheduleResult.next()){
        ArrayList<String> tmp = new ArrayList();
        tmp.add("\"" + scheduleResult.getString(1) + "\"");
        tmp.add("\"" + scheduleResult.getString(2).substring(0,5) + "\"");
        tmp.add("\"" + scheduleResult.getString(3) + "\"");
        schedules.add(tmp);
    }

    // (팀장)

    

    if(account_rank.equals("leader")){
        String departmentSql = "SELECT schedule.date, schedule.time, schedule.content, account.name FROM schedule JOIN account ON schedule.account_idx = account.idx WHERE schedule.date BETWEEN ? AND ? AND account.department = ?;";
        PreparedStatement departmentQuery = connect.prepareStatement(departmentSql);
        departmentQuery.setString(1, calander.get(0).split("\"")[1]);
        departmentQuery.setString(2, calander.get(calander.size() - 1).split("\"")[1]);
        departmentQuery.setString(3, account_department);
        ResultSet departmentScheduleResult = departmentQuery.executeQuery();
        
        while(departmentScheduleResult.next()){
            ArrayList<String> tmp = new ArrayList();
            tmp.add("\"" + departmentScheduleResult.getString(1) + "\"");
            tmp.add("\"" + departmentScheduleResult.getString(2).substring(0,5) + "\"");
            tmp.add("\"" + departmentScheduleResult.getString(3) + "\"");
            departmentSchedules.add(tmp);
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
    <div id="writeModal" class="scheduler-modal-write unavailable">
        <jsp:include page="/write.jsp"/>
    </div>
    <div id="dateModal" class="scheduler-modal-date unavailable">
        <jsp:include page="/date.jsp"/>
    </div>
    <div class="scheduler-calander">
        <a href="scheduler.jsp" class="scheduler-calander-title">
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
        <div class="scheduler-calander-month">
            <input class="scheduler-calander-month-btn" type="radio" name="month" value="1" id="january" style="display: none;">
            <label for="january">1월</label>
            <input class="scheduler-calander-month-btn" type="radio" name="month" value="2"  id="february" style="display: none;">
            <label for="february">2월</label>
            <input class="scheduler-calander-month-btn" type="radio" name="month" value="3"  id="march" style="display: none;">
            <label for="march">3월</label>
            <input class="scheduler-calander-month-btn" type="radio" name="month" value="4"  id="april" style="display: none;">
            <label for="april">4월</label>
            <input class="scheduler-calander-month-btn" type="radio" name="month" value="5"  id="may" style="display: none;">
            <label for="may">5월</label>
            <input class="scheduler-calander-month-btn" type="radio" name="month" value="6"  id="june" style="display: none;">
            <label for="june">6월</label>
            <input class="scheduler-calander-month-btn" type="radio" name="month" value="7"  id="july" style="display: none;">
            <label for="july">7월</label>
            <input class="scheduler-calander-month-btn" type="radio" name="month" value="8"  id="august" style="display: none;">
            <label for="august">8월</label>
            <input class="scheduler-calander-month-btn" type="radio" name="month" value="9"  id="september" style="display: none;">
            <label for="september">9월</label>
            <input class="scheduler-calander-month-btn" type="radio" name="month" value="10"  id="october" style="display: none;">
            <label for="october">10월</label>
            <input class="scheduler-calander-month-btn" type="radio" name="month" value="11"  id="november" style="display: none;">
            <label for="november">11월</label>
            <input class="scheduler-calander-month-btn" type="radio" name="month" value="12"  id="december" style="display: none;">
            <label for="december">12월</label>
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
    // 현재 선택된 month checked 출력
    function displayMonthChecked(month){
        var monthObject = {
            1: 'january',
            2: 'february',
            3: 'march',
            4: 'april',
            5: 'may',
            6: 'june',
            7: 'july',
            8: 'august',
            9: 'september',
            10: 'october',
            11: 'november',
            12: 'december'
        };
        document.getElementById(monthObject[month]).checked = true
    }
    // 현재 year 출력
    function displayYear(year){
        document.getElementById("year").innerText = year + "년"
    }
    // calander 출력
    function displayCalander(calander, month, schedules, departmentSchedules){
        for (var i of calander) {
            var item = document.createElement("div")
            item.className = "scheduler-calander-table-date-item"
            item.id = i

            var day = document.createElement("div")
            day.className = "scheduler-calander-table-date-item-day"
            day.innerText = Number(i.split("-")[2])
            if(Number(i.split("-")[1]) !== month)
                day.classList.add("scheduler-calander-table-date-item-outside")

            item.appendChild(day)

            if (schedules.filter(a => a[0] === i).length > 0){
                var count = document.createElement("div")
                count.className = "scheduler-calander-table-date-item-count"
                count.innerText = schedules.filter(a => a[0] === i).length + "개의 일정"
                item.appendChild(count)
            }
            if (departmentSchedules.filter(a => a[0] === i).length > 0){
                var count = document.createElement("div")
                count.className = "scheduler-calander-table-date-item-count"
                count.innerText = departmentSchedules.filter(a => a[0] === i).length + "개의 팀일정"
                item.appendChild(count)
            }

            document.getElementById("table").appendChild(item)
        }
    }

    var calander = <%=calander%>
    var schedules = <%=schedules%>
    var departmentSchedules = <%=departmentSchedules%>
    var diff = 1000 * 60 * 60 * 9
    var year = <%=year%>
    var month = <%=month%>
    var monthRadios = document.getElementsByName("month")

    document.getElementById("logoutBtn").addEventListener("click", function() {
        location.href = "/action/actionLogout.jsp"
    })
    document.getElementById("mypageBtn").addEventListener("click", function() {
        location.href = "mypage.jsp"
    })
    document.getElementById("writeBtn").addEventListener("click", function() {
        document.getElementById("writeModal").classList.remove('unavailable')
        var koreaCurTime = new Date((new Date()).getTime() + diff).toISOString()

        document.getElementById("writeModalDate").value = koreaCurTime.slice(0,10)
        document.getElementById("writeModalTime").value = koreaCurTime.slice(11,16)
    })
    document.getElementById("prevYearBtn").addEventListener("click", function() {
        location.href = "scheduler.jsp?year=" + (year - 1).toString() + "&month=" + (month).toString()
    })
    document.getElementById("nextYearBtn").addEventListener("click", function() {
        location.href = "scheduler.jsp?year=" + (year + 1).toString() + "&month=" + (month).toString()
    })
    for(var i = 0 ; i < monthRadios.length ; i++){
        monthRadios[i].addEventListener("click", function(event) {
            location.href = "scheduler.jsp?year=" + year.toString() + "&month=" + event.target.value
        })
    }

    displayMonthChecked(month)
    displayYear(year)
    displayCalander(calander, month, schedules, departmentSchedules)
</script>

</html>