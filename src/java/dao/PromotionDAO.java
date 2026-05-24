package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Promotion;
import model.Redemption;
import util.DBContext;

public class PromotionDAO extends DBContext {

    public List<Promotion> getAllPromotions() {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT * FROM Promotions ORDER BY requiredPoints ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Promotion(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getInt("requiredPoints"),
                        rs.getString("targetTier")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(PromotionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<Promotion> getEligiblePromotions(String userTier) {
        List<Promotion> list = new ArrayList<>();
        // Tier ranking: Member = 1, Silver = 2, Gold = 3, Platinum = 4
        List<String> allowedTiers = new ArrayList<>();
        allowedTiers.add("Member");
        if (userTier.equals("Silver") || userTier.equals("Gold") || userTier.equals("Platinum")) {
            allowedTiers.add("Silver");
        }
        if (userTier.equals("Gold") || userTier.equals("Platinum")) {
            allowedTiers.add("Gold");
        }
        if (userTier.equals("Platinum")) {
            allowedTiers.add("Platinum");
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM Promotions WHERE targetTier IN (");
        for (int i = 0; i < allowedTiers.size(); i++) {
            sql.append("?");
            if (i < allowedTiers.size() - 1) {
                sql.append(",");
            }
        }
        sql.append(") ORDER BY requiredPoints ASC");

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < allowedTiers.size(); i++) {
                st.setString(i + 1, allowedTiers.get(i));
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Promotion(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getInt("requiredPoints"),
                        rs.getString("targetTier")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(PromotionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean redeemPromotion(int userId, int promotionId, int pointsNeeded) {
        String updatePointsSql = "UPDATE Users SET points = points - ? WHERE id = ? AND points >= ?";
        String insertRedemptionSql = "INSERT INTO Redemptions (userId, promotionId, status) VALUES (?, ?, 'ACTIVE')";
        
        try {
            // Enable manual transaction control
            connection.setAutoCommit(false);
            
            // 1. Deduct points (with check that points >= needed)
            try (PreparedStatement psUpdate = connection.prepareStatement(updatePointsSql)) {
                psUpdate.setInt(1, pointsNeeded);
                psUpdate.setInt(2, userId);
                psUpdate.setInt(3, pointsNeeded);
                int rowsUpdated = psUpdate.executeUpdate();
                
                if (rowsUpdated == 0) {
                    // Not enough points or user not found
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return false;
                }
            }
            
            // 2. Insert redemption record
            try (PreparedStatement psInsert = connection.prepareStatement(insertRedemptionSql)) {
                psInsert.setInt(1, userId);
                psInsert.setInt(2, promotionId);
                psInsert.executeUpdate();
            }
            
            // Commit transaction
            connection.commit();
            connection.setAutoCommit(true);
            return true;
            
        } catch (SQLException ex) {
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException rollbackEx) {
                Logger.getLogger(PromotionDAO.class.getName()).log(Level.SEVERE, null, rollbackEx);
            }
            Logger.getLogger(PromotionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public List<Redemption> getRedemptionsByUserId(int userId) {
        List<Redemption> list = new ArrayList<>();
        String sql = "SELECT r.*, p.name, p.requiredPoints, p.description " +
                     "FROM Redemptions r JOIN Promotions p ON r.promotionId = p.id " +
                     "WHERE r.userId = ? ORDER BY r.redeemedDate DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Redemption red = new Redemption(
                        rs.getInt("id"),
                        rs.getInt("userId"),
                        rs.getInt("promotionId"),
                        rs.getTimestamp("redeemedDate"),
                        rs.getString("status")
                );
                red.setPromotionName(rs.getString("name"));
                red.setRequiredPoints(rs.getInt("requiredPoints"));
                red.setPromotionDescription(rs.getString("description"));
                list.add(red);
            }
        } catch (SQLException ex) {
            Logger.getLogger(PromotionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean createPromotion(Promotion promo) {
        String sql = "INSERT INTO Promotions (name, description, requiredPoints, targetTier) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, promo.getName());
            st.setString(2, promo.getDescription());
            st.setInt(3, promo.getRequiredPoints());
            st.setString(4, promo.getTargetTier());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PromotionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean deletePromotion(int id) {
        String deleteRedemptions = "DELETE FROM Redemptions WHERE promotionId = ?";
        String deletePromo = "DELETE FROM Promotions WHERE id = ?";
        try {
            connection.setAutoCommit(false);
            try (PreparedStatement st1 = connection.prepareStatement(deleteRedemptions)) {
                st1.setInt(1, id);
                st1.executeUpdate();
            }
            try (PreparedStatement st2 = connection.prepareStatement(deletePromo)) {
                st2.setInt(1, id);
                int res = st2.executeUpdate();
                connection.commit();
                connection.setAutoCommit(true);
                return res > 0;
            }
        } catch (SQLException ex) {
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            Logger.getLogger(PromotionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updatePromotion(Promotion promo) {
        String sql = "UPDATE Promotions SET name = ?, description = ?, requiredPoints = ?, targetTier = ? WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, promo.getName());
            st.setString(2, promo.getDescription());
            st.setInt(3, promo.getRequiredPoints());
            st.setString(4, promo.getTargetTier());
            st.setInt(5, promo.getId());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PromotionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public Promotion getPromotionById(int id) {
        String sql = "SELECT * FROM Promotions WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Promotion(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getInt("requiredPoints"),
                        rs.getString("targetTier")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(PromotionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}
