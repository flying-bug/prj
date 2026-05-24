package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Booking;
import util.DBContext;

public class BookingDAO extends DBContext {

    public boolean createBooking(Booking booking) {
        String sql = "INSERT INTO Bookings (userId, bookingDate, status) VALUES (?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, booking.getUserId());
            st.setTimestamp(2, new java.sql.Timestamp(booking.getBookingDate().getTime()));
            st.setString(3, booking.getStatus());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE userId = ? ORDER BY bookingDate DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Booking(
                        rs.getInt("id"),
                        rs.getInt("userId"),
                        rs.getTimestamp("bookingDate"),
                        rs.getString("status")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.* FROM Bookings b "
                   + "LEFT JOIN Users u ON b.userId = u.id "
                   + "ORDER BY "
                   + "  CASE WHEN b.status = 'PENDING' THEN 0 ELSE 1 END, "
                   + "  CASE u.tier "
                   + "    WHEN 'Platinum' THEN 1 "
                   + "    WHEN 'Gold' THEN 2 "
                   + "    WHEN 'Silver' THEN 3 "
                   + "    ELSE 4 "
                   + "  END, "
                   + "  b.bookingDate DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Booking(
                        rs.getInt("id"),
                        rs.getInt("userId"),
                        rs.getTimestamp("bookingDate"),
                        rs.getString("status")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE Bookings SET status = ? WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, bookingId);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean insertTransaction(int userId, int bookingId, double amount, int pointsEarned) {
        String sql = "INSERT INTO Transactions (userId, bookingId, amount, pointsEarned) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            if (bookingId <= 0) {
                st.setNull(2, java.sql.Types.INTEGER);
            } else {
                st.setInt(2, bookingId);
            }
            st.setDouble(3, amount);
            st.setInt(4, pointsEarned);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
