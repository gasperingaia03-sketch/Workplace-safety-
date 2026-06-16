CREATE DATABASE WORKPLACE_SAFETY;

-- 1. Departments Table
CREATE TABLE DEPARTMENTS (
    DepID VARCHAR(6) PRIMARY KEY,
    RiskLevel VARCHAR(20) NOT NULL CHECK (RiskLevel IN ('Low', 'Medium', 'High'))
);

-- 2. Workers Table
CREATE TABLE WORKERS (
    IDCode VARCHAR(50) PRIMARY KEY, -- Using VARCHAR in case the ID code contains letters (e.g., W001)
    Name VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL,
    HiringDate DATE NOT NULL,
    EmploymentStatus VARCHAR(50) NOT NULL DEFAULT 'Active', -- 'Active' = active, 'Inactive' = not active
    DepID VARCHAR(6) NOT NULL,
    -- Referential integrity constraint (Foreign Key)
    CONSTRAINT fk_department FOREIGN KEY (DepID) 
        REFERENCES DEPARTMENTS (DepID) 
        ON DELETE RESTRICT -- Prevents deleting a department if workers are assigned to it
);

-- 3. Security Courses Table
CREATE TABLE SECURITY_COURSES (
    CourseID VARCHAR(50) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ValidityMonths INTEGER NOT NULL,
    -- Constraint: The course must have a validity greater than zero months
    CONSTRAINT chk_validity CHECK (ValidityMonths > 0)
);

-- 4. Certificates Training Table (Bridge Table)
CREATE TABLE CERTIFICATES_TRAINING (
    WorkerID VARCHAR(50) NOT NULL,
    CourseID VARCHAR(50) NOT NULL,
    AchievementDate DATE NOT NULL,
    PRIMARY KEY (WorkerID, CourseID, AchievementDate),
    -- Foreign keys linking the worker and the course
    CONSTRAINT fk_worker FOREIGN KEY (WorkerID) REFERENCES WORKERS (IDCode) ON DELETE CASCADE,
    CONSTRAINT fk_course FOREIGN KEY (CourseID) REFERENCES SECURITY_COURSES (CourseID) ON DELETE CASCADE,
    -- Constraint: Prevents inserting the same course for the same worker on the exact same day
    CONSTRAINT unique_certificate UNIQUE (WorkerID, CourseID, AchievementDate)
);

-- 5. Medical Visits Table
CREATE TABLE MEDICAL_VISITS (
    VisitID SERIAL PRIMARY KEY,
    WorkerID VARCHAR(50) NOT NULL,
    VisitDate DATE NOT NULL, 
    Outcome VARCHAR(50) NOT NULL,
    Cadency VARCHAR(20) NOT NULL CHECK (Cadency IN ('Semestral','Annual')),
    -- Foreign key linking the visit to the worker
    CONSTRAINT fk_visit_worker FOREIGN KEY (WorkerID) REFERENCES WORKERS (IDCode) ON DELETE CASCADE,
    -- Constraint on possible outcomes (Standard occupational health terms)
    CONSTRAINT chk_outcome CHECK (Outcome IN ('Fit', 'Unfit', 'Fit with restrictions'))
);

