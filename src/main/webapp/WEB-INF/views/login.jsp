<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사내 업무 게시판 - 로그인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="login-box">
    <h2>사내 업무 게시판</h2>
    <c:if test="${not empty errorMessage}">
        <p class="error"><c:out value="${errorMessage}"/></p>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/login">
        <p><input type="text" name="username" placeholder="아이디" autofocus></p>
        <p><input type="password" name="password" placeholder="비밀번호"></p>
        <button type="submit">로그인</button>
    </form>
    <p class="guide">교육용 계정 : pmuser / pm1234</p>
</div>
</body>
</html>
