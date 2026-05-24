package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String licensePlate = request.getParameter("licensePlate");
        
        User newUser = new User();
        newUser.setUsername(user);
        newUser.setPassword(pass);
        newUser.setFullName(fullName);
        newUser.setPhone(phone);
        newUser.setLicensePlate(licensePlate);
        
        UserDAO dao = new UserDAO();
        boolean success = dao.register(newUser);
        
        if (success) {
            response.sendRedirect("login?msg=RegisteredSuccessfully");
        } else {
            request.setAttribute("error", "Registration failed. Username or License Plate might exist.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
