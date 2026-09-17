DROP DATABASE IF EXISTS Hospital_Management_System;
CREATE DATABASE Hospital_Management_System;

USE Hospital_Management_System;


-- ------------------------------------------------------------
-- Table: departments
-- ------------------------------------------------------------
DROP TABLE IF EXISTS Departments;
CREATE TABLE Departments (
	Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(100)
    );
    
-- ------------------------------------------------------------
-- Table: Doctors
-- ------------------------------------------------------------ 
DROP TABLE IF EXISTS Doctors;
CREATE TABLE Doctors (
		Doctor_ID   INT PRIMARY KEY,
        Doctor_Name   VARCHAR(100),
        Department_ID   INT NOT NULL,
        Specialization   VARCHAR(100),
        Consultation_fee   DECIMAL(10,2),
        Joining_Date   DATE NOT NULL,
        FOREIGN KEY (Department_id) REFERENCES Departments(Department_Id)
        );
        
-- ------------------------------------------------------------
-- Table: Patients
-- ------------------------------------------------------------
DROP TABLE IF EXISTS Patients;
CREATE TABLE Patients(
       Patient_ID    INT PRIMARY KEY,
       Patient_Name  VARCHAR(100),
       Gender       CHAR(10),
       Date_Of_Birth    DATE,
       City           VARCHAR(100),
       Registration_Date   DATE NOT NULL
       );
       
-- ------------------------------------------------------------
-- Table: Appointments
-- ------------------------------------------------------------       
DROP TABLE IF EXISTS Appointments;
CREATE TABLE Appointments(
		Appointment_ID    INT PRIMARY KEY ,
        Patient_ID       INT NOT NULL,
        Doctor_ID          INT NOT NULL,
        Appointment_Date    DATE NOT NULL,
        Appointment_Status    VARCHAR(20) NOT NULL DEFAULT 'Scheduled' ,
        FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_id),
        FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_id)
        );
 
 -- ------------------------------------------------------------
-- Table: Rooms
-- ------------------------------------------------------------       
DROP TABLE IF EXISTS Rooms;
CREATE TABLE ROOMS (
		ROOM_ID       INT PRIMARY KEY,
        Room_Number    INT NOT NULL,
        Room_Type        VARCHAR(20),
        Daily_Charges      DECIMAL (10,2)
        );
        
-- ------------------------------------------------------------
-- Table: Admission
-- ------------------------------------------------------------  
DROP TABLE IF EXISTS Admissions;     
CREATE TABLE Admissions(
	Admission_ID      INT PRIMARY KEY ,
    Doctor_ID       INT NOT NULL,
    Patient_ID       INT NOT NULL,
    Room_ID        INT NOT NULL,
    Admission_Date    DATE NOT NULL,
    Discharge_Date    DATE  NULL,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (Room_ID) REFERENCES Rooms(Room_ID)
);

-- ------------------------------------------------------------
-- Table: Prescriptions
-- ------------------------------------------------------------       
DROP TABLE IF EXISTS Prescriptions;
CREATE TABLE Prescriptions(
    prescription_id    INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id    INT NOT NULL,
    medicine_name      VARCHAR(100) NOT NULL,
    dosage            VARCHAR(50),
    duration_days         INT,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- ------------------------------------------------------------
-- Table: Billings
-- ------------------------------------------------------------ 
DROP TABLE IF EXISTS Billings;
CREATE TABLE Billings(
	Bill_ID         INT PRIMARY KEY,
    Admission_ID      INT NOT NULL,
    Appointment_ID       INT NOT NULL,
    Total_Amt         DECIMAL (10,2),
    Bill_Date           DATE NOT NULL,
    Payment_Method       VARCHAR(30),
    Payment_Status     VARCHAR(30) NOT NULL DEFAULT 'Paid',
    FOREIGN KEY (Appointment_id) REFERENCES Appointments(Appointment_ID),
    FOREIGN KEY (Admission_id) REFERENCES Admissions(Admission_ID)
    );
    
ALTER TABLE Rooms
MODIFY Room_Number VARCHAR(20);

ALTER TABLE Billings 
MODIFY Admission_ID INT NULL;

ALTER TABLE Billings 
MODIFY Appointment_ID INT NULL;

DESCRIBE Departments;
DESCRIBE Billings;
DESCRIBE Admissions;
DESCRIBE Appointments;
DESCRIBE Patients;
DESCRIBE Rooms;

/*SET SQL_SAFE_UPDATES=0;
DELETE FROM Departments;
DELETE FROM Doctors;
DELETE FROM Patients;
DELETE FROM appointments;*/

SELECT PAtient_ID FROM appointments 
WHERE patient_id= 131;

-- Appointments.Doctor_ID
	CREATE INDEX Idx_Appointments_Doctor_ID
	ON Appointments (Doctor_id);

-- Appointments.Patient_id
	CREATE INDEX Idx_Appointments_patients_ID
	ON Appointments (patient_id);
    

    
  
  

SELECT *
FROM Appointments
LIMIT 2;

Update appointments
Set appointment_status = 'scheduled'
WHERE appointment_id =2;

SELECT Appointment_ID, Appointment_Status
FROM Appointments
WHERE Appointment_ID = 2;

SELECT
    Appointment_Status,
    COUNT(*) AS Appointment_Count
FROM Appointments
GROUP BY Appointment_Status;