<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - AutoWash Pro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=vinfast">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container auth-container">
        <h1>AutoWash Pro</h1>
        <p style="text-align: center; color: var(--text-muted); margin-bottom: 2rem;">Sign in to your account</p>
        
        <c:if test="${not empty requestScope.error}">
            <div class="error-msg">${requestScope.error}</div>
        </c:if>
        
        <c:if test="${param.msg eq 'RegisteredSuccessfully'}">
            <div class="success-msg">Registration successful! Please login.</div>
        </c:if>

        <form action="login" method="POST">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" class="form-control" required autofocus>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary">Login</button>
        </form>
        
        <p style="text-align: center; margin-top: 1.5rem;">
            Don't have an account? <a href="register" style="color: var(--accent);">Register here</a>
        </p>
    </div>
</body>
</html>
