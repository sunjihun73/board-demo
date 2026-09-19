<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사내 업무 게시판 - 상세</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="topbar">
    <div class="inner">
        <span><a href="${pageContext.request.contextPath}/board/list">사내 업무 게시판</a></span>
        <span>
            <c:out value="${sessionScope.loginUser}"/>님
            &nbsp;|&nbsp;
            <a href="${pageContext.request.contextPath}/logout">로그아웃</a>
        </span>
    </div>
</div>

<div class="wrap">
    <h2>게시글 상세</h2>

    <table class="view-table">
        <colgroup><col style="width:120px"><col></colgroup>
        <tbody>
        <tr>
            <th>제목</th>
            <td class="subject">${board.title}</td>
        </tr>
        <tr>
            <th>작성자</th>
            <td class="subject">${board.writer}</td>
        </tr>
        <tr>
            <th>등록일</th>
            <td class="subject">${board.createdAtText} / 조회 ${board.viewCount}</td>
        </tr>
        <tr>
            <th>내용</th>
            <td class="content">${board.content}</td>
        </tr>
        </tbody>
    </table>

    <div class="btn-area">
        <a class="btn gray" href="${pageContext.request.contextPath}/board/list">목록</a>
    </div>
</div>
</body>
</html>
