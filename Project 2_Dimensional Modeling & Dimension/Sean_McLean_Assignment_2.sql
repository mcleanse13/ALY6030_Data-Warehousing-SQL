
create database module2assignment;
USE module2assignment;

#4a: Analysis for Leadership
#Query 1: Top 10 Hospitals by Total ICU or SICU License Beds
SELECT 
    b.business_name AS hospital_name,
    SUM(f.license_beds) AS total_license_beds
FROM 
    bed_fact f
JOIN 
    bed_type t ON f.bed_id = t.bed_id
JOIN 
    business b ON f.ims_org_id = b.ims_org_id
WHERE 
    t.bed_id IN (4, 15) #ICU or SICU beds
GROUP BY 
    b.business_name
ORDER BY 
    total_license_beds DESC
LIMIT 10;

#Query 2: Top 10 Hospitals by Total ICU or SICU Census Beds
SELECT 
    b.business_name AS hospital_name,
    SUM(f.census_beds) AS total_census_beds
FROM 
    bed_fact f
JOIN 
    bed_type t ON f.bed_id = t.bed_id
JOIN 
    business b ON f.ims_org_id = b.ims_org_id
WHERE 
    t.bed_id IN (4, 15) #ICU or SICU beds
GROUP BY 
    b.business_name
ORDER BY 
    total_census_beds DESC
LIMIT 10;

#Query 3: Top 10 Hospitals by Total ICU or SICU Staffed Beds
SELECT 
    b.business_name AS hospital_name,
    SUM(f.staffed_beds) AS total_staffed_beds
FROM 
    bed_fact f
JOIN 
    bed_type t ON f.bed_id = t.bed_id
JOIN 
    business b ON f.ims_org_id = b.ims_org_id
WHERE 
    t.bed_id IN (4, 15) #ICU or SICU beds
GROUP BY 
    b.business_name
ORDER BY 
    total_staffed_beds DESC
LIMIT 10;

#5a: Drill Down Investigation
#Query 1: Top 10 Hospitals by Total ICU and SICU License Beds
SELECT 
    b.business_name AS hospital_name,
    SUM(f.license_beds) AS total_license_beds
FROM 
    bed_fact f
JOIN 
    bed_type t ON f.bed_id = t.bed_id
JOIN 
    business b ON f.ims_org_id = b.ims_org_id
WHERE 
    t.bed_id = 4 # ICU
    AND EXISTS (
        SELECT 1 
        FROM bed_fact f2
        WHERE f2.ims_org_id = f.ims_org_id
          AND f2.bed_id = 15 #ICU
    )
GROUP BY 
    b.business_name
ORDER BY 
    total_license_beds DESC
LIMIT 10;

#Query 2: Top 10 Hospitals by Total ICU and SICU Census Beds
SELECT 
    b.business_name AS hospital_name,
    SUM(f.census_beds) AS total_census_beds
FROM 
    bed_fact f
JOIN 
    bed_type t ON f.bed_id = t.bed_id
JOIN 
    business b ON f.ims_org_id = b.ims_org_id
WHERE 
    t.bed_id = 4 #ICU
    AND EXISTS (
        SELECT 1 
        FROM bed_fact f2
        WHERE f2.ims_org_id = f.ims_org_id
          AND f2.bed_id = 15 #ICU
    )
GROUP BY 
    b.business_name
ORDER BY 
    total_census_beds DESC
LIMIT 10;

#Query 3: Top 10 Hospitals by Total ICU and SICU Staffed Beds
SELECT 
    b.business_name AS hospital_name,
    SUM(f.staffed_beds) AS total_staffed_beds
FROM 
    bed_fact f
JOIN 
    bed_type t ON f.bed_id = t.bed_id
JOIN 
    business b ON f.ims_org_id = b.ims_org_id
WHERE 
    t.bed_id = 4 #ICU
    AND EXISTS (
        SELECT 1 
        FROM bed_fact f2
        WHERE f2.ims_org_id = f.ims_org_id
          AND f2.bed_id = 15 #ICU
    )
GROUP BY 
    b.business_name
ORDER BY 
    total_staffed_beds DESC
LIMIT 10;