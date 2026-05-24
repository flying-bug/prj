<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${empty sessionScope.account or sessionScope.account.role ne 'ADMIN'}">
    <c:redirect url="../login" />
</c:if>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - AutoWash Pro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=vinfast">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
    <div class="dashboard-layout">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-brand">AutoWash Admin</div>
            <ul class="sidebar-menu">
                <li class="active"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/lpr">LPR Simulator</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/promotions">Promotions</a></li>
            </ul>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <span style="font-weight: 600; font-size: 1.1rem; color: var(--text-main);">Admin Panel</span>
                <div style="display: flex; align-items: center; gap: 1rem;">
                    <span style="color: var(--text-muted); font-size: 0.9rem;">Administrator</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 0.35rem 0.75rem; font-size: 0.85rem;">Logout</a>
                </div>
            </div>
            
            <!-- Content Wrapper -->
            <div class="content-wrapper">
                <h2 style="margin-bottom: 1.5rem;">System Reports & Analytics</h2>
                
                <!-- Stats Row -->
                <div class="stats-row">
                    <div class="stat-card">
                        <h3>Total Bookings</h3>
                        <div class="stat-value" style="color: var(--primary-color);">${fn:length(requestScope.bookings)}</div>
                    </div>
                    <div class="stat-card">
                        <h3>Registered Customers</h3>
                        <div class="stat-value" style="color: #10b981;">${requestScope.totalCustomers}</div>
                    </div>
                    <div class="stat-card">
                        <h3>Total Revenue</h3>
                        <div class="stat-value" style="color: #fbbf24;">
                            <c:choose>
                                <c:when test="${not empty requestScope.totalRevenue}">
                                    <fmt:formatNumber value="${requestScope.totalRevenue}" pattern="#,##0"/> VND
                                </c:when>
                                <c:otherwise>
                                    0 VND
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="stat-card">
                        <h3>Active Promotions</h3>
                        <div class="stat-value" style="color: #818cf8;">${fn:length(requestScope.promotions)}</div>
                    </div>
                </div>
                
                <!-- Two Columns Sections -->
                <div class="dashboard-sections">
                    <div class="dashboard-section" style="max-width: 500px;">
                        <div class="card">
                            <h3>Loyalty Tier Breakdown</h3>
                            <div style="margin-top: 1rem; display: flex; flex-direction: column; gap: 0.75rem;">
                                <div>
                                    <div style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 0.25rem;">
                                        <span>Platinum VIP</span>
                                        <strong style="color: var(--tier-platinum);">${requestScope.platinumCount}</strong>
                                    </div>
                                    <div style="background: rgba(0, 191, 197, 0.08); height: 8px; border-radius: 4px; overflow: hidden;">
                                        <div style="background: var(--tier-platinum); height: 100%; width: ${requestScope.totalCustomers > 0 ? (requestScope.platinumCount * 100 / requestScope.totalCustomers) : 0}%"></div>
                                    </div>
                                </div>
                                <div>
                                    <div style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 0.25rem;">
                                        <span>Gold Elite</span>
                                        <strong style="color: var(--tier-gold);">${requestScope.goldCount}</strong>
                                    </div>
                                    <div style="background: rgba(0, 191, 197, 0.08); height: 8px; border-radius: 4px; overflow: hidden;">
                                        <div style="background: var(--tier-gold); height: 100%; width: ${requestScope.totalCustomers > 0 ? (requestScope.goldCount * 100 / requestScope.totalCustomers) : 0}%"></div>
                                    </div>
                                </div>
                                <div>
                                    <div style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 0.25rem;">
                                        <span>Silver Priority</span>
                                        <strong style="color: var(--tier-silver);">${requestScope.silverCount}</strong>
                                    </div>
                                    <div style="background: rgba(0, 191, 197, 0.08); height: 8px; border-radius: 4px; overflow: hidden;">
                                        <div style="background: var(--tier-silver); height: 100%; width: ${requestScope.totalCustomers > 0 ? (requestScope.silverCount * 100 / requestScope.totalCustomers) : 0}%"></div>
                                    </div>
                                </div>
                                <div>
                                    <div style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 0.25rem;">
                                        <span>Member Core</span>
                                        <strong style="color: var(--tier-member);">${requestScope.memberCount}</strong>
                                    </div>
                                    <div style="background: rgba(0, 191, 197, 0.08); height: 8px; border-radius: 4px; overflow: hidden;">
                                        <div style="background: var(--tier-member); height: 100%; width: ${requestScope.totalCustomers > 0 ? (requestScope.memberCount * 100 / requestScope.totalCustomers) : 0}%"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <h2 style="margin-top: 2.5rem; margin-bottom: 0.5rem;">Priority Bookings Queue</h2>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1rem;">
                    * Queue is prioritized automatically: <strong>PENDING Bookings first</strong>, sorted by <strong>Loyalty Tier</strong> (Platinum > Gold > Silver > Member) to ensure priority slot allocation.
                </p>
                <div class="card" style="overflow-x: auto;">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Customer Details</th>
                                <th>Tier Level</th>
                                <th>Booking Date & Time</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.bookings}">
                                    <c:forEach var="b" items="${requestScope.bookings}">
                                        <tr style="${b.status eq 'PENDING' ? 'background: rgba(14, 165, 233, 0.03);' : ''}">
                                            <td>#${b.id}</td>
                                            <td>
                                                <strong>${b.user.fullName}</strong><br>
                                                <span style="font-size: 0.85rem; color: var(--text-muted);">${b.user.phone} | ${b.user.licensePlate}</span>
                                            </td>
                                            <td>
                                                <span class="tier-badge tier-${b.user.tier}">${b.user.tier}</span>
                                            </td>
                                            <td>${b.bookingDate}</td>
                                            <td>
                                                <span style="padding: 0.25rem 0.5rem; border-radius: 4px; font-weight: 600; font-size: 0.8rem;
                                                             background: ${b.status eq 'COMPLETED' ? 'rgba(16, 185, 129, 0.15)' : b.status eq 'PENDING' ? 'rgba(14, 165, 233, 0.15)' : 'rgba(255,255,255,0.05)'};
                                                             color: ${b.status eq 'COMPLETED' ? '#10b981' : b.status eq 'PENDING' ? 'var(--accent)' : 'var(--text-muted)'}">
                                                    ${b.status}
                                                </span>
                                            </td>
                                            <td>
                                                <c:if test="${b.status eq 'PENDING'}">
                                                    <form action="${pageContext.request.contextPath}/completeBooking" method="POST" style="margin: 0;">
                                                        <input type="hidden" name="bookingId" value="${b.id}">
                                                        <input type="hidden" name="userId" value="${b.userId}">
                                                        <button type="submit" class="btn btn-primary" style="padding: 0.35rem 0.75rem; font-size: 0.8rem; width: auto; background: #10b981;">Complete Wash</button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" style="text-align: center; color: var(--text-muted);">No bookings in queue.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
