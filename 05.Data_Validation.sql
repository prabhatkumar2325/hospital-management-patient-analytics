-- ------------------------------------------------------------
-- Row_Count
-- ------------------------------------------------------------
SELECT 'Departments' AS Table_Name, COUNT(*) AS Total_Rows
FROM Departments

UNION ALL

SELECT 'Doctors', COUNT(*)
FROM Doctors

UNION ALL

SELECT 'Patients', COUNT(*)
FROM Patients

UNION ALL

SELECT 'Appointments', COUNT(*)
FROM Appointments

UNION ALL

SELECT 'Prescriptions', COUNT(*)
FROM Prescriptions

UNION ALL

SELECT 'Rooms', COUNT(*)
FROM Rooms

UNION ALL

SELECT 'Admissions', COUNT(*)
FROM Admissions

UNION ALL

SELECT 'Billings', COUNT(*)
FROM Billings;

-- ------------------------------------------------------------
-- Check null Values
-- ------------------------------------------------------------
SELECT * FROM Patients
WHERE patient_name IS NULL
	OR gender IS NULL
	OR Date_Of_Birth IS NULL
	OR Registration_Date IS NULL;
    
-- ------------------------------------------------------------
-- Admission 
-- ------------------------------------------------------------
SELECT * FROM Admissions
WHERE Discharge_Date IS NULL;    

-- ------------------------------------------------------------
-- Presctription
-- ------------------------------------------------------------
SELECT * FROM Prescriptions 
	WHERE dosage IS NULL
	OR Duration_Days IS NULL;

-- ------------------------------------------------------------
-- Check Foreign Key
-- ------------------------------------------------------------

SELECT a.*
FROM Appointments a
LEFT JOIN Patients p
    ON a.Patient_ID = p.Patient_ID
LEFT JOIN Doctors d
    ON a.Doctor_ID = d.Doctor_ID
WHERE p.Patient_ID IS NULL
   OR d.Doctor_ID IS NULL;    
   
-- ------------------------------------------------------------
-- Prescriptions
-- ------------------------------------------------------------
SELECT pr.*
FROM Prescriptions pr
LEFT JOIN Appointments a
    ON pr.Appointment_ID = a.Appointment_ID
WHERE a.Appointment_ID IS NULL;

-- ------------------------------------------------------------
-- Admissions
-- ------------------------------------------------------------
SELECT ad.*
FROM Admissions ad
LEFT JOIN Patients p
    ON ad.Patient_ID = p.Patient_ID
LEFT JOIN Doctors d
    ON ad.Doctor_ID = d.Doctor_ID
LEFT JOIN Rooms r
    ON ad.Room_ID = r.Room_ID
WHERE p.Patient_ID IS NULL
   OR d.Doctor_ID IS NULL
   OR r.Room_ID IS NULL;
   
-- -------------------------------------------------------------
-- Invalid Admission IDs
-- -------------------------------------------------------------   
SELECT b.*
FROM Billings b
LEFT JOIN Admissions a
    ON b.Admission_ID = a.Admission_ID
WHERE b.Admission_ID IS NOT NULL
  AND a.Admission_ID IS NULL;

-- ------------------------------------------------------------
-- Invalid Appointment Ids
-- ------------------------------------------------------------
SELECT b.*
FROM Billings b
LEFT JOIN Appointments ap
    ON b.Appointment_ID = ap.Appointment_ID
WHERE b.Appointment_ID IS NOT NULL
  AND ap.Appointment_ID IS NULL;
  
-- ------------------------------------------------------------
-- Check Billing business logic
-- ------------------------------------------------------------  
SELECT *
FROM Billings
WHERE Admission_ID IS NULL
  AND Appointment_ID IS NULL;
  
SELECT *
FROM Billings
WHERE Admission_ID IS NOT NULL
  AND Appointment_ID IS NOT NULL;
  
-- ------------------------------------------------------------
-- Check Date logics
-- ------------------------------------------------------------  
SELECT * FROM Admissions
WHERE Discharge_Date IS NOT NULL
	AND Discharge_Date < Admission_Date;
    
-- -----------------------------------------------------------
-- Appointment vs patient registration
-- -----------------------------------------------------------    
SELECT * 
FROM Appointments ap
JOIN Patients p
	ON ap.patient_id = p.patient_Id 
WHERE ap.appointment_Date < p.Registration_Date;    

SELECT b.*, a.Admission_Date
FROM Billings b
JOIN Admissions a
    ON b.Admission_ID = a.Admission_ID
WHERE b.Bill_Date < a.Admission_Date;

SELECT Patient_ID, COUNT(*) AS Total
FROM Patients
GROUP BY Patient_ID
HAVING COUNT(*) > 1;

SELECT
    a.Appointment_ID,
    a.Patient_ID,
    p.Registration_Date,
    a.Appointment_Date
FROM Appointments a
JOIN Patients p
    ON a.Patient_ID = p.Patient_ID
WHERE a.Appointment_Date < p.Registration_Date
ORDER BY a.Patient_ID, a.Appointment_Date;
