package controller;

import dao.BookingDAO;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.User;

@WebServlet(name = "BookingServlet", urlPatterns = {"/book"})
public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("account");
        if (u == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Calculate max advance booking days based on tier
        int advanceDays = 7; // Member
        if (u.getTier().equals("Silver")) advanceDays = 10;
        else if (u.getTier().equals("Gold")) advanceDays = 12;
        else if (u.getTier().equals("Platinum")) advanceDays = 14;
        
        request.setAttribute("advanceDays", advanceDays);
        request.getRequestDispatcher("customer/book.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("account");
        if (u == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Reload user from DB to ensure freshest tier data
        dao.UserDAO uDao = new dao.UserDAO();
        u = uDao.getUserById(u.getId());
        session.setAttribute("account", u);
        
        int advanceDays = 7; // Member
        if (u.getTier().equals("Silver")) advanceDays = 10;
        else if (u.getTier().equals("Gold")) advanceDays = 12;
        else if (u.getTier().equals("Platinum")) advanceDays = 14;
        
        String dateStr = request.getParameter("bookingDate");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        try {
            Date bookingDate = sdf.parse(dateStr);
            Date now = new Date();
            
            // Check if booking date is in the future
            if (bookingDate.before(now)) {
                request.setAttribute("advanceDays", advanceDays);
                request.setAttribute("error", "Booking date must be in the future.");
                request.getRequestDispatcher("customer/book.jsp").forward(request, response);
                return;
            }
            
            // Calculate difference in days (ceiling division)
            long diffInMillis = bookingDate.getTime() - now.getTime();
            double diffInDays = (double) diffInMillis / (1000 * 60 * 60 * 24);
            
            if (diffInDays > advanceDays) {
                request.setAttribute("advanceDays", advanceDays);
                request.setAttribute("error", "Your " + u.getTier() + " tier only allows booking up to " + advanceDays + " days in advance.");
                request.getRequestDispatcher("customer/book.jsp").forward(request, response);
                return;
            }
            
            Booking b = new Booking();
            b.setUserId(u.getId());
            b.setBookingDate(bookingDate);
            b.setStatus("PENDING");
            
            BookingDAO dao = new BookingDAO();
            if (dao.createBooking(b)) {
                response.sendRedirect("dashboard?msg=BookingSuccessful");
            } else {
                request.setAttribute("advanceDays", advanceDays);
                request.setAttribute("error", "Failed to create booking.");
                request.getRequestDispatcher("customer/book.jsp").forward(request, response);
            }
        } catch (ParseException ex) {
            Logger.getLogger(BookingServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("advanceDays", advanceDays);
            request.setAttribute("error", "Invalid date format.");
            request.getRequestDispatcher("customer/book.jsp").forward(request, response);
        }
    }
}
