package model;

public class Promotion {
    private int id;
    private String name;
    private String description;
    private int requiredPoints;
    private String targetTier;

    public Promotion() {
    }

    public Promotion(int id, String name, String description, int requiredPoints, String targetTier) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.requiredPoints = requiredPoints;
        this.targetTier = targetTier;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getRequiredPoints() { return requiredPoints; }
    public void setRequiredPoints(int requiredPoints) { this.requiredPoints = requiredPoints; }

    public String getTargetTier() { return targetTier; }
    public void setTargetTier(String targetTier) { this.targetTier = targetTier; }
}
