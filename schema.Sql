-- ============================================================
-- University / College Management System - PostgreSQL Schema
-- Based on provided ERD
-- ============================================================

-- Drop tables if they already exist (safe re-run, order matters due to FKs)
DROP TABLE IF EXISTS enrollment CASCADE;
DROP TABLE IF EXISTS course CASCADE;
DROP TABLE IF EXISTS instructor CASCADE;
DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS department CASCADE;

-- ============================================================
-- 1) DEPARTMENT
-- ============================================================
CREATE TABLE department (
    department_id   SERIAL PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    location        VARCHAR(50)
);

-- ============================================================
-- 2) STUDENT
-- ============================================================
CREATE TABLE student (
    student_id      SERIAL PRIMARY KEY,
    first_name      VARCHAR(30) NOT NULL,
    last_name       VARCHAR(30),
    birth_date      DATE,
    gender          CHAR(1),
    email           VARCHAR(100) UNIQUE,
    phone           VARCHAR(20),
    department_id   INTEGER,
    CONSTRAINT fk_student_department
        FOREIGN KEY (department_id)
        REFERENCES department (department_id)
        ON DELETE SET NULL
);

-- ============================================================
-- 3) INSTRUCTOR
-- ============================================================
CREATE TABLE instructor (
    instructor_id   SERIAL PRIMARY KEY,
    first_name      VARCHAR(30) NOT NULL,
    last_name       VARCHAR(30),
    email           VARCHAR(100) UNIQUE,
    department_id   INTEGER,
    CONSTRAINT fk_instructor_department
        FOREIGN KEY (department_id)
        REFERENCES department (department_id)
        ON DELETE SET NULL
);

