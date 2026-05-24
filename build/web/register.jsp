<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - AutoWash Pro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=vinfast">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container auth-container">
        <h1>Join AutoWash Pro</h1>
        <p style="text-align: center; color: var(--text-muted); margin-bottom: 2rem;">Create your account to start earning rewards</p>
        
        <c:if test="${not empty requestScope.error}">
            <div class="error-msg">${requestScope.error}</div>
        </c:if>

        <form action="register" method="POST">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" class="form-control" required autofocus>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Phone Number</label>
                <input type="text" name="phone" class="form-control" required>
            </div>
            <div class="form-group">
                <label>License Plate</label>
                <input type="text" name="licensePlate" class="form-control" required placeholder="e.g. 29A-12345">
            </div>
            <button type="submit" class="btn btn-primary">Register</button>
        </form>
        
        <p style="text-align: center; margin-top: 1.5rem;">
            Already have an account? <a href="login" style="color: var(--accent);">Login here</a>
        </p>
    </div>
</body>
</html>