-- 1. Populate Departments (DEPARTMENTS)
INSERT INTO DEPARTMENTS (DepID, RiskLevel) VALUES
('AMM001', 'Low'), ('LOG002', 'Medium'), ('PRO003', 'High'), ('WEL004', 'High'), ('HR0005', 'Low'),
('MAN006', 'Medium'), ('AMM007', 'High'), ('LOG008', 'Low'), ('PRO009', 'Medium'), ('WEL010', 'High'),
('HR0011', 'Low'), ('MAN012', 'Medium'), ('AMM013', 'High'), ('LOG014', 'Medium'), ('PRO015', 'Low'),
('WEL016', 'Medium'), ('HR0017', 'High'), ('MAN018', 'Low'), ('AMM019', 'Medium'), ('LOG020', 'High'),
('PRO021', 'Low'), ('WEL022', 'Medium'), ('HR0023', 'High'), ('MAN024', 'Medium'), ('AMM025', 'Low'),
('LOG026', 'Medium'), ('PRO027', 'High'), ('WEL028', 'Low'), ('HR0029', 'Medium'), ('MAN030', 'High'),
('AMM031', 'Low'), ('LOG032', 'Medium'), ('PRO033', 'High'), ('WEL034', 'Medium'), ('HR0035', 'Low'),
('MAN036', 'Medium'), ('AMM037', 'High'), ('LOG038', 'Low'), ('PRO039', 'Medium'), ('WEL040', 'High'),
('HR0041', 'Low'), ('MAN042', 'Medium'), ('AMM043', 'High'), ('LOG044', 'Medium'), ('PRO045', 'Low'),
('WEL046', 'Medium'), ('HR0047', 'High'), ('MAN048', 'Low'), ('AMM049', 'Medium'), ('LOG050', 'High');

-- 2. Populate Security Courses (SECURITY_COURSES)
INSERT INTO SECURITY_COURSES (CourseID, Name, ValidityMonths) VALUES
('C014', 'Pallet Jack Operation', 60),
('C028', 'Harassment and Bullying Prevention', 36),
('C007', 'Fire Emergency - High Risk', 36),
('C042', 'Lone Worker Safety', 36),
('C019', 'Working at Heights', 36),
('C033', 'Slip, Trip, and Fall Prevention', 60),
('C003', 'Specific Safety Training - Medium Risk', 60),
('C022', 'Welding Safety Basic', 36),
('C048', 'Bloodborne Pathogens', 12),
('C011', 'Warehouse Traffic Management', 36),
('C037', 'Scaffolding Safety', 36),
('C008', 'First Aid', 36),
('C025', 'Office Ergonomics', 60),
('C045', 'Battery Charging Station Safety', 36),
('C016', 'Electrical Safety Advanced', 12),
('C001', 'General Safety Training', 60),
('C030', 'Diversity and Inclusion in Workplace Safety', 36),
('C023', 'Welding Fume Extraction', 36),
('C039', 'Respiratory Protection', 12),
('C013', 'Loading Dock Safety', 36),
('C049', 'Contractor Safety Management', 36),
('C005', 'Fire Emergency - Low Risk', 36),
('C027', 'Work-Related Stress Management', 36),
('C035', 'Spill Response Training', 12),
('C018', 'Confined Spaces Entry', 12),
('C043', 'First Aid', 36),
('C009', 'First Aid', 36),
('C032', 'Safe Use of Power Tools', 60),
('C046', 'Conveyor Belt Safety', 36),
('C021', 'Hot Work Permit', 12),
('C010', 'Forklift Operation', 60),
('C038', 'Noise Exposure and Hearing Conservation', 36),
('C004', 'Specific Safety Training - High Risk', 60),
('C026', 'VDT (Video Display Terminal) Safety', 60),
('C015', 'Electrical Safety Basic', 36),
('C050', 'Incident Investigation and Reporting', 36),
('C006', 'Fire Emergency - Medium Risk', 36),
('C034', 'Hazardous Chemical Handling', 12),
('C029', 'Emergency Evacuation Coordinator', 36),
('C012', 'Manual Handling of Loads', 36),
('C040', 'PPE Selection and Use', 36),
('C020', 'Machine Guarding', 36),
('C047', 'Compressed Gas Cylinder Safety', 36),
('C002', 'Specific Safety Training - Low Risk', 60),
('C031', 'Safe Use of Hand Tools', 60),
('C044', 'Fire Extinguisher Practical Training', 36),
('C024', 'Radiation Safety in Welding', 36),
('C036', 'Crane and Hoist Operation', 60),
('C041', 'Defensive Driving for Corporate Vehicles', 36),
('C017', 'Lockout/Tagout (LOTO)', 36);

