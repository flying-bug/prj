<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.account or sessionScope.account.role ne 'ADMIN'}">
    <c:redirect url="../login" />
</c:if>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Promotions - AutoWash Admin</title>
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
                <li><a href="${pageContext.request.contextPath}/admin/lpr">LPR Simulator</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/promotions">Promotions</a></li>
            </ul>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <span style="font-weight: 600; font-size: 1.1rem; color: var(--text-main);">Manage Promotions</span>
                <div style="display: flex; align-items: center; gap: 1rem;">
                    <span style="color: var(--text-muted); font-size: 0.9rem;">Administrator</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 0.35rem 0.75rem; font-size: 0.85rem;">Logout</a>
                </div>
            </div>
            
            <!-- Content Wrapper -->
            <div class="content-wrapper">
                <h2 style="margin-bottom: 0.5rem;">Rewards & Targeted Benefits</h2>
                <p style="color: var(--text-muted); margin-bottom: 2rem;">Configure rewards and targeted loyalty benefits for users.</p>
        
                <c:if test="${param.msg eq 'PromotionCreated'}">
                    <div class="success-msg">New promotion created successfully!</div>
                </c:if>
                <c:if test="${param.msg eq 'PromotionUpdated'}">
                    <div class="success-msg">Promotion updated successfully!</div>
                </c:if>
                <c:if test="${param.msg eq 'PromotionDeleted'}">
                    <div class="success-msg">Promotion deleted successfully!</div>
                </c:if>
                <c:if test="${param.error eq 'FailedToCreate'}">
                    <div class="error-msg">Failed to create promotion. Please try again.</div>
                </c:if>
                <c:if test="${param.error eq 'FailedToUpdate'}">
                    <div class="error-msg">Failed to update promotion. Please try again.</div>
                </c:if>
                <c:if test="${param.error eq 'FailedToDelete'}">
                    <div class="error-msg">Failed to delete promotion. Please try again.</div>
                </c:if>
        
                <div class="dashboard-sections">
                    <!-- New/Edit Promotion Form -->
                    <div class="dashboard-section" style="max-width: 400px;">
                        <div class="card">
                            <c:choose>
                                <c:when test="${not empty editPromo}">
                                    <h3>Edit Promotion</h3>
                                    <form action="promotions" method="POST" style="margin-top: 1.5rem;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="id" value="${editPromo.id}">
                                        
                                        <div class="form-group">
                                            <label>Promotion Name</label>
                                            <input type="text" name="name" class="form-control" required placeholder="e.g. Free Waxing" value="${editPromo.name}">
                                        </div>
                                        <div class="form-group">
                                            <label>Description</label>
                                            <textarea name="description" class="form-control" rows="3" required placeholder="Details about this promotion...">${editPromo.description}</textarea>
                                        </div>
                                        <div class="form-group">
                                            <label>Required Points</label>
                                            <input type="number" name="requiredPoints" class="form-control" min="0" required placeholder="e.g. 300" value="${editPromo.requiredPoints}">
                                        </div>
                                        <div class="form-group">
                                            <label>Target Tier</label>
                                            <select name="targetTier" class="form-control" required>
                                                <option value="Member" ${editPromo.targetTier eq 'Member' ? 'selected' : ''}>Member</option>
                                                <option value="Silver" ${editPromo.targetTier eq 'Silver' ? 'selected' : ''}>Silver</option>
                                                <option value="Gold" ${editPromo.targetTier eq 'Gold' ? 'selected' : ''}>Gold</option>
                                                <option value="Platinum" ${editPromo.targetTier eq 'Platinum' ? 'selected' : ''}>Platinum</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-primary" style="margin-top: 1rem; width: 100%;">Update Promotion</button>
                                        <a href="promotions" class="btn btn-secondary" style="margin-top: 0.5rem; display: block; text-align: center; text-decoration: none;">Cancel</a>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <h3>Create New Promotion</h3>
                                    <form action="promotions" method="POST" style="margin-top: 1.5rem;">
                                        <div class="form-group">
                                            <label>Promotion Name</label>
                                            <input type="text" name="name" class="form-control" required placeholder="e.g. Free Waxing">
                                        </div>
                                        <div class="form-group">
                                            <label>Description</label>
                                            <textarea name="description" class="form-control" rows="3" required placeholder="Details about this promotion..."></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label>Required Points</label>
                                            <input type="number" name="requiredPoints" class="form-control" min="0" required placeholder="e.g. 300">
                                        </div>
                                        <div class="form-group">
                                            <label>Target Tier</label>
                                            <select name="targetTier" class="form-control" required>
                                                <option value="Member">Member</option>
                                                <option value="Silver">Silver</option>
                                                <option value="Gold">Gold</option>
                                                <option value="Platinum">Platinum</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-primary" style="margin-top: 1rem; width: 100%;">Create Promotion</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
        
                    <!-- Existing Promotions List -->
                    <div class="dashboard-section wide">
                        <div class="card">
                            <h3>Active Promotions</h3>
                            <div style="overflow-x: auto; margin-top: 1.5rem;">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Name</th>
                                            <th>Target Tier</th>
                                            <th>Required Points</th>
                                            <th>Description</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty requestScope.promotions}">
                                                <c:forEach var="p" items="${requestScope.promotions}">
                                                    <tr>
                                                        <td><strong>${p.name}</strong></td>
                                                        <td>
                                                            <span class="tier-badge tier-${p.targetTier}">${p.targetTier}+</span>
                                                        </td>
                                                        <td style="color: var(--accent); font-weight: bold;">${p.requiredPoints} pts</td>
                                                        <td style="color: var(--text-muted); font-size: 0.9rem;">${p.description}</td>
                                                        <td>
                                                            <div style="display: flex; gap: 0.25rem;">
                                                                <a href="${pageContext.request.contextPath}/admin/promotions?action=edit&id=${p.id}" class="btn btn-primary" style="padding: 0.25rem 0.5rem; font-size: 0.8rem; text-decoration: none; width: auto; font-weight: normal; background: var(--primary-color);">Edit</a>
                                                                <form action="promotions" method="POST" style="margin: 0;" onsubmit="return confirm('Are you sure you want to delete this promotion?');">
                                                                    <input type="hidden" name="action" value="delete">
                                                                    <input type="hidden" name="id" value="${p.id}">
                                                                    <button type="submit" class="btn btn-secondary" style="padding: 0.25rem 0.5rem; font-size: 0.8rem; background: #dc2626; color: white; border: none; width: auto; cursor: pointer;">Delete</button>
                                                                </form>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="5" style="text-align: center; color: var(--text-muted);">No promotions found.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
