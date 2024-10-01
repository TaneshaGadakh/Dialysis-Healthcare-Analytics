CREATE DATABASE DIALYSIS;
USE DIALYSIS;

/*1. Number of Patients across various summaries*/
SELECT 'Transfusion Summary' AS "Summary Type", SUM(No_of_patients_in_transfusion_summary) AS "Total No. of Patients" FROM d1
UNION ALL
SELECT 'Hypercalcemia Summary', SUM(No_of_patients_in_hypercalcemia_summary) FROM d1
UNION ALL
SELECT 'Serum Phosphorus Summary', SUM(No_of_patients_in_Serum_phosphorus_summary) FROM d1
UNION ALL
SELECT 'Hospitalization Summary', SUM(No_of_patients_in_hospitalization_summary) FROM d1
UNION ALL
SELECT 'Hospital Readmission Summary', SUM(No_of_patients_in_hospital_readmission_summary) FROM d1
UNION ALL
SELECT 'Survival Summary', SUM(No_of_Patients_in_survival_summary) FROM d1
UNION ALL
SELECT 'Fistula Summary', SUM(No_of_Patients_in_fistula_summary) FROM d1
UNION ALL
SELECT 'Long Term Catheter Summary', SUM(No_of_patients_in_long_term_catheter_summary) FROM d1
UNION ALL
SELECT 'nPCR Summary', SUM(No_of_patients_in_nPCR_summary) FROM d1;

/*2. Profit Vs Non-Profit Stats*/
SELECT t1.Profit_or_Non_Profit AS Organization_Type, 
CONCAT(ROUND(COUNT(t1.Provider_Number) * 100.0 / t2.TotalCount,2),"%") AS Percentage
FROM d1 t1
JOIN (SELECT COUNT(Provider_Number) AS TotalCount FROM d1) t2
GROUP BY t1.Profit_or_Non_Profit, t2.TotalCount;

/*3. Chain Organizations w.r.t. Total Performance Score as No Score*/
SELECT t1.Chain_Organization AS "Chain Organization",
COUNT(t2.Total_Performance_Score) AS "No. of Organizations"
FROM d1 t1
JOIN d2 t2 ON t1.Provider_Number=t2.CMS_Certification_Number_CCN
WHERE t2.Total_Performance_Score='No Score'
GROUP BY t1.Chain_Organization
ORDER BY COUNT(t2.Total_Performance_Score) DESC;

/*4. Dialysis Stations Stats*/
SELECT State, SUM(No_of_Dialysis_Stations) AS "No. of Dialysis Stations"
FROM d1
GROUP BY State
ORDER BY SUM(No_of_Dialysis_Stations) DESC;

/*5. No. of Category Text - As Expected*/
SELECT 'Transfusion Category' AS "Category",
SUM(CASE WHEN Patient_Transfusion_category_text="As Expected" THEN 1 ELSE 0 END) AS "Category Text - As Expected" FROM d1
UNION ALL
SELECT 'hospitalization_category', 
SUM(CASE WHEN Patient_hospitalization_category_text="As Expected" THEN 1 ELSE 0 END) FROM d1
UNION ALL
SELECT 'Hospital Readmission Category', 
SUM(CASE WHEN Patient_Hospital_Readmission_Category="As Expected" THEN 1 ELSE 0 END) FROM d1
UNION ALL
SELECT 'Survival Category', 
SUM(CASE WHEN Patient_Survival_Category_Text="As Expected" THEN 1 ELSE 0 END) FROM d1
UNION ALL
SELECT 'Infection Category', 
SUM(CASE WHEN Patient_Infection_category_text="As Expected" THEN 1 ELSE 0 END) FROM d1
UNION ALL
SELECT 'Fistula Category', 
SUM(CASE WHEN Fistula_Category_Text="As Expected" THEN 1 ELSE 0 END) FROM d1
UNION ALL
SELECT 'SWR Category', 
SUM(CASE WHEN SWR_category_text="As Expected" THEN 1 ELSE 0 END) FROM d1
UNION ALL
SELECT 'PPPW Category', 
SUM(CASE WHEN PPPW_category_text="As Expected" THEN 1 ELSE 0 END) FROM d1;

/*6. Average Payment Reduction Rate*/
UPDATE d2
SET PY2020_Payment_Reduction_Percentage = 0
WHERE PY2020_Payment_Reduction_Percentage = 'No Reduction';

SELECT CONCAT(ROUND(AVG(PY2020_Payment_Reduction_Percentage)*100,2),"%") AS "Average Payment Reduction Rate"
FROM d2;

--- KPIs ---

/*Total Facilities*/
SELECT
CONCAT(ROUND(((SELECT COUNT(DISTINCT Facility_Name) 
FROM d1) +
(SELECT COUNT(DISTINCT Facility_Name)
FROM d2))/1000,2),"K")  AS "Total Facilities";

/*Total Chain Oragnizations*/
SELECT COUNT(DISTINCT Chain_Organization) AS "Total Chain Oragnizations"
FROM d1;

/*Total Dialysis Stations*/
SELECT CONCAT(ROUND(SUM(No_of_Dialysis_Stations)/1000,2),"K") AS "Total Dialysis Stations"
FROM d1;

/*Total Patients*/
SELECT 
CONCAT(ROUND(SUM(
No_of_patients_in_transfusion_summary +
No_of_patients_in_hypercalcemia_summary +
No_of_patients_in_Serum_phosphorus_summary +
No_of_patients_in_hospitalization_summary +
No_of_patients_in_hospital_readmission_summary +
No_of_Patients_in_survival_summary +
No_of_Patients_in_fistula_summary +
No_of_patients_in_long_term_catheter_summary +
No_of_patients_in_nPCR_summary)/1000000,2),"M") AS "Total_Patients"
FROM d1;

/*Total Discharges*/
SELECT CONCAT(ROUND(SUM(No_of_Index_Discharges_in_SRR)/1000,2),"K") AS "Total Discharges"
FROM d2;