-- 3. Populate Workers (WORKERS)
INSERT INTO WORKERS (IDCode, Name, Surname, BirthDate, HiringDate, EmploymentStatus, DepID) VALUES
('W001', 'Marco', 'Rossi', '1990-11-22', '2018-04-01', 'Active', 'PRO003'),
('W002', 'Giulia', 'Bianchi', '1985-08-30', '2020-09-15', 'Active', 'AMM001'),
('W003', 'Luca', 'Verdi', '1998-02-10', '2023-11-01', 'Inactive', 'PRO003'),
('W004', 'Andrea', 'Conti', '1982-05-14', '2015-02-10', 'Active', 'WEL004'),
('W005', 'Elena', 'Ricci', '1995-12-05', '2021-06-01', 'Active', 'LOG002'),
('W006', 'Roberto', 'Gallo', '1979-03-21', '2010-10-15', 'Active', 'MAN006'),
('W007', 'Francesca', 'Marino', '1992-07-18', '2019-03-01', 'Inactive', 'AMM001'),
('W008', 'Paolo', 'Bruno', '1988-09-09', '2016-11-20', 'Active', 'PRO003'),
('W009', 'Laura', 'Esposito', '2000-01-25', '2024-01-15', 'Active', 'HR0005'),
('W010', 'Matteo', 'Rizzo', '1993-04-11', '2017-08-10', 'Active', 'AMM007'),
('W011', 'Chiara', 'Lombardi', '1987-11-30', '2014-05-20', 'Active', 'LOG008'),
('W012', 'Alessandro', 'Moretti', '1991-06-15', '2022-03-12', 'Active', 'PRO009'),
('W013', 'Silvia', 'Barbieri', '1980-02-28', '2005-09-01', 'Active', 'WEL010'),
('W014', 'Davide', 'Fontana', '1996-08-19', '2023-01-15', 'Active', 'HR0011'),
('W015', 'Sara', 'Russo', '1999-12-12', '2024-02-28', 'Active', 'MAN012'),
('W016', 'Stefano', 'Ferraro', '1984-07-07', '2011-11-11', 'Active', 'AMM013'),
('W017', 'Valentina', 'Farina', '1994-03-22', '2020-07-01', 'Inactive', 'LOG014'),
('W018', 'Lorenzo', 'Gatti', '1989-10-05', '2018-12-15', 'Active', 'PRO015'),
('W019', 'Martina', 'Greco', '1997-05-18', '2021-04-10', 'Active', 'WEL016'),
('W020', 'Giacomo', 'Caruso', '1981-01-30', '2008-06-25', 'Active', 'HR0017'),
('W021', 'Elisa', 'Monti', '1992-09-14', '2019-10-05', 'Active', 'MAN018'),
('W022', 'Nicola', 'Martini', '1986-12-08', '2015-08-20', 'Active', 'AMM019'),
('W023', 'Federica', 'Leone', '1990-04-26', '2017-02-14', 'Active', 'LOG020'),
('W024', 'Daniele', 'Longo', '1983-08-03', '2012-05-30', 'Active', 'PRO021'),
('W025', 'Alessia', 'Gentile', '1995-11-17', '2022-09-15', 'Inactive', 'WEL022'),
('W026', 'Filippo', 'Coppola', '1988-02-09', '2016-01-20', 'Active', 'HR0023'),
('W027', 'Ilaria', 'De Angelis', '1991-07-25', '2020-11-10', 'Active', 'MAN024'),
('W028', 'Edoardo', 'Lombardo', '1985-05-05', '2013-03-12', 'Active', 'AMM025'),
('W029', 'Roberta', 'Bianco', '1998-10-21', '2023-08-01', 'Active', 'LOG026'),
('W030', 'Michele', 'Zanetti', '1978-12-15', '2004-02-05', 'Active', 'PRO027'),
('W031', 'Alice', 'Fiore', '1996-01-10', '2021-12-01', 'Active', 'WEL028'),
('W032', 'Pietro', 'Riva', '1993-06-08', '2019-05-18', 'Inactive', 'HR0029'),
('W033', 'Eleonora', 'Marchetti', '1987-03-29', '2014-10-22', 'Active', 'MAN030'),
('W034', 'Tommaso', 'Villa', '1999-04-14', '2024-03-10', 'Active', 'AMM031'),
('W035', 'Caterina', 'Serra', '1982-09-02', '2010-01-15', 'Active', 'LOG032'),
('W036', 'Federico', 'Conte', '1994-11-11', '2022-07-05', 'Active', 'PRO033'),
('W037', 'Giorgia', 'Palumbo', '1990-08-27', '2018-09-30', 'Active', 'WEL034'),
('W038', 'Gabriele', 'Ferri', '1984-12-19', '2011-04-25', 'Active', 'HR0035'),
('W039', 'Cristina', 'Pellegrini', '1997-02-04', '2023-05-20', 'Active', 'MAN036'),
('W040', 'Vincenzo', 'Sanna', '1989-05-31', '2016-08-10', 'Active', 'AMM037'),
('W041', 'Michela', 'Mazza', '1995-07-16', '2021-10-15', 'Active', 'LOG038'),
('W042', 'Emanuele', 'Giordano', '1981-10-09', '2009-11-02', 'Inactive', 'PRO039'),
('W043', 'Anna', 'Vitale', '1992-01-22', '2019-02-18', 'Active', 'WEL040'),
('W044', 'Simone', 'Bassi', '1986-06-14', '2015-12-05', 'Active', 'HR0041'),
('W045', 'Beatrice', 'Sartori', '1998-09-08', '2023-10-25', 'Active', 'MAN042'),
('W046', 'Riccardo', 'Neri', '1991-12-25', '2020-04-12', 'Active', 'AMM043'),
('W047', 'Marta', 'Costantini', '1985-04-18', '2013-07-20', 'Active', 'LOG044'),
('W048', 'Enrico', 'D Amico', '1994-08-05', '2022-01-30', 'Active', 'PRO045'),
('W049', 'Lucia', 'Parisi', '1980-11-12', '2006-03-08', 'Active', 'WEL046'),
('W050', 'Christian', 'Galli', '1999-03-17', '2024-05-01', 'Active', 'HR0047');

