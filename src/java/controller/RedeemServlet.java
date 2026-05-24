package controller;

import dao.PromotionDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Promotion;
import model.User;

@WebServlet(name = "RedeemServlet", urlPatterns = {"/redeem"})
public class RedeemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("account");
        if (u == null) {
            response.sendRedirect("login");
            return;
        }

        String promoIdStr = request.getParameter("promoId");
        if (promoIdStr != null) {
            try {
                int promoId = Integer.parseInt(promoIdStr);
                PromotionDAO pDao = new PromotionDAO();
                
                // Find the promotion
                List<Promotion> promotions = pDao.getAllPromotions();
                Promotion selectedPromo = null;
                for (Promotion p : promotions) {
                    if (p.getId() == promoId) {
                        selectedPromo = p;
                        break;
                    }
                }

                if (selectedPromo != null) {
                    // Reload user to verify current points
                    UserDAO uDao = new UserDAO();
                    u = uDao.getUserById(u.getId());
                    session.setAttribute("account", u);

                    if (u.getPoints() >= selectedPromo.getRequiredPoints()) {
                        boolean success = pDao.redeemPromotion(u.getId(), selectedPromo.getId(), selectedPromo.getRequiredPoints());
                        if (success) {
                            // Update user in session
                            u = uDao.getUserById(u.getId());
                            session.setAttribute("account", u);
                            response.sendRedirect("dashboard?msg=RedeemedSuccessfully");
                            return;
                        } else {
                            response.sendRedirect("dashboard?error=RedemptionFailed");
                            return;
                        }
                    } else {
                        response.sendRedirect("dashboard?error=NotEnoughPoints");
                        return;
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("dashboard");
    }
}
