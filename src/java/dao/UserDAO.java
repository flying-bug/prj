package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import util.DBContext;

public class UserDAO extends DBContext {

    public User login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("fullName"),
                        rs.getString("phone"),
                        rs.getString("licensePlate"),
                        rs.getInt("points"),
                        rs.getString("tier"),
                        rs.getDouble("totalSpent"),
                        rs.getInt("washCount"),
                        rs.getDate("registerDate")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean register(User user) {
        String sql = "INSERT INTO Users (username, password, fullName, phone, licensePlate) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user.getUsername());
            st.setString(2, user.getPassword());
            st.setString(3, user.getFullName());
            st.setString(4, user.getPhone());
            st.setString(5, user.getLicensePlate());
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public int updateUserStats(int userId, double amountSpent) {
        String tierSql = "SELECT tier FROM Users WHERE id = ?";
        String currentTier = "Member";
        try {
            PreparedStatement tSt = connection.prepareStatement(tierSql);
            tSt.setInt(1, userId);
            ResultSet rs = tSt.executeQuery();
            if (rs.next()) {
                currentTier = rs.getString("tier");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        String sql = "UPDATE Users SET totalSpent = totalSpent + ?, washCount = washCount + 1, points = points + ? WHERE id = ?";
        try {
            int basePoints = (int) (amountSpent / 1000); // 1 point = 1000 VND
            double multiplier = 1.0;
            if (currentTier.equals("Silver")) multiplier = 1.1;
            else if (currentTier.equals("Gold")) multiplier = 1.2;
            else if (currentTier.equals("Platinum")) multiplier = 1.3;
            
            int pointsEarned = (int) (basePoints * multiplier);
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDouble(1, amountSpent);
            st.setInt(2, pointsEarned);
            st.setInt(3, userId);
            st.executeUpdate();
            
            // Check tier upgrades
            checkAndUpgradeTier(userId);
            
            return pointsEarned;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
    
    private void checkAndUpgradeTier(int userId) {
        String selectSql = "SELECT washCount, totalSpent, tier FROM Users WHERE id = ?";
        try {
            PreparedStatement selectSt = connection.prepareStatement(selectSql);
            selectSt.setInt(1, userId);
            ResultSet rs = selectSt.executeQuery();
            if (rs.next()) {
                int washCount = rs.getInt("washCount");
                double totalSpent = rs.getDouble("totalSpent");
                String currentTier = rs.getString("tier");
                
                String newTier = currentTier;
                if (washCount >= 30 || totalSpent >= 15000000) {
                    newTier = "Platinum";
                } else if (washCount >= 15 || totalSpent >= 6000000) {
                    newTier = "Gold";
                } else if (washCount >= 5 || totalSpent >= 2000000) {
                    newTier = "Silver";
                }
                
                if (!newTier.equals(currentTier)) {
                    String updateSql = "UPDATE Users SET tier = ? WHERE id = ?";
                    PreparedStatement updateSt = connection.prepareStatement(updateSql);
                    updateSt.setString(1, newTier);
                    updateSt.setInt(2, userId);
                    updateSt.executeUpdate();
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("fullName"),
                        rs.getString("phone"),
                        rs.getString("licensePlate"),
                        rs.getInt("points"),
                        rs.getString("tier"),
                        rs.getDouble("totalSpent"),
                        rs.getInt("washCount"),
                        rs.getDate("registerDate")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public double getTotalRevenue() {
        String sql = "SELECT SUM(amount) FROM Transactions";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0.0;
    }

    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) FROM Users WHERE role = 'CUSTOMER'";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int getCustomerCountByTier(String tier) {
        String sql = "SELECT COUNT(*) FROM Users WHERE role = 'CUSTOMER' AND tier = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, tier);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public User getUserByLicensePlate(String licensePlate) {
        String sql = "SELECT * FROM Users WHERE licensePlate = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, licensePlate);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("role"),
                            rs.getString("fullName"),
                            rs.getString("phone"),
                            rs.getString("licensePlate"),
                            rs.getInt("points"),
                            rs.getString("tier"),
                            rs.getDouble("totalSpent"),
                            rs.getInt("washCount"),
                            rs.getDate("registerDate")
                    );
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}
