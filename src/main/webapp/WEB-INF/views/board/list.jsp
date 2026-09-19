<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사내 업무 게시판 - 목록</title>
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
    <h2>게시글 목록 (전체 ${pageInfo.total}건 / ${pageInfo.page}페이지)</h2>

    <table>
        <colgroup>
            <col style="width:70px"><col><col style="width:110px">
            <col style="width:70px"><col style="width:140px">
        </colgroup>
        <thead>
        <tr>
            <th>번호</th><th>제목</th><th>작성자</th><th>조회</th><th>등록일</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${empty boards}">
                <tr><td colspan="5" class="empty">등록된 게시글이 없습니다.</td></tr>
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

    <div class="paging">
        <c:if test="${pageInfo.hasPrev}">
            <a href="${pageContext.request.contextPath}/board/list?page=${pageInfo.page - 1}">이전</a>
        </c:if>
        <c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
            <c:choose>
                <c:when test="${i eq pageInfo.page}"><strong>${i}</strong></c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/board/list?page=${i}">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        <c:if test="${pageInfo.hasNext}">
            <a href="${pageContext.request.contextPath}/board/list?page=${pageInfo.page + 1}">다음</a>
        </c:if>
    </div>

    <div class="btn-area">
        <a class="btn" href="${pageContext.request.contextPath}/board/writeForm">글쓰기</a>
    </div>

    <div class="legacy-box">
        <form method="get" action="${pageContext.request.contextPath}/board/writerList">
            작성자 조회 :
            <input type="text" name="writer" value="" placeholder="예) 김PM">
            <button type="submit">조회</button>
        </form>
    </div>
</div>
</body>
</html>