-- ============================================================
-- 4) COURSE
-- ============================================================
CREATE TABLE course (
    course_id       SERIAL PRIMARY KEY,
    course_name     VARCHAR(100) NOT NULL,
    credit_hours    INTEGER,
    department_id   INTEGER,
    instructor_id   INTEGER,
    CONSTRAINT fk_course_department
        FOREIGN KEY (department_id)
        REFERENCES department (department_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_course_instructor
        FOREIGN KEY (instructor_id)
        REFERENCES instructor (instructor_id)
        ON DELETE SET NULL
);

-- ============================================================
-- 5) ENROLLMENT (junction table between STUDENT and COURSE)
-- ============================================================
CREATE TABLE enrollment (
    enrollment_id   SERIAL PRIMARY KEY,
    student_id      INTEGER NOT NULL,
    course_id       INTEGER NOT NULL,
    semester        VARCHAR(20),
    grade           NUMERIC(5,2),
    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES student (student_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES course (course_id)
        ON DELETE CASCADE,
    CONSTRAINT uq_enrollment UNIQUE (student_id, course_id, semester)
);

-- ============================================================
-- Helpful indexes on foreign keys (Postgres doesn't auto-index FKs)
-- ============================================================
CREATE INDEX idx_student_department   ON student (department_id);
CREATE INDEX idx_instructor_department ON instructor (department_id);
CREATE INDEX idx_course_department    ON course (department_id);
CREATE INDEX idx_course_instructor    ON course (instructor_id);
CREATE INDEX idx_enrollment_student   ON enrollment (student_id);
CREATE INDEX idx_enrollment_course    ON enrollment (course_id);

-- ============================================================
-- Sample data
-- ============================================================

-- Departments (must come first: student/instructor/course reference them)
INSERT INTO department (department_name, location) VALUES
('Computer Science', 'Building A'),   -- department_id = 1
('Mathematics', 'Building B'),        -- department_id = 2
('Physics', 'Building C');            -- department_id = 3

-- Instructors (reference department_id)
INSERT INTO instructor (first_name, last_name, email, department_id) VALUES
('Ahmed', 'Hassan', 'ahmed.hassan@uni.edu', 1),   -- instructor_id = 1
('Sara', 'Ali', 'sara.ali@uni.edu', 2),           -- instructor_id = 2
('Omar', 'Khaled', 'omar.khaled@uni.edu', 3);     -- instructor_id = 3

-- Courses (reference department_id and instructor_id)
INSERT INTO course (course_name, credit_hours, department_id, instructor_id) VALUES
('Database Systems', 3, 1, 1),   -- course_id = 1
('Calculus I', 4, 2, 2),         -- course_id = 2
('Physics I', 3, 3, 3);          -- course_id = 3

-- Students (17 total, reference department_id)
INSERT INTO student (first_name, last_name, birth_date, gender, email, phone, department_id) VALUES
('Mona', 'Youssef', '2002-05-14', 'F', 'mona.youssef@uni.edu', '01000000001', 1),    -- student_id = 1
('Karim', 'Adel', '2001-11-02', 'M', 'karim.adel@uni.edu', '01000000002', 2),        -- student_id = 2
('Ahmed', 'Fathy', '2002-01-15', 'M', 'ahmed.fathy@uni.edu', '01000000003', 1),      -- student_id = 3
('Nour', 'Mostafa', '2001-09-22', 'F', 'nour.mostafa@uni.edu', '01000000004', 1),    -- student_id = 4
('Youssef', 'Salah', '2002-03-10', 'M', 'youssef.salah@uni.edu', '01000000005', 1),  -- student_id = 5
('Hana', 'Tarek', '2003-07-05', 'F', 'hana.tarek@uni.edu', '01000000006', 2),        -- student_id = 6
('Mahmoud', 'Ezz', '2001-12-19', 'M', 'mahmoud.ezz@uni.edu', '01000000007', 2),      -- student_id = 7
('Salma', 'Reda', '2002-06-30', 'F', 'salma.reda@uni.edu', '01000000008', 2),        -- student_id = 8
('Amr', 'Nabil', '2002-02-14', 'M', 'amr.nabil@uni.edu', '01000000009', 3),          -- student_id = 9
('Laila', 'Hamdy', '2001-08-08', 'F', 'laila.hamdy@uni.edu', '01000000010', 3),      -- student_id = 10
('Sherif', 'Magdy', '2003-04-25', 'M', 'sherif.magdy@uni.edu', '01000000011', 3),    -- student_id = 11
('Dina', 'Wael', '2002-10-11', 'F', 'dina.wael@uni.edu', '01000000012', 1),          -- student_id = 12
('Khaled', 'Sami', '2001-05-27', 'M', 'khaled.sami@uni.edu', '01000000013', 1),      -- student_id = 13
('Rana', 'Adham', '2002-11-03', 'F', 'rana.adham@uni.edu', '01000000014', 2),        -- student_id = 14
('Tamer', 'Fouad', '2003-01-20', 'M', 'tamer.fouad@uni.edu', '01000000015', 3),      -- student_id = 15
('Yasmin', 'Gaber', '2002-09-09', 'F', 'yasmin.gaber@uni.edu', '01000000016', 1),    -- student_id = 16
('Hossam', 'Ramy', '2001-07-17', 'M', 'hossam.ramy@uni.edu', '01000000017', 2);      -- student_id = 17

-- Enrollments (reference student_id and course_id — now guaranteed to exist)
INSERT INTO enrollment (student_id, course_id, semester, grade) VALUES
(1, 1, 'Fall2025', 92.50),
(2, 2, 'Fall2025', 85.00),
(3, 1, 'Fall2025', 88.00),
(4, 1, 'Fall2025', 76.50),
(5, 1, 'Fall2025', 95.00),
(6, 2, 'Fall2025', 81.25),
(7, 2, 'Fall2025', 69.00),
(8, 2, 'Fall2025', 90.00),
(9, 3, 'Fall2025', 84.50),
(10, 3, 'Fall2025', 77.75),
(11, 3, 'Fall2025', 92.00),
(12, 1, 'Fall2025', 65.00),
(13, 1, 'Spring2026', 89.00),
(14, 2, 'Spring2026', 91.50),
(15, 3, 'Spring2026', 73.00),
(16, 1, 'Spring2026', 87.00),
(17, 2, 'Spring2026', 79.50);