-- 4. Populate Certificates (CERTIFICATES_TRAINING)
INSERT INTO CERTIFICATES_TRAINING (WorkerID, CourseID, AchievementDate) VALUES
('W027', 'C034', '2020-10-20'),
('W004', 'C005', '2023-01-12'),
('W014', 'C038', '2022-09-12'),
('W041', 'C004', '2022-08-22'),
('W001', 'C003', '2022-01-15'),
('W019', 'C006', '2023-10-10'),
('W033', 'C028', '2024-01-05'),
('W006', 'C003', '2019-03-20'),
('W011', 'C003', '2021-04-05'),
('W020', 'C029', '2021-12-01'),
('W045', 'C006', '2024-02-05'),
('W004', 'C031', '2022-11-22'),
('W016', 'C026', '2022-05-15'),
('W005', 'C004', '2021-05-20'),
('W038', 'C026', '2023-09-05'),
('W001', 'C031', '2021-06-18'),
('W048', 'C034', '2022-10-08'),
('W010', 'C016', '2023-09-30'),
('W007', 'C001', '2020-07-14'),
('W030', 'C016', '2022-02-11'),
('W025', 'C026', '2023-08-05'),
('W012', 'C035', '2021-03-10'),
('W036', 'C002', '2021-10-18'),
('W009', 'C007', '2024-02-10'),
('W022', 'C026', '2021-02-28'),
('W003', 'C002', '2023-05-10'),
('W046', 'C001', '2023-05-20'),
('W001', 'C001', '2023-05-15'),
('W026', 'C037', '2023-04-22'),
('W014', 'C003', '2024-01-10'),
('W040', 'C001', '2020-12-01'),
('W006', 'C003', '2022-03-25'),
('W021', 'C028', '2023-01-14'),
('W042', 'C034', '2021-01-30'),
('W013', 'C031', '2023-04-18'),
('W005', 'C003', '2023-02-28'),
('W050', 'C026', '2023-12-12'),
('W008', 'C034', '2020-05-15'),
('W037', 'C031', '2022-04-12'),
('W015', 'C001', '2024-03-02'),
('W002', 'C004', '2021-11-20'),
('W023', 'C004', '2022-06-18'),
('W047', 'C004', '2021-07-14'),
('W010', 'C001', '2019-10-12'),
('W035', 'C001', '2023-07-07'),
('W011', 'C028', '2020-03-15'),
('W044', 'C026', '2022-06-10'),
('W004', 'C005', '2024-01-15'),
('W024', 'C036', '2021-08-08'),
('W032', 'C026', '2020-11-12'),
('W001', 'C001', '2018-05-10'),
('W018', 'C028', '2022-07-25'),
('W008', 'C001', '2022-09-01'),
('W043', 'C031', '2023-11-15'),
('W012', 'C002', '2022-12-01'),
('W049', 'C031', '2024-01-25'),
('W009', 'C026', '2024-01-20'),
('W013', 'C001', '2023-08-20'),
('W006', 'C006', '2021-09-10'),
('W039', 'C006', '2024-03-18'),
('W004', 'C005', '2022-01-10'),
('W029', 'C004', '2024-02-28'),
('W017', 'C004', '2023-11-05');    

