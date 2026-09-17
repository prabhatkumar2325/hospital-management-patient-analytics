USE Hospital_Management_System;

-- ============================================================
-- SECTION 1: HOSPITAL OVERVIEW
-- =============================================================

-- Q1. How many total patients are registered in the hospital?
-- Business Purpose:
-- To determine the total number of registered patients.

	SELECT 
		COUNT(*) AS Total_patient_Count
	FROM Patients;    

-- Q2. How many doctors currently work in the hospital ?
-- Business purpose
-- To determine the total number of doctors working at the Hospitals.

	SELECT 
		COUNT(*) AS Total_Doctor_count
	FROM Doctors;

-- Q3. How many departments are available in the hospital?
-- Business purpose :
-- To deterrmine Total number of departments available in hospital.

	SELECT 
		COUNT(*) AS Total_Department_Count
	FROM Departments; 

-- Q4. How many appointments have been recorded in the hospital?
-- Business Purpose :
-- To Determine total number of appointment record in hospitals. 

	SELECT 
		COUNT(*) AS Total_Appointment_Count
	FROM Appointments;   
    
-- Q5. Total Revenue Genarated by Hospital ?
-- Purpose :
-- To calculate the total revenue.
    
    SELECT 
		SUM(Total_Amt) AS Total_Revenue
    FROM Billings;    
    
    
    
-- ============================================================
-- SECTION 2: DOCTOR & DEPARTMENT ANALYSIS
-- ============================================================= 

-- Q5	How many doctors are working in each department?	JOIN + GROUP BY
	SELECT 
		Department_name,
		COUNT(Doctor_id) AS Total_Doctor_Count
	FROM Departments D 
	JOIN Doctors Doc
		ON D.department_Id = Doc.Department_Id
	GROUP BY Department_Name;
   
-- Q6	Which department has the highest number of doctors?	JOIN + GROUP BY + ORDER BY
	
    SELECT 
		Department_name,
		COUNT(Doctor_id) AS Total_Doctor_Count
	FROM Departments D 
	JOIN Doctors Doc
		ON D.department_Id = Doc.Department_Id
	GROUP BY Department_Name
    ORDER BY COUNT(Doctor_id) DESC ; 
	
-- Q7	How many appointments has each doctor handled?	JOIN + GROUP BY

	SELECT 
		Doctor_name,
		COUNT(Appointment_id) AS Total_Appointment_Count
	FROM Appointments A
	JOIN Doctors Doc
		ON Doc.Doctor_id = A.doctor_Id
	GROUP BY Doctor_name;

-- Q8	Which doctor has handled the highest number of appointments?	GROUP BY + ORDER BY + LIMIT
	
    SELECT 
		Doctor_name,
		COUNT(Appointment_id) AS Total_Appointment_Count
	FROM Appointments A
	JOIN Doctors Doc
		ON Doc.Doctor_id = A.doctor_Id
	GROUP BY Doctor_name
    ORDER BY COUNT(Appointment_id) DESC
    LIMIT 1;

-- Q9	What is the average consultation fee by department?	JOIN + AVG()
	
    SELECT 
		Department_name,
        ROUND(AVG(Consultation_Fee),2) AS Average_Fees
	FROM Doctors Doc
    JOIN Departments D
		ON D.department_id = Doc.department_id
    GROUP BY Department_Name;
    
-- Q10	Which doctors charge more than the hospital's average consultation fee?
	
    SELECT 
		Doctor_Name,
		Consultation_Fee
	FROM Doctors
	WHERE  Consultation_Fee > 
			( SELECT AVG(Consultation_Fee) 
			FROM Doctors
	)
	ORDER BY Consultation_Fee DESC;

 
-- ============================================================
-- SECTION 3: PATIENT ANALYSIS
-- ============================================================= 

#	Business Question	Main SQL
-- Q11	What is the gender distribution of patients?	GROUP BY + COUNT()

SELECT 
    Gender,
    COUNT(Patient_Id) AS Patient_Count,
    CONCAT(ROUND(COUNT(Patient_id) * 100.0 / ( SELECT COUNT(*) FROM Patients),0), '%') AS Percentage
FROM Patients
GROUP BY Gender;    

-- Q12	Which patients have visited the hospital more than once?	GROUP BY + HAVING

	SELECT
		Patient_Name,
		COUNT(*) AS Hospital_Visit
	FROM Appointments A 
	JOIN Patients P
		ON p.patient_Id = A.patient_Id
	GROUP BY Patient_Name
	HAVING COUNT(*) >1
	ORDER BY COUNT(*) DESC;   

-- Q13	Find patients who have both appointments and hospital admissions.	JOIN / EXISTS

SELECT 
	DISTINCT Patient_name
FROM patients p 
JOIN Appointments A
	ON P.patient_id = a.patient_id
JOIN Admissions Ad
	ON Ad.patient_id = p.patient_id ;
    
