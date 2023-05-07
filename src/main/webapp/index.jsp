<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>와이파이 정보 구하기</title>
    <style>
        h1{
            margin: 0;
        }

        ul {
            margin-bottom: 12px;
            padding: 0;
            list-style: none;
        }

        li {
            display: inline-block;
        }

        li:after {
            content: "|";
            margin-left: 4px;
        }

        li:last-child::after {
            content: none;
        }

        table {
            margin-top: 12px;
            width: 100%;
            border-collapse: collapse;
        }

        table, th, td {
            border: 1px solid;
        }

        th {
            padding: 12px;
            background-color: green;
            font-size: 13px;
            color: white;
        }

        td {
            padding: 8px;
            text-align: center;
            font-size: 12px;
        }

        .td-empty {
            padding: 20px;
            border: 1px solid lightgray;
            border-top: none;
        }
    </style>
</head>
<body>
<%
    String lat = request.getParameter("lat") != null ? request.getParameter("lat") : "0.0";
    String lnt = request.getParameter("lnt") != null ? request.getParameter("lnt") : "0.0";

%>
<h1>와이파이 정보 구하기</h1>
<ul>
    <li><a href="index.jsp">홈</a></li>
    <li><a href="history.jsp">위치 히스토리 목록</a></li>
    <li><a href="load-wifi.jsp">open Api 와이파이 정보 가져오기</a></li>
</ul>
<div>
    <label for="lat">LAT:</label>
    <input id="lat" name="lat" readonly value="<%=lat%>"/> ,
    <label for="lnt">LNT</label>
    <input id="lnt" name="lnt" readonly value="<%=lnt%>"/>
    <button type="button" onclick="getLocation()">내 위치 가져오기</button>
    <button type="button" onclick="getWifiList(<%=lat%>, <%=lnt%>)">근처 WIFI 정보 보기</button>
</div>
<table>
    <thead>
    <tr>
        <th>거리(Km)</th>
        <th>관리번호</th>
        <th>자치구</th>
        <th>와이파이명</th>
        <th>도로명주소</th>
        <th>상세주소</th>
        <th>설치위치(층)</th>
        <th>설치유형</th>
        <th>설치기관</th>
        <th>서비스구분</th>
        <th>망종류</th>
        <th>설치년도</th>
        <th>실내외구분</th>
        <th>WIFI접속환경</th>
        <th>X좌표</th>
        <th>Y좌표</th>
        <th>작업일자</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td colspan="17" class="td-empty">
            위치 정보를 입력한 후에 조회해 주세요.
        </td>
    </tr>
    </tbody>
</table>
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
    function getLocation() {
        navigator.geolocation.getCurrentPosition(success, error)
    }

    function success({coords}) {
        console.log({coords});
        const url = "?lat=" + coords.latitude + "&lnt=" + coords.longitude;
        window.location.href = url;
    }

    function error(err) {
        console.error(`Error(${err.code}): ${err.message}`)
        alert('내 위치 정보를 가져올 수 없습니다.');
    }

    function getWifiList(lat, lnt) {
        $.ajax({
            type: "GET",
            url: "/wifi",
            data: {
                lat,
                lnt,
            },
            success: (response) => {
                if (response) {
                    $("tbody").html(response);
                    handleHistoryInsert(lat, lnt);
                } else {
                    alert("데이터 조회 실패");
                }
            },
            error: () => {
                alert("에러!");
            }
        })
    }


    function handleHistoryInsert(lat, lnt) {
        $.ajax({
            type: "GET",
            url: "/history-insert",
            data: {
                lat,
                lnt,
            },
            success: (response) => {
                if (response) {
                    alert("히스토리가 추가되었습니다.")
                } else {
                    alert("히스토리 추가 실패");
                }
            },
            error: () => {
                alert("에러!");
            }
        })
    }
</script>
</body>
</html>