-- 5. Populate Medical Visits (MEDICAL_VISITS)
INSERT INTO MEDICAL_VISITS (WorkerID, VisitDate, Outcome, Cadency) VALUES
('W031', '2024-05-10', 'Fit', 'Semestral'),
('W008', '2024-11-10', 'Fit', 'Annual'),
('W020', '2023-01-15', 'Fit with restrictions', 'Annual'),
('W011', '2024-03-05', 'Fit', 'Annual'),
('W037', '2024-02-25', 'Fit', 'Semestral'),
('W042', '2021-06-25', 'Unfit', 'Annual'),
('W012', '2023-07-20', 'Fit', 'Annual'),
('W021', '2024-11-30', 'Fit with restrictions', 'Semestral'),
('W001', '2022-05-20', 'Fit', 'Annual'),
('W028', '2024-03-12', 'Fit', 'Annual'),
('W006', '2024-03-14', 'Fit with restrictions', 'Annual'),
('W034', '2024-02-28', 'Fit', 'Annual'),
('W016', '2024-08-14', 'Fit', 'Annual'),
('W023', '2024-07-18', 'Fit', 'Semestral'),
('W048', '2024-01-18', 'Fit', 'Annual'),
('W004', '2022-02-22', 'Fit', 'Annual'),
('W017', '2023-01-12', 'Unfit', 'Semestral'),
('W049', '2024-12-10', 'Fit with restrictions', 'Semestral'),
('W010', '2024-02-10', 'Fit', 'Semestral'),
('W035', '2024-04-12', 'Fit with restrictions', 'Annual'),
('W026', '2024-01-30', 'Fit', 'Annual'),
('W013', '2024-10-08', 'Fit', 'Semestral'),
('W007', '2022-05-20', 'Unfit', 'Annual'),
('W034', '2023-03-02', 'Fit', 'Annual'),
('W009', '2024-01-22', 'Fit', 'Annual'),
('W039', '2024-10-20', 'Fit with restrictions', 'Annual'),
('W019', '2024-03-20', 'Fit', 'Semestral'),
('W045', '2024-02-08', 'Fit with restrictions', 'Annual'),
('W012', '2024-07-18', 'Fit', 'Annual'),
('W003', '2023-10-15', 'Unfit', 'Annual'),
('W044', '2024-11-05', 'Fit', 'Annual'),
('W025', '2023-08-30', 'Unfit', 'Annual'),
('W036', '2024-06-05', 'Fit', 'Annual'),
('W019', '2024-09-22', 'Fit', 'Semestral'),
('W027', '2024-05-18', 'Fit with restrictions', 'Annual'),
('W004', '2023-02-18', 'Fit', 'Annual'),
('W013', '2024-04-05', 'Fit', 'Semestral'),
('W029', '2024-09-15', 'Fit', 'Annual'),
('W050', '2024-05-02', 'Fit', 'Annual'),
('W002', '2024-09-01', 'Fit', 'Annual'),
('W030', '2024-09-05', 'Fit with restrictions', 'Semestral'),
('W041', '2024-10-15', 'Fit', 'Annual'),
('W006', '2023-03-10', 'Fit with restrictions', 'Annual'),
('W024', '2024-05-25', 'Fit', 'Annual'),
('W001', '2023-05-15', 'Fit', 'Annual'),
('W022', '2024-04-10', 'Fit', 'Annual'),
('W015', '2024-07-22', 'Fit with restrictions', 'Annual'),
('W018', '2024-12-05', 'Fit', 'Annual'),
('W031', '2024-11-12', 'Fit', 'Semestral'),
('W004', '2024-02-15', 'Fit', 'Annual'),
('W001', '2024-05-12', 'Fit', 'Annual'),
('W023', '2024-01-15', 'Fit', 'Semestral'),
('W008', '2023-11-12', 'Fit', 'Annual'),
('W010', '2024-08-12', 'Fit', 'Semestral'),
('W032', '2022-11-14', 'Unfit', 'Annual'),
('W020', '2024-01-10', 'Fit with restrictions', 'Annual'),
('W037', '2024-08-28', 'Fit', 'Semestral'),
('W005', '2024-06-20', 'Fit', 'Annual'),
('W002', '2023-09-05', 'Fit', 'Annual'),
('W040', '2024-08-20', 'Fit', 'Annual'),
('W014', '2024-10-30', 'Fit', 'Annual'),
('W012', '2022-07-25', 'Fit', 'Annual'),
('W006', '2022-03-15', 'Fit', 'Annual');

