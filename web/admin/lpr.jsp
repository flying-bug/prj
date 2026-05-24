<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${empty sessionScope.account or sessionScope.account.role ne 'ADMIN'}">
    <c:redirect url="../login" />
</c:if>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LPR Simulator - AutoWash Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=vinfast">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
    <div class="dashboard-layout">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-brand">AutoWash Admin</div>
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/lpr">LPR Simulator</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/promotions">Promotions</a></li>
            </ul>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <span style="font-weight: 600; font-size: 1.1rem; color: var(--text-main);">LPR Automation Simulator</span>
                <div style="display: flex; align-items: center; gap: 1rem;">
                    <span style="color: var(--text-muted); font-size: 0.9rem;">Administrator</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 0.35rem 0.75rem; font-size: 0.85rem;">Logout</a>
                </div>
            </div>
            
            <!-- Content Wrapper -->
            <div class="content-wrapper">
                <h2 style="margin-bottom: 0.5rem;">Entrance Camera Scanner</h2>
                <p style="color: var(--text-muted); margin-bottom: 2rem;">
                    Simulate smart License Plate Recognition captures at the entrance to load loyalty details and record direct drive-in washes instantly.
                </p>

                <div class="card" style="max-width: 900px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e2e8f0; padding-bottom: 0.5rem; margin-bottom: 1.5rem;">
                        <h3 style="margin: 0;">Entrance Camera Sim</h3>
                        <span style="background: #10b981; color: white; padding: 0.2rem 0.6rem; border-radius: 4px; font-size: 0.75rem; font-weight: bold;">CAMERA ACTIVE</span>
                    </div>
                    
                    <c:if test="${not empty sessionScope.lprSuccess}">
                        <div class="success-msg">${sessionScope.lprSuccess}</div>
                        <% session.removeAttribute("lprSuccess"); %>
                    </c:if>
                    <c:if test="${not empty sessionScope.lprError}">
                        <div class="error-msg">${sessionScope.lprError}</div>
                        <% session.removeAttribute("lprError"); %>
                    </c:if>
    
                    <div style="display: flex; gap: 2rem; flex-wrap: wrap;">
                        <!-- Input simulator Form -->
                        <div style="flex: 1; min-width: 280px;">
                            <form action="${pageContext.request.contextPath}/admin/lpr" method="POST">
                                <input type="hidden" name="action" value="scan">
                                <div class="form-group">
                                    <label style="font-weight: 600; margin-bottom: 0.5rem; display: block;">Simulated License Plate Capture</label>
                                    <input type="text" name="licensePlate" class="form-control" placeholder="e.g. 29A-12345" required 
                                           value="${not empty sessionScope.scannedCustomer ? sessionScope.scannedCustomer.licensePlate : ''}"
                                           style="font-size: 1.1rem; padding: 0.75rem; text-transform: uppercase;">
                                </div>
                                <button type="submit" class="btn btn-primary" style="margin-top: 0.5rem; width: 100%;">Scan & Recognize Vehicle</button>
                            </form>
                            
                            <div style="margin-top: 1.5rem; background: rgba(255, 255, 255, 0.02); border: 1px solid rgba(255, 255, 255, 0.05); padding: 1rem; border-radius: 6px;">
                                <h4 style="margin-top: 0; margin-bottom: 0.5rem; font-size: 0.9rem; color: var(--text-main);">Demo Seed Plates:</h4>
                                <ul style="margin: 0; padding-left: 1.25rem; font-size: 0.85rem; color: var(--text-muted); line-height: 1.6;">
                                    <li><strong>29A-12345</strong> (Member tier)</li>
                                    <li><strong>30K-99999</strong> (Gold tier)</li>
                                    <li><strong>51G-88888</strong> (Platinum tier)</li>
                                </ul>
                            </div>
                        </div>
    
                        <!-- Scanner result view -->
                        <div style="flex: 1.5; min-width: 320px; background: rgba(0, 191, 197, 0.02); border-radius: 8px; padding: 1.5rem; border: 1px dashed rgba(0, 191, 197, 0.25);">
                            <c:choose>
                                <c:when test="${not empty sessionScope.scannedCustomer}">
                                    <h4 style="color: var(--accent); margin-top: 0; margin-bottom: 1rem; font-size: 1.1rem;">Vehicle Identified!</h4>
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem; font-size: 0.95rem;">
                                        <div>Owner: <strong>${sessionScope.scannedCustomer.fullName}</strong></div>
                                        <div>License Plate: <strong style="color: var(--tier-gold);">${sessionScope.scannedCustomer.licensePlate}</strong></div>
                                        <div>Loyalty Tier: <span class="tier-badge tier-${sessionScope.scannedCustomer.tier}">${sessionScope.scannedCustomer.tier}</span></div>
                                        <div>Phone: ${sessionScope.scannedCustomer.phone}</div>
                                        <div>Loyalty Points: <strong style="color: var(--primary-color);">${sessionScope.scannedCustomer.points}</strong></div>
                                        <div>Washes Completed: ${sessionScope.scannedCustomer.washCount}</div>
                                        <div style="grid-column: span 2;">Total Spent: <strong><fmt:formatNumber value="${sessionScope.scannedCustomer.totalSpent}" pattern="#,##0"/> VND</strong></div>
                                    </div>
                                    <div style="display: flex; gap: 0.5rem; margin-top: 1.5rem;">
                                        <form action="${pageContext.request.contextPath}/admin/lpr" method="POST" style="margin: 0; flex: 1;">
                                            <input type="hidden" name="action" value="logWash">
                                            <input type="hidden" name="userId" value="${sessionScope.scannedCustomer.id}">
                                            <button type="submit" class="btn btn-primary" style="padding: 0.6rem; font-size: 0.9rem; width: 100%;">Log Wash & Add Points</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/lpr" method="POST" style="margin: 0;">
                                            <input type="hidden" name="action" value="clear">
                                            <button type="submit" class="btn btn-secondary" style="padding: 0.6rem; font-size: 0.9rem;">Clear Scan</button>
                                        </form>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p style="text-align: center; color: var(--text-muted); margin-top: 3rem;">
                                        Scan a simulated license plate from the left pane to load customer profile details and record direct drive-in washes.
                                    </p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
