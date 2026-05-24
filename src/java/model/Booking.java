package model;

import java.util.Date;

public class Booking {
    private int id;
    private int userId;
    private Date bookingDate;
    private String status;
    private User user; // Added for UI display

    public Booking() {
    }

    public Booking(int id, int userId, Date bookingDate, String status) {
        this.id = id;
        this.userId = userId;
        this.bookingDate = bookingDate;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}
