package controller;

import dao.BookingDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "CompleteBookingServlet", urlPatterns = {"/completeBooking"})
public class CompleteBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("account");
        
        if (u == null || !u.getRole().equals("ADMIN")) {
            response.sendRedirect("login");
            return;
        }
        
        String bookingIdStr = request.getParameter("bookingId");
        String userIdStr = request.getParameter("userId");
        
        if (bookingIdStr != null && userIdStr != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                int userId = Integer.parseInt(userIdStr);
                
                BookingDAO bDao = new BookingDAO();
                UserDAO uDao = new UserDAO();
                
                // Set booking to COMPLETED
                if (bDao.updateBookingStatus(bookingId, "COMPLETED")) {
                    double washCost = 500000.0; // Assume each wash is 500k VND
                    
                    // Update user stats and get points earned
                    int pointsEarned = uDao.updateUserStats(userId, washCost);
                    
                    // Insert into Transactions
                    bDao.insertTransaction(userId, bookingId, washCost, pointsEarned);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("dashboard");
    }
}
