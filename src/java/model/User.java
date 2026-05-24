package model;

import java.util.Date;

public class User {
    private int id;
    private String username;
    private String password;
    private String role;
    private String fullName;
    private String phone;
    private String licensePlate;
    private int points;
    private String tier;
    private double totalSpent;
    private int washCount;
    private Date registerDate;

    public User() {
    }

    public User(int id, String username, String password, String role, String fullName, String phone, String licensePlate, int points, String tier, double totalSpent, int washCount, Date registerDate) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.fullName = fullName;
        this.phone = phone;
        this.licensePlate = licensePlate;
        this.points = points;
        this.tier = tier;
        this.totalSpent = totalSpent;
        this.washCount = washCount;
        this.registerDate = registerDate;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }

    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }

    public String getTier() { return tier; }
    public void setTier(String tier) { this.tier = tier; }

    public double getTotalSpent() { return totalSpent; }
    public void setTotalSpent(double totalSpent) { this.totalSpent = totalSpent; }

    public int getWashCount() { return washCount; }
    public void setWashCount(int washCount) { this.washCount = washCount; }

    public Date getRegisterDate() { return registerDate; }
    public void setRegisterDate(Date registerDate) { this.registerDate = registerDate; }
}
