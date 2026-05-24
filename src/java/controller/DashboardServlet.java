package controller;

import dao.BookingDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.User;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("account");
        
        if (u == null) {
            response.sendRedirect("login");
            return;
        }
        
        UserDAO uDao = new UserDAO();
        u = uDao.getUserById(u.getId());
        session.setAttribute("account", u);
        
        BookingDAO bDao = new BookingDAO();
        
        if (u.getRole().equals("ADMIN")) {
            List<Booking> allBookings = bDao.getAllBookings();
            for (Booking b : allBookings) {
                b.setUser(uDao.getUserById(b.getUserId()));
            }
            request.setAttribute("bookings", allBookings);
            
            // Reports stats
            request.setAttribute("totalCustomers", uDao.getTotalCustomers());
            request.setAttribute("totalRevenue", uDao.getTotalRevenue());
            request.setAttribute("memberCount", uDao.getCustomerCountByTier("Member"));
            request.setAttribute("silverCount", uDao.getCustomerCountByTier("Silver"));
            request.setAttribute("goldCount", uDao.getCustomerCountByTier("Gold"));
            request.setAttribute("platinumCount", uDao.getCustomerCountByTier("Platinum"));
            
            // Promotions list
            dao.PromotionDAO pDao = new dao.PromotionDAO();
            request.setAttribute("promotions", pDao.getAllPromotions());
            
            request.getRequestDispatcher("admin/dashboard.jsp").forward(request, response);
        } else {
            List<Booking> myBookings = bDao.getBookingsByUserId(u.getId());
            request.setAttribute("myBookings", myBookings);
            
            dao.PromotionDAO pDao = new dao.PromotionDAO();
            request.setAttribute("eligiblePromos", pDao.getEligiblePromotions(u.getTier()));
            request.setAttribute("myRedemptions", pDao.getRedemptionsByUserId(u.getId()));
            
            request.getRequestDispatcher("customer/dashboard.jsp").forward(request, response);
        }
    }
}
