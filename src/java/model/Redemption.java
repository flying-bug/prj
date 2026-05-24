package model;

import java.util.Date;

public class Redemption {
    private int id;
    private int userId;
    private int promotionId;
    private Date redeemedDate;
    private String status;
    
    // Joint fields for display
    private String promotionName;
    private int requiredPoints;
    private String promotionDescription;

    public Redemption() {
    }

    public Redemption(int id, int userId, int promotionId, Date redeemedDate, String status) {
        this.id = id;
        this.userId = userId;
        this.promotionId = promotionId;
        this.redeemedDate = redeemedDate;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getPromotionId() { return promotionId; }
    public void setPromotionId(int promotionId) { this.promotionId = promotionId; }

    public Date getRedeemedDate() { return redeemedDate; }
    public void setRedeemedDate(Date redeemedDate) { this.redeemedDate = redeemedDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPromotionName() { return promotionName; }
    public void setPromotionName(String promotionName) { this.promotionName = promotionName; }

    public int getRequiredPoints() { return requiredPoints; }
    public void setRequiredPoints(int requiredPoints) { this.requiredPoints = requiredPoints; }

    public String getPromotionDescription() { return promotionDescription; }
    public void setPromotionDescription(String promotionDescription) { this.promotionDescription = promotionDescription; }
}
