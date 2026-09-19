<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사내 업무 게시판 - 등록</title>
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
    <h2>게시글 등록</h2>

    <form method="post" action="${pageContext.request.contextPath}/board/write">
        <table>
            <colgroup><col style="width:120px"><col></colgroup>
            <tbody>
            <tr>
                <th>제목</th>
                <td class="subject"><input type="text" name="title" style="width:100%" required></td>
            </tr>
            <tr>
                <th>작성자</th>
                <td class="subject"><c:out value="${sessionScope.loginUser}"/></td>
            </tr>
            <tr>
                <th>내용</th>
                <td class="subject"><textarea name="content" rows="12" style="width:100%" required></textarea></td>
            </tr>
            </tbody>
        </table>
        <div class="btn-area">
            <a class="btn gray" href="${pageContext.request.contextPath}/board/list">취소</a>
            <button type="submit">등록</button>
        </div>
    </form>
</div>
</body>
</html>
