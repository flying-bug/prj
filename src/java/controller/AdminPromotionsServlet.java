package controller;

import dao.PromotionDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Promotion;
import model.User;

@WebServlet(name = "AdminPromotionsServlet", urlPatterns = {"/admin/promotions"})
public class AdminPromotionsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("account");
        if (u == null || !u.getRole().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        PromotionDAO pDao = new PromotionDAO();
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    Promotion editPromo = pDao.getPromotionById(id);
                    request.setAttribute("editPromo", editPromo);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }

        request.setAttribute("promotions", pDao.getAllPromotions());
        request.getRequestDispatcher("promotions.jsp").forward(request, response);
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
        PromotionDAO pDao = new PromotionDAO();

        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    if (pDao.deletePromotion(id)) {
                        response.sendRedirect("promotions?msg=PromotionDeleted");
                        return;
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("promotions?error=FailedToDelete");
            return;
            
        } else if ("update".equals(action)) {
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String ptsStr = request.getParameter("requiredPoints");
            String targetTier = request.getParameter("targetTier");
            
            if (idStr != null && name != null && ptsStr != null && targetTier != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    int requiredPoints = Integer.parseInt(ptsStr);
                    Promotion promo = new Promotion(id, name, description, requiredPoints, targetTier);
                    if (pDao.updatePromotion(promo)) {
                        response.sendRedirect("promotions?msg=PromotionUpdated");
                        return;
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("promotions?error=FailedToUpdate");
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String ptsStr = request.getParameter("requiredPoints");
        String targetTier = request.getParameter("targetTier");

        if (name != null && ptsStr != null && targetTier != null) {
            try {
                int requiredPoints = Integer.parseInt(ptsStr);
                Promotion promo = new Promotion();
                promo.setName(name);
                promo.setDescription(description);
                promo.setRequiredPoints(requiredPoints);
                promo.setTargetTier(targetTier);

                if (pDao.createPromotion(promo)) {
                    response.sendRedirect("promotions?msg=PromotionCreated");
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("promotions?error=FailedToCreate");
    }
}