INSERT INTO MEDICAL_VISITS (WorkerID, VisitDate, Outcome, Cadency) VALUES
('W005', '2023-06-20', 'Fit with restrictions', 'Annual'),
('W001', '2021-05-15', 'Unfit', 'Annual'),
('W010', '2023-08-12', 'Unfit', 'Semestral'),
('W022', '2022-04-10', 'Fit with restrictions', 'Annual'),
('W039', '2025-10-20', 'Fit', 'Annual'),
('W044', '2023-11-05', 'Unfit', 'Annual'),
('W014', '2025-10-30', 'Unfit', 'Annual'),
('W046', '2025-04-12', 'Unfit', 'Annual'),
('W002', '2025-11-01', 'Unfit', 'Annual'),
('W018', '2026-02-15', 'Unfit', 'Annual'),
('W028', '2025-05-12', 'Unfit', 'Annual'),
('W041', '2026-03-10', 'Unfit', 'Annual');

-- 1. View all departments
SELECT *
FROM DEPARTMENTS;

-- 2. View all workers
SELECT *
FROM WORKERS;

-- 3. View all security courses
SELECT *
FROM SECURITY_COURSES;

-- 4. View all training certificates
SELECT * 
FROM CERTIFICATES_TRAINING;

-- 5. View all medical visits
SELECT *
FROM MEDICAL_VISITS;

-- 6. Find all currently active workers in the company
SELECT IDCode, Name, Surname, HiringDate 
FROM WORKERS 
WHERE EmploymentStatus = 'Active'
ORDER BY Surname ASC;

-- 7. Find high-risk departments
SELECT DepID, RiskLevel 
FROM DEPARTMENTS 
WHERE RiskLevel = 'High';

-- 8. Find security courses that last exactly 5 years (60 months)
SELECT CourseID, Name 
FROM SECURITY_COURSES 
WHERE ValidityMonths = 60;

-- 9. Find all workers who have taken the "General Safety Training" course
SELECT W.IDCode, W.Name, W.Surname
FROM WORKERS W JOIN CERTIFICATES_TRAINING CT ON W.IDCode = CT.WorkerID JOIN SECURITY_COURSES SC ON CT.CourseID = SC.CourseID
WHERE SC.Name = 'General Safety Training';

