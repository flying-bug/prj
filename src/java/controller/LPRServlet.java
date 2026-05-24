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

@WebServlet(name = "LPRServlet", urlPatterns = {"/admin/lpr"})
public class LPRServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/lpr.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("account");
        if (u == null || !u.getRole().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        UserDAO uDao = new UserDAO();

        if ("scan".equals(action)) {
            String plate = request.getParameter("licensePlate");
            if (plate != null) {
                plate = plate.trim();
                User customer = uDao.getUserByLicensePlate(plate);
                if (customer != null) {
                    session.setAttribute("scannedCustomer", customer);
                    session.removeAttribute("lprError");
                } else {
                    session.removeAttribute("scannedCustomer");
                    session.setAttribute("lprError", "No customer found with plate: " + plate);
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/lpr");
            
        } else if ("logWash".equals(action)) {
            String userIdStr = request.getParameter("userId");
            if (userIdStr != null) {
                try {
                    int userId = Integer.parseInt(userIdStr);
                    double washCost = 500000.0; // 500,000 VND for standard wash
                    
                    // 1. Update user stats in DB (earns points + triggers tier upgrade calculation)
                    int pointsEarned = uDao.updateUserStats(userId, washCost);
                    
                    // 2. Insert transaction log (with bookingId = null as this is direct LPR drive-in wash)
                    BookingDAO bDao = new BookingDAO();
                    bDao.insertTransaction(userId, -1, washCost, pointsEarned); // bookingId = -1 or null
                    
                    // Reload customer details to show updated stats
                    User updatedCustomer = uDao.getUserById(userId);
                    session.setAttribute("scannedCustomer", updatedCustomer);
                    session.setAttribute("lprSuccess", "Wash logged successfully! Earned " + pointsEarned + " points. Current tier: " + updatedCustomer.getTier());
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/lpr");
        } else if ("clear".equals(action)) {
            session.removeAttribute("scannedCustomer");
            session.removeAttribute("lprError");
            session.removeAttribute("lprSuccess");
            response.sendRedirect(request.getContextPath() + "/admin/lpr");
        }
    }
}
