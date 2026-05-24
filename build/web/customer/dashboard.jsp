<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${empty sessionScope.account or sessionScope.account.role ne 'CUSTOMER'}">
    <c:redirect url="../login" />
</c:if>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - AutoWash Pro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=vinfast">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<<body>
    <div class="dashboard-layout">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-brand">AutoWash Customer</div>
            <ul class="sidebar-menu">
                <li class="active"><a href="${pageContext.request.contextPath}/dashboard">My Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/book">Book a Wash</a></li>
            </ul>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <span style="font-weight: 600; font-size: 1.1rem; color: var(--text-main);">Customer Panel</span>
                <div style="display: flex; align-items: center; gap: 1rem;">
                    <span style="color: var(--text-muted); font-size: 0.9rem;">Hello, ${sessionScope.account.fullName}</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 0.35rem 0.75rem; font-size: 0.85rem;">Logout</a>
                </div>
            </div>
            
            <!-- Content Wrapper -->
            <div class="content-wrapper">
                <c:if test="${param.msg eq 'BookingSuccessful'}">
                    <div class="success-msg">Your booking was successful!</div>
                </c:if>
                <c:if test="${param.msg eq 'RedeemedSuccessfully'}">
                    <div class="success-msg">Reward redeemed successfully! Points deducted. Check 'My Redeemed Rewards' below.</div>
                </c:if>
                <c:if test="${param.error eq 'NotEnoughPoints'}">
                    <div class="error-msg">Failed to redeem: You do not have enough loyalty points.</div>
                </c:if>
                <c:if test="${param.error eq 'RedemptionFailed'}">
                    <div class="error-msg">Failed to redeem reward. Please try again.</div>
                </c:if>
                
                <h2>My Profile</h2>
                
                <!-- Stats Row -->
                <div class="stats-row">
                    <div class="stat-card">
                        <h3>Loyalty Tier</h3>
                        <div class="tier-badge tier-${sessionScope.account.tier}" style="font-size: 1.2rem; padding: 0.25rem 0.75rem; margin-bottom: 0.5rem;">${sessionScope.account.tier}</div>
                        <p style="margin-top: 0.5rem; color: var(--text-muted); font-size: 0.9rem;">Points: <strong style="color: var(--primary-color);">${sessionScope.account.points}</strong></p>
                    </div>
                    <div class="stat-card">
                        <h3>Washes & Spending</h3>
                        <div class="stat-value" style="font-size: 1.5rem; color: var(--primary-color);">${sessionScope.account.washCount} washes</div>
                        <p style="margin-top: 0.5rem; color: var(--text-muted); font-size: 0.9rem;">Spent: <strong><fmt:formatNumber value="${sessionScope.account.totalSpent}" pattern="#,##0"/> VND</strong></p>
                    </div>
                    <div class="stat-card" style="flex: 1.5;">
                        <h3>Vehicle & Contact</h3>
                        <p style="font-size: 1.05rem; margin-bottom: 0.25rem;">License Plate: <strong style="color: var(--accent);">${sessionScope.account.licensePlate}</strong></p>
                        <p style="font-size: 0.9rem; color: var(--text-muted);">Phone: ${sessionScope.account.phone}</p>
                    </div>
                </div>
                
                <div class="dashboard-sections">
                    <div class="dashboard-section" style="max-width: 400px;">
                        <div class="card">
                            <h3>Next Reward Tier Upgrade</h3>
                            <div style="margin-top: 1rem; font-size: 0.95rem; line-height: 1.5;">
                                <c:choose>
                                    <c:when test="${sessionScope.account.tier eq 'Member'}">
                                        <p>Reach 5 washes or 2M VND to upgrade to <strong>Silver</strong> (+10% points, priority slot).</p>
                                        <p style="margin-top: 0.5rem; font-size: 0.85rem; color: var(--primary-color);">Progress: ${sessionScope.account.washCount}/5 washes OR <fmt:formatNumber value="${sessionScope.account.totalSpent}" pattern="#,##0"/>/2,000,000 VND</p>
                                    </c:when>
                                    <c:when test="${sessionScope.account.tier eq 'Silver'}">
                                        <p>Reach 15 washes or 6M VND to upgrade to <strong>Gold</strong> (+20% points, free upgrade monthly).</p>
                                        <p style="margin-top: 0.5rem; font-size: 0.85rem; color: var(--primary-color);">Progress: ${sessionScope.account.washCount}/15 washes OR <fmt:formatNumber value="${sessionScope.account.totalSpent}" pattern="#,##0"/>/6,000,000 VND</p>
                                    </c:when>
                                    <c:when test="${sessionScope.account.tier eq 'Gold'}">
                                        <p>Reach 30 washes or 15M VND to upgrade to <strong>Platinum</strong> (+30% points, free wash monthly).</p>
                                        <p style="margin-top: 0.5rem; font-size: 0.85rem; color: var(--primary-color);">Progress: ${sessionScope.account.washCount}/30 washes OR <fmt:formatNumber value="${sessionScope.account.totalSpent}" pattern="#,##0"/>/15,000,000 VND</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p>You are at the maximum tier! Enjoy your Platinum benefits.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="card" style="margin-top: 1.5rem;">
                            <h3>My Redeemed Rewards</h3>
                            <p style="color: var(--text-muted); font-size: 0.85rem; margin-bottom: 1rem;">Show this screen to receptionist to claim.</p>
                            <div style="max-height: 250px; overflow-y: auto; display: flex; flex-direction: column; gap: 0.75rem;">
                                <c:choose>
                                    <c:when test="${not empty requestScope.myRedemptions}">
                                        <c:forEach var="r" items="${requestScope.myRedemptions}">
                                            <div style="background: rgba(0, 191, 197, 0.02); border: 1px solid rgba(0, 191, 197, 0.1); padding: 0.75rem; border-radius: 6px;">
                                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                                    <strong style="color: var(--text-main); font-size: 0.85rem;">${r.promotionName}</strong>
                                                    <span style="font-size: 0.7rem; color: #059669; font-weight: bold; background: rgba(5, 150, 105, 0.08); padding: 0.1rem 0.4rem; border-radius: 4px;">${r.status}</span>
                                                </div>
                                                <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 0.25rem;">${r.promotionDescription}</p>
                                                <span style="font-size: 0.7rem; color: var(--text-muted); display: block; margin-top: 0.5rem;">Redeemed: ${r.redeemedDate}</span>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="color: var(--text-muted); font-size: 0.85rem; text-align: center; padding: 1.5rem 0;">No rewards claimed yet.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <div class="dashboard-section wide">
                        <div class="card">
                            <h3>Eligible Rewards (Redemption Center)</h3>
                            <p style="color: var(--text-muted); font-size: 0.85rem; margin-bottom: 1rem;">Spend points to claim special discounts & benefits.</p>
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1rem;">
                                <c:choose>
                                    <c:when test="${not empty requestScope.eligiblePromos}">
                                        <c:forEach var="p" items="${requestScope.eligiblePromos}">
                                            <div style="background: rgba(0, 191, 197, 0.02); border: 1px solid rgba(0, 191, 197, 0.12); padding: 1rem; border-radius: 8px; display: flex; flex-direction: column; justify-content: space-between;">
                                                <div>
                                                    <div style="display: flex; justify-content: space-between; align-items: start;">
                                                        <h4 style="color: var(--primary-color); margin: 0; font-size: 1rem;">${p.name}</h4>
                                                        <span class="tier-badge tier-${p.targetTier}" style="font-size: 0.7rem; padding: 0.1rem 0.4rem;">${p.targetTier}+</span>
                                                    </div>
                                                    <p style="font-size: 0.85rem; color: var(--text-muted); margin-top: 0.5rem;">${p.description}</p>
                                                </div>
                                                <div style="margin-top: 1.5rem; display: flex; justify-content: space-between; align-items: center; border-top: 1px solid rgba(0, 191, 197, 0.08); padding-top: 0.5rem;">
                                                    <span style="font-weight: bold; color: var(--tier-gold);">${p.requiredPoints} pts</span>
                                                    <c:choose>
                                                        <c:when test="${sessionScope.account.points >= p.requiredPoints}">
                                                            <form action="${pageContext.request.contextPath}/redeem" method="POST" style="margin:0;">
                                                                <input type="hidden" name="promoId" value="${p.id}">
                                                                <button type="submit" class="btn btn-primary" style="padding: 0.35rem 0.75rem; font-size: 0.8rem; width: auto; background: var(--primary-color);">Redeem</button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn btn-secondary" disabled style="padding: 0.35rem 0.75rem; font-size: 0.8rem; cursor: not-allowed; opacity: 0.5; width: auto;">Locked</button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="color: var(--text-muted); font-size: 0.85rem;">No rewards available for your tier.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
                
                <h2>Wash History & Bookings</h2>
                <div class="card" style="margin-top: 1rem; overflow-x: auto;">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Date & Time</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.myBookings}">
                                    <c:forEach var="b" items="${requestScope.myBookings}">
                                        <tr>
                                            <td>#${b.id}</td>
                                            <td>${b.bookingDate}</td>
                                            <td>
                                                <span style="padding: 0.25rem 0.5rem; border-radius: 4px; font-weight: 600; font-size: 0.8rem;
                                                             background: ${b.status eq 'COMPLETED' ? 'rgba(16, 185, 129, 0.15)' : b.status eq 'PENDING' ? 'rgba(14, 165, 233, 0.15)' : 'rgba(255,255,255,0.05)'};
                                                             color: ${b.status eq 'COMPLETED' ? '#10b981' : b.status eq 'PENDING' ? 'var(--accent)' : 'var(--text-muted)'}">
                                                    ${b.status}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" style="text-align: center; color: var(--text-muted);">No bookings found.</td>
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