-- 10. Find medical visits that resulted in an "Unfit" outcome 
SELECT VisitDate, WorkerID, Outcome 
FROM MEDICAL_VISITS 
WHERE Outcome = 'Unfit'
ORDER BY VisitDate DESC;

-- 11. Find employees hired from the year 2022 onwards
SELECT Name, Surname, HiringDate 
FROM WORKERS 
WHERE HiringDate >= '2022-01-01'
ORDER BY HiringDate ASC;

-- 12. Find currently active workers who are "Fit with restrictions"
SELECT DISTINCT w.IDCode, w.Name, w.Surname, mv.VisitDate
FROM WORKERS w
JOIN MEDICAL_VISITS mv ON w.IDCode = mv.WorkerID
WHERE mv.Outcome = 'Fit with restrictions' 
  AND w.EmploymentStatus = 'Active';

-- 13. Find active workers with courses expiring in the next 60 days or already expired
SELECT W.IDCode, W.Name, W.Surname, SC.Name AS CourseName, CT.AchievementDate,
    (CT.AchievementDate + (SC.ValidityMonths * INTERVAL '1 month')) AS ExpirationDate
FROM WORKERS W
JOIN CERTIFICATES_TRAINING CT ON W.IDCode = CT.WorkerID
JOIN SECURITY_COURSES SC ON CT.CourseID = SC.CourseID
WHERE W.EmploymentStatus = 'Active'
  AND (CT.AchievementDate + (SC.ValidityMonths * INTERVAL '1 month')) <= CURRENT_DATE + INTERVAL '60 days'
ORDER BY ExpirationDate ASC;

-- 14. Find active workers in 'High' risk departments missing the mandatory "Fire Emergency - High Risk" course
SELECT W.IDCode, W.Name, W.Surname, D.DepID
FROM WORKERS W
JOIN DEPARTMENTS D ON W.DepID = D.DepID
WHERE W.EmploymentStatus = 'Active'
  AND D.RiskLevel = 'High'
  AND W.IDCode NOT IN (
      SELECT CT.WorkerID
      FROM CERTIFICATES_TRAINING CT
      JOIN SECURITY_COURSES SC ON CT.CourseID = SC.CourseID
      WHERE SC.Name = 'Fire Emergency - High Risk'
  );

-- 15. Count of active workers not fully fit per department (showing only departments with >= 2 cases)
SELECT D.DepID, D.RiskLevel, COUNT(MV.VisitID) AS NotFullyFitCount
FROM DEPARTMENTS D
JOIN WORKERS W ON D.DepID = W.DepID
JOIN MEDICAL_VISITS MV ON W.IDCode = MV.WorkerID
WHERE W.EmploymentStatus = 'Active'
  AND MV.Outcome IN ('Unfit', 'Fit with restrictions')
GROUP BY D.DepID, D.RiskLevel
HAVING COUNT(MV.VisitID) >= 2
ORDER BY NotFullyFitCount DESC;

-- 16. Find active workers whose medical visit is overdue
SELECT W.IDCode, W.Name, W.Surname, MV.VisitDate AS LastVisitDate,MV.Cadency
FROM WORKERS W
JOIN MEDICAL_VISITS MV ON W.IDCode = MV.WorkerID
WHERE W.EmploymentStatus = 'Active'
  -- Select the date that is greater than or equal to all dates recorded for that worker
  AND MV.VisitDate >= ALL (
      SELECT MV2.VisitDate
      FROM MEDICAL_VISITS MV2
      WHERE MV2.WorkerID = W.IDCode
  )
  -- Check for the deadlines
  AND (
      (MV.Cadency = 'Annual' AND MV.VisitDate + INTERVAL '1 year' < CURRENT_DATE)
      OR 
      (MV.Cadency = 'Semestral' AND MV.VisitDate + INTERVAL '6 months' < CURRENT_DATE)
  )
ORDER BY LastVisitDate ASC;

-- 17. Find active workers who have NEVER taken any security course (using NOT IN)
SELECT IDCode, Name, Surname, DepID
FROM WORKERS 
WHERE EmploymentStatus = 'Active'
  AND IDCode NOT IN (
      SELECT WorkerID
      FROM CERTIFICATES_TRAINING
  );