-- USING EXISTS
SELECT 
	DISTINCT Patient_name
FROM patients p 
WHERE EXISTS (
	SELECT 1
    FROM Appointments a
    WHERE a.patient_id = p.patient_id
)
AND EXISTS(
	SELECT 1
    FROM Admissions Ad
    WHERE Ad.patient_id = p.patient_id
);

-- Q14	Find patients who have appointments but have never been admitted.	LEFT JOIN + IS NULL
SELECT 
	DISTINCT Patient_Name
 FROM Appointments A 
 JOIN Patients  p
	ON p.Patient_id = a.patient_id
LEFT JOIN Admissions Ad
	ON p.patient_id = ad.patient_id
WHERE Ad.patient_Id IS NULL;  

-- USING NOT EXISTS
 
SELECT 
	DISTINCT Patient_Name
FROM patients p
JOIN appointments a  
ON a.patient_id = p.patient_id

WHERE NOT EXISTS (
SELECT 1
FROM Admissions Ad
WHERE Ad.patient_id = p.patient_id)  ;

-- Q15	What percentage of patients have visited the hospital more than once?


-- ============================================================
-- SECTION 4: APPOINTMENT ANALYSIS - 5
-- ============================================================= 

-- Q16	What is the distribution of appointment statuses?	GROUP BY + COUNT()
	SELECT 
		Appointment_Status,
		COUNT(Appointment_Id) AS Appintment_Count
	FROM Appointments
	GROUP BY Appointment_Status;
    
-- Q17	Which doctor has the highest number of completed appointments?	WHERE + JOIN + GROUP BY

SELECT 
	Doctor_Name,
    COUNT(appointment_Id) AS Appointment_Count
    
FROM Appointments A
JOIN Doctors Doc
ON Doc.Doctor_id = a.doctor_id
WHERE Appointment_Status = 'Completed'
GROUP BY Doctor_Name
ORDER BY Appointment_Count DESC ;

-- Using CTE
WITH CTE AS(
	SELECT 
		Doctor_Name,
        COUNT(Appointment_id) AS Apponitment_Count,
		ROW_NUMBER() OVER(ORDER BY COUNT(Appointment_id) DESC) AS rnk
	FROM Appointments A
	JOIN Doctors Doc
	ON Doc.Doctor_id = a.doctor_id
	WHERE Appointment_Status = 'Completed'
	GROUP BY Doctor_Name
)
SELECT * FROM CTE
WHERE Rnk=1;

-- Q18	Which department receives the highest number of appointments?	JOIN + GROUP BY
	
    SELECT
		Department_Name,
        COUNT(Appointment_Id) AS Appointment_count,
        DENSE_RANK() OVER(ORDER BY COUNT(Appointment_Id) DESC ) AS Rnk
    FROM Departments D
    JOIN Doctors Doc
		ON d.department_id = doc.department_id
    JOIN Appointments A
		ON a.doctor_id = doc.doctor_id
	GROUP BY Department_Name;

    
-- Q19	What is the monthly appointment trend?	DATE_FORMAT() + GROUP BY

	SELECT 
		DATE_FORMAT( Appointment_Date,'%Y-%M') AS monthly_Trend,
		COUNT(Appointment_Id) AS Total_Appointment
	FROM appointments
	GROUP BY (monthly_Trend)
	ORDER BY Total_Appointment DESC;    

-- Q20	Which doctors have handled more appointments than the average doctor?

	WITH CTE AS (
		SELECT 
		Doctor_Name,
		COUNT(*) AS Appointment_Count
		FROM Doctors d
		JOIN Appointments a
			ON d.doctor_id = a.doctor_id
		GROUP BY Doctor_name
	)
	SELECT
		Doctor_Name,
		Appointment_count
	FROM CTE
	WHERE Appointment_Count > 
		(SELECT AVG(Appointment_Count)
		FROM CTE);

-- Q21. Which departments have more admissions than the average department?

	WITH CTE AS(
		SELECT 
			Department_Name,
			COUNT(Admission_id) AS Admission_Count
		FROM Admissions a 
		JOIN Doctors doc
			ON a.doctor_id = doc.doctor_id
		JOIN Departments d 
			ON d.department_id = doc.department_id
		GROUP BY Department_name
		)
		SELECT
			Department_Name,
			Admission_Count
		FROM CTE
			WHERE Admission_Count > 
			(SELECT AVG(Admission_Count) 
			FROM CTE);


-- ============================================================
-- SECTION 5: ADMISSION & ROOM ANALYSIS 
-- ============================================================= 
#	Business Question	Main SQL

-- Q22	How many patients are currently admitted?	IS NULL

	SELECT
		Patient_name,
		Admission_Date,
		Discharge_Date
	FROM Patients p
	JOIN Admissions Ad
		ON p.patient_Id = Ad.patient_Id
	WHERE Discharge_Date IS NULL ;
    
