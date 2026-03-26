-- Research Paper Submission & Review System Database Schema

-- Create Database
CREATE DATABASE IF NOT EXISTS rps_db;
USE rps_db;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('author', 'reviewer', 'editor') NOT NULL,
    affiliation VARCHAR(255),
    expertise VARCHAR(255), -- for reviewers
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Papers Table
CREATE TABLE IF NOT EXISTS papers (
    paper_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    abstract TEXT NOT NULL,
    keywords VARCHAR(255),
    category ENUM('Research Article', 'Review Article', 'Short Communication') DEFAULT 'Research Article',
    file_path VARCHAR(255) NOT NULL,
    status ENUM(
        'Submitted', 
        'Under Review', 
        'Review Completed', 
        'Decision Pending', 
        'Accepted', 
        'Rejected',
        'Minor Revisions',
        'Major Revisions'
    ) DEFAULT 'Submitted',
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    author_id INT,
    assigned_editor_id INT,
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_editor_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Assignments Table (Reviewer Assignments)
CREATE TABLE IF NOT EXISTS assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    paper_id INT,
    reviewer_id INT,
    due_date DATE,
    assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'In Progress', 'Completed', 'Overdue') DEFAULT 'Pending',
    FOREIGN KEY (paper_id) REFERENCES papers(paper_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Reviews Table
CREATE TABLE IF NOT EXISTS reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT,
    score INT CHECK (score >= 1 AND score <= 5),
    recommendation ENUM('Accept', 'Minor Revisions', 'Major Revisions', 'Reject') NOT NULL,
    comments_to_author TEXT NOT NULL,
    comments_to_editor TEXT,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id) ON DELETE CASCADE
);

-- Editorial Decisions Table
CREATE TABLE IF NOT EXISTS editorial_decisions (
    decision_id INT AUTO_INCREMENT PRIMARY KEY,
    paper_id INT,
    editor_id INT,
    decision ENUM('Accept', 'Minor Revisions', 'Major Revisions', 'Reject') NOT NULL,
    decision_comments TEXT,
    decision_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paper_id) REFERENCES papers(paper_id) ON DELETE CASCADE,
    FOREIGN KEY (editor_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    message TEXT NOT NULL,
    type ENUM('submission', 'assignment', 'review', 'decision') NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Sample Data
INSERT INTO users (name, email, password, role, affiliation, expertise) VALUES
('Chief Editor', 'editor@example.com', '$2a$10$bNWfb8lHfA17oG92G3JKju66SRynxaN0COuEBkwXDP2BKjfKKYYFgW', 'editor', 'Ramco Institute of Technology', 'All Areas'),
('Dr. Sarah Lee', 'sarah@example.com', '$2a$10$bNWfb8lHfA17oG92G3JKju66SRynxaN0COuEBkwXDP2BKjfKKYYFgW', 'reviewer', 'Tech University', 'AI, Machine Learning'),
('Dr. John Smith', 'john@example.com', '$2a$10$bNWfb8lHfA17oG92G3JKju66SRynxaN0COuEBkwXDP2BKjfKKYYFgW', 'author', 'Research Lab', NULL);

INSERT INTO papers (title, abstract, keywords, category, file_path, author_id, assigned_editor_id) VALUES
('AI in Healthcare: A Comprehensive Review', 'This paper presents a comprehensive review of AI applications in healthcare...', 'AI, Healthcare, Machine Learning', 'Research Article', '/uploads/paper_1001.pdf', 3, 1);

INSERT INTO assignments (paper_id, reviewer_id, due_date) VALUES
(1, 2, DATE_ADD(CURDATE(), INTERVAL 14 DAY));