-- 18. Find active workers whose health status improved from Unfit/Restricted to Fit over time
SELECT DISTINCT W.IDCode, W.Name, W.Surname
FROM WORKERS W
JOIN MEDICAL_VISITS MV1 ON W.IDCode = MV1.WorkerID
JOIN MEDICAL_VISITS MV2 ON W.IDCode = MV2.WorkerID
WHERE W.EmploymentStatus = 'Active'
  AND MV1.VisitDate < MV2.VisitDate
  AND MV1.Outcome IN ('Unfit', 'Fit with restrictions')
  AND MV2.Outcome = 'Fit'
ORDER BY W.Surname ASC;

-- 19. Find active workers in High-risk departments who have General training but lack Specific High-Risk training
SELECT DISTINCT W.IDCode, W.Name, W.Surname, D.DepID
FROM WORKERS W
JOIN DEPARTMENTS D ON W.DepID = D.DepID
JOIN CERTIFICATES_TRAINING CT ON W.IDCode = CT.WorkerID
JOIN SECURITY_COURSES SC ON CT.CourseID = SC.CourseID
WHERE W.EmploymentStatus = 'Active'
  AND D.RiskLevel = 'High'
  AND SC.Name = 'General Safety Training'
  AND W.IDCode NOT IN (
      SELECT CT2.WorkerID
      FROM CERTIFICATES_TRAINING CT2
      JOIN SECURITY_COURSES SC2 ON CT2.CourseID = SC2.CourseID
      WHERE SC2.Name = 'Specific Safety Training - High Risk'
  );

-- 20. Critical Audit: Find workers currently 'Active' whose latest medical visit outcome is 'Unfit'
EXPLAIN ANALYZE
SELECT W.IDCode, W.Name, W.Surname, MV.VisitDate, MV.Outcome
FROM WORKERS W
JOIN MEDICAL_VISITS MV ON W.IDCode = MV.WorkerID
WHERE W.EmploymentStatus = 'Active'
  AND MV.Outcome = 'Unfit'
  AND MV.VisitDate >= ALL (
      SELECT MV2.VisitDate
      FROM MEDICAL_VISITS MV2
      WHERE MV2.WorkerID = W.IDCode
  );

-- Re-write query 17 for the performance analysis:
EXPLAIN ANALYZE
SELECT W.IDCode, W.Name, W.Surname, W.DepID
FROM WORKERS W
WHERE W.EmploymentStatus = 'Active'
  AND NOT EXISTS (
      SELECT CT.WorkerID
      FROM CERTIFICATES_TRAINING CT
      WHERE CT.WorkerID = W.IDCode
  );

-- query 20, type 2
EXPLAIN ANALYZE
SELECT W.IDCode, W.Name, W.Surname, MV.VisitDate, MV.Outcome
FROM WORKERS W
JOIN MEDICAL_VISITS MV ON W.IDCode = MV.WorkerID
WHERE W.EmploymentStatus = 'Active'
  AND MV.Outcome = 'Unfit'
  AND MV.VisitDate = (
      SELECT MAX(MV2.VisitDate)
      FROM MEDICAL_VISITS MV2
      WHERE MV2.WorkerID = W.IDCode
  );

-- query 20, view type
-- the view:
CREATE VIEW LATEST_VISITS AS
SELECT WorkerID, MAX(VisitDate) AS MaxDate
FROM MEDICAL_VISITS
GROUP BY WorkerID;

EXPLAIN ANALYZE
SELECT W.IDCode, W.Name, W.Surname, MV.VisitDate, MV.Outcome
FROM WORKERS W
JOIN MEDICAL_VISITS MV ON W.IDCode = MV.WorkerID
JOIN LATEST_VISITS LV ON MV.WorkerID = LV.WorkerID AND MV.VisitDate = LV.MaxDate
WHERE W.EmploymentStatus = 'Active'
  AND MV.Outcome = 'Unfit';