<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사내 업무 게시판 - 작성자 조회</title>
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
    <h2>작성자 조회 결과 : ${writer}</h2>

    <table>
        <colgroup>
            <col style="width:70px"><col><col style="width:110px">
            <col style="width:70px"><col style="width:140px">
        </colgroup>
        <thead>
        <tr><th>번호</th><th>제목</th><th>작성자</th><th>조회</th><th>등록일</th></tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${empty boards}">
                <tr><td colspan="5" class="empty">조회 결과가 없습니다.</td></tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="board" items="${boards}">
                    <tr>
                        <td>${board.id}</td>
                        <td class="subject">
                            <a href="${pageContext.request.contextPath}/board/detail?id=${board.id}">
                                <c:out value="${board.title}"/>
                            </a>
                        </td>
                        <td><c:out value="${board.writer}"/></td>
                        <td>${board.viewCount}</td>
                        <td>${board.createdAtText}</td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

    <div class="btn-area">
        <a class="btn gray" href="${pageContext.request.contextPath}/board/list">목록</a>
    </div>
</div>
</body>
</html>
