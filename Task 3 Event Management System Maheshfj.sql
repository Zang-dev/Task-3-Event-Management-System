-- File: task3_events_mgmt_mysql.sql
DROP DATABASE IF EXISTS EventsManagement;
CREATE DATABASE EventsManagement;
USE EventsManagement;

CREATE TABLE Events (
  Event_Id INT PRIMARY KEY AUTO_INCREMENT,
  Event_Name VARCHAR(150) NOT NULL,
  Event_Date DATE NOT NULL,
  Event_Location VARCHAR(150) NOT NULL,
  Event_Description VARCHAR(500)
) ENGINE=InnoDB;

CREATE TABLE Attendees (
  Attendee_Id INT PRIMARY KEY AUTO_INCREMENT,
  Attendee_Name VARCHAR(150) NOT NULL,
  Attendee_Phone VARCHAR(20),
  Attendee_Email VARCHAR(150) UNIQUE,
  Attendee_City VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE Registrations (
  Registration_id INT PRIMARY KEY AUTO_INCREMENT,
  Event_Id INT NOT NULL,
  Attendee_Id INT NOT NULL,
  Registration_Date DATE NOT NULL,
  Registration_Amount DECIMAL(10,2) CHECK (Registration_Amount >= 0),
  CONSTRAINT fk_reg_event FOREIGN KEY (Event_Id)
    REFERENCES Events(Event_Id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_reg_attendee FOREIGN KEY (Attendee_Id)
    REFERENCES Attendees(Attendee_Id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- data
INSERT INTO Events (Event_Name, Event_Date, Event_Location, Event_Description) VALUES
('Tech Summit India',   '2025-09-10', 'Bengaluru', 'Annual technology conference in India'),
('Data & AI Expo',      '2025-10-05', 'Hyderabad', 'Data analytics and AI exhibition'),
('Startup Pitch India', '2025-08-25', 'Mumbai',    'Pitch competition for Indian startups');

INSERT INTO Attendees (Attendee_Name, Attendee_Phone, Attendee_Email, Attendee_City) VALUES
('Aarav Sharma',  '+91-9876543210', 'aarav@demo.in',     'Gurugram'),
('Isha Patel',    '+91-9810022334', 'isha@demo.in',      'Ahmedabad'),
('Rohan Mehta',   '+91-9001234567', 'rohan@demo.in',     'Pune'),
('Diya Nair',     '+91-8080808080', 'diya@demo.in',      'Kochi'),
('Arjun Reddy',   '+91-9123456789', 'arjun@demo.in',     'Hyderabad'),
('Neha Gupta',    '+91-9999912345', 'neha@demo.in',      'Ghaziabad');

INSERT INTO Registrations (Event_Id, Attendee_Id, Registration_Date, Registration_Amount) VALUES
(1, 1, '2025-08-01', 2500.00),
(1, 2, '2025-08-02', 2500.00),
(2, 3, '2025-09-01', 3500.00),
(2, 4, '2025-09-02', 3500.00),
(3, 2, '2025-07-20', 1500.00),
(3, 5, '2025-07-22', 1500.00);

-- 3a) Insert new event
INSERT INTO Events (Event_Name, Event_Date, Event_Location, Event_Description)
VALUES ('Cloud World India', '2025-11-12', 'Delhi', 'Cloud technologies and practices');

-- 3b) Update event info (example: Event_Id = 1)
UPDATE Events
SET Event_Location = 'Bengaluru (Koramangala)',
    Event_Description = 'Updated agenda and speakers'
WHERE Event_Id = 1;

-- 3c) Delete event (example: Event_Id = 3)
DELETE FROM Events WHERE Event_Id = 3;

-- 4a) Insert a new attendee
INSERT INTO Attendees (Attendee_Name, Attendee_Phone, Attendee_Email, Attendee_City)
VALUES ('Sanya Verma', '+91-9811112233', 'sanya@demo.in', 'Delhi');

-- 4b) Register attendee for an event (example: new attendee to Event_Id = 2)
INSERT INTO Registrations (Event_Id, Attendee_Id, Registration_Date, Registration_Amount)
VALUES (2, LAST_INSERT_ID(), CURDATE(), 3500.00);

-- 5. retreive event information,generate attendee lists, calculate event attendance statistics

-- 1) Event information
SELECT *
FROM Events;

-- 2) Specific event information (replace ? with an Event_Id, e.g., 1)
SELECT *
FROM Events
WHERE Event_Id = ?;

-- 3) Attendees information
SELECT *
FROM Attendees;

-- 4) Specific event’s attendees (by Event_Id)
SELECT
  A.Attendee_Name,
  A.Attendee_Email,
  A.Attendee_Phone
FROM Attendees AS A
JOIN Registrations AS R
  ON A.Attendee_Id = R.Attendee_Id
WHERE R.Event_Id = ?;

-- 5) Overall event attendance statistics
SELECT
  E.Event_Id,
  E.Event_Name,
  COUNT(R.Registration_id) AS Total_Attendees,
  COALESCE(SUM(R.Registration_Amount), 0) AS Total_Amount,
  COALESCE(AVG(R.Registration_Amount), 0) AS Average_Amount,
  COALESCE(MIN(R.Registration_Amount), 0) AS Minimum_Amount,
  COALESCE(MAX(R.Registration_Amount), 0) AS Maximum_Amount
FROM Events AS E
LEFT JOIN Registrations AS R
  ON E.Event_Id = R.Event_Id
GROUP BY
  E.Event_Id,
  E.Event_Name
ORDER BY
  E.Event_Name;