-- Q23	Which rooms have been used most frequently?	JOIN + GROUP BY + COUNT()

	SELECT 
		r.Room_ID,
		r.Room_Number,
		r.Room_Type,
		COUNT(a.Admission_ID) AS Admission_Count
	FROM Admissions a
	JOIN Rooms r
		ON r.Room_ID = a.Room_ID
	GROUP BY r.Room_ID, r.Room_Number, r.Room_Type
	ORDER BY Admission_Count DESC;   

-- Q24	What is the average length of hospital stay?	DATEDIFF() + AVG()

	SELECT
		AVG(DATEDIFF(Discharge_Date,Admission_Date)) AS Avg_Length_of_stay_days
		FROM Admissions
	WHERE Discharge_date IS NOT NULL;    

-- Q25	Which department has the highest number of admissions?	JOIN × 2 + GROUP BY

SELECT 
	Department_Name,
    COUNT(Admission_Id) AS Admission_Count
FROM Admissions a 
JOIN Doctors doc
	ON a.doctor_id = doc.doctor_id
JOIN Departments d 
	ON d.department_id = doc.department_id
GROUP BY Department_name
ORDER BY Admission_count DESC
LIMIT 1;    


-- ============================================================
-- SECTION 6: BILLINGS & REVENUE
-- ============================================================= 

-- Q26	What is the total revenue generated by the hospitals ?

	SELECT 
		SUM(Total_Amt) AS Total_Revenue
	FROM Billings;   
 
-- 27	What is the average bill amount ?

	SELECT 
		ROUND(AVG(Total_Amt),2) AS Total_Revenue
	FROM Billings;

-- Q28	What is the monthly hospital revenue?
	
    SELECT
		DATE_FORMAT(Bill_Date,'%Y-%M') AS Monthly_Trend,
		SUM(Total_Amt) AS Total_Revenue
	FROM Billings
	GROUP BY Monthly_Trend
    ORDER BY Total_Revenue DESC;    
    
-- ============================================================
-- SECTION 7: BILLINGS & REVENUE
-- ============================================================= 
-- Q29	Rank doctors based on their appointment count.	RANK() + OVER()
	
    SELECT
		Doctor_Name,
		COUNT(Appointment_id) AS Appointment_Count,
		DENSE_RANK() OVER(ORDER BY COUNT(Appointment_id) DESC) AS Rnk
	FROM Appointments A
	JOIN Doctors Doc
		ON a.Doctor_id = doc.doctor_id
	GROUP BY Doctor_name;     

-- Q30	Find the top 3 doctors in each department.

	WITH Doctor_Ranking AS(
		SELECT
			Doctor_Name,
			Department_Name,
			COUNT(Appointment_id) AS Appointment_Count,
			ROW_NUMBER() OVER(PARTITION BY Department_Name 
						ORDER BY COUNT(Appointment_id) DESC) AS Rnk
			FROM Departments D
			JOIN Doctors Doc
				ON D.department_id = doc.department_id
			JOIN Appointments A 
				ON a.doctor_id = doc.doctor_id
			GROUP BY Doctor_Name, Department_Name
			)
			
			SELECT
				Doctor_Name,
				Department_Name,
				Appointment_count,
				Rnk
		   FROM Doctor_Ranking  
		   WHERE Rnk <=3;
           
  
-- ============================================================
-- DASHBOARD KPI QUERIES
-- ============================================================

-- Total Patients 
	SELECT 
		COUNT(Patient_id) AS Total_Patient
    FROM Patients; 
    
-- Total Doctors → Q2
	
    SELECT 
		COUNT(Doctor_id) AS Total_doctor
    FROM Doctors;
    
-- Total Departments → Q3

    SELECT 
		COUNT(Department_id) AS Total_Department
    FROM Departments;
    
-- Total Appointments 

    SELECT 
		COUNT(appointment_id) AS Total_appointment
    FROM appointments;
    
-- Total Admissions 

    SELECT 
		COUNT(Admission_id) AS Total_Admission
    FROM Admissions;
    
-- Current Inpatients 

-- Average Length of Stay 

	SELECT
			Patient_name,
			Admission_Date,
			Discharge_Date
		FROM Patients p
		JOIN Admissions Ad
			ON p.patient_Id = Ad.patient_Id
		WHERE Discharge_Date IS NULL ;
    
-- Total Revenue →

	SELECT 
		SUM(Total_Amt) AS Total_Revenue
	FROM Billings; 
    
-- Average Bill Amount → Q26

	SELECT 
		ROUND(AVG(Total_Amt),2) AS Total_Revenue
	FROM Billings;
    
-- Cancellation Rate → Q16-based calculation

SELECT
    ROUND(
        COUNT(CASE 
            WHEN Appointment_Status = 'Cancelled' THEN 1 
        END) * 100.0 / COUNT(*),
        2
    ) AS Cancellation_Rate_Percent
FROM Appointments;