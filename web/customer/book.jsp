<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.account or sessionScope.account.role ne 'CUSTOMER'}">
    <c:redirect url="../login" />
</c:if>
<c:set var="advanceDays" value="${not empty requestScope.advanceDays ? requestScope.advanceDays : 7}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book a Wash - AutoWash Pro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=vinfast">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
    <div class="dashboard-layout">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-brand">AutoWash Customer</div>
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/dashboard">My Profile</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/book">Book a Wash</a></li>
            </ul>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <span style="font-weight: 600; font-size: 1.1rem; color: var(--text-main);">Book a Wash Slot</span>
                <div style="display: flex; align-items: center; gap: 1rem;">
                    <span style="color: var(--text-muted); font-size: 0.9rem;">Hello, ${sessionScope.account.fullName}</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 0.35rem 0.75rem; font-size: 0.85rem;">Logout</a>
                </div>
            </div>
            
            <!-- Content Wrapper -->
            <div class="content-wrapper">
                <div class="card" style="max-width: 600px; margin: 1rem 0;">
                    <h2>Request Appointment</h2>
                    <p style="color: var(--text-muted); margin-bottom: 1.5rem;">
                        Your <strong>${sessionScope.account.tier}</strong> tier status allows you to schedule up to <strong>${advanceDays} days</strong> in advance.
                    </p>
            
                    <c:if test="${not empty requestScope.error}">
                        <div class="error-msg">${requestScope.error}</div>
                    </c:if>
            
                    <form action="${pageContext.request.contextPath}/book" method="POST">
                        <div class="form-group">
                            <label>Select Date and Time</label>
                            <input type="datetime-local" id="bookingDate" name="bookingDate" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width: auto; min-width: 180px;">Confirm Booking</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Set min/max date for datetime-local based on advanceDays
        const dateInput = document.getElementById('bookingDate');
        const now = new Date();
        const maxDate = new Date();
        maxDate.setDate(now.getDate() + ${advanceDays});

        const toIsoString = (date) => {
            const pad = (num) => (num < 10 ? '0' : '') + num;
            return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate()) + 'T' + pad(date.getHours()) + ':' + pad(date.getMinutes());
        };

        dateInput.min = toIsoString(now);
        dateInput.max = toIsoString(maxDate);
    </script>
</body>
</html>
