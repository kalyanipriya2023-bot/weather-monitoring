package java_oop.models;

import java.util.Date;

/**
 * Demonstrates Encapsulation:
 * - Private fields
 * - Accessors (Getters/Setters) with validation logic
 * - Constructor overloading
 */
public class User {
    private int id;
    private String name;
    private String email;
    private String passwordHash;
    private String profilePicturePath;
    private Date createdAt;

    // Default Constructor
    public User() {
        this.createdAt = new Date();
    }

    // Overloaded Constructor (for guest user)
    public User(String name) {
        this.name = name;
        this.email = "guest@local";
        this.passwordHash = "";
        this.createdAt = new Date();
    }

    // Fully Parameterized Constructor
    public User(int id, String name, String email, String passwordHash, String profilePicturePath, Date createdAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.passwordHash = passwordHash;
        this.profilePicturePath = profilePicturePath;
        this.createdAt = createdAt;
    }

    // Getters and Setters with Encapsulated Business Rules
    public int getId() {
        return id;
    }

    public void setId(int id) {
        if (id > 0) {
            this.id = id;
        }
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name != null && name.trim().length() >= 2) {
            this.name = name;
        }
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        if (email != null && email.contains("@")) {
            this.email = email;
        }
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getProfilePicturePath() {
        return profilePicturePath;
    }

    public void setProfilePicturePath(String profilePicturePath) {
        this.profilePicturePath = profilePicturePath;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "User{id=" + id + ", name='" + name + "', email='" + email + "'}";
    }
}
