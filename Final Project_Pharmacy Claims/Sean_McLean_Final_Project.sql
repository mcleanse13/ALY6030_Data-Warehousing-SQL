-- Final Project - Sean McLean
-- Part 2) Primary and Foreign Key Setup in MySQL
create database finalproject;

use finalproject;

-- Verify data is in the columns
select * from dim_member;
select * from fact_claims;

-- Descriptive Statistics of the Database Columns
DESCRIBE fact_claims;
DESCRIBE dim_member;

-- Adding primary keys to each table by using the 'ID' as a surrogate primary key in each dimension and fact table.
ALTER TABLE dim_member
ADD primary key (ID);

-- Adding the Foreign Keys
-- Reference: https://www.w3schools.com/sql/sql_create_index.asp
CREATE INDEX idx_member_id ON dim_member(member_id);
ALTER TABLE fact_claims
ADD CONSTRAINT fk_dim_member
FOREIGN KEY (member_id)
REFERENCES dim_member(member_id)
ON DELETE CASCADE
ON UPDATE SET NULL;

CREATE INDEX idx_drug_id ON dim_drug(drug_id);
ALTER TABLE fact_claims
ADD CONSTRAINT fk_dim_drug
FOREIGN KEY (drug_id)
REFERENCES dim_drug(drug_id)
ON DELETE CASCADE
ON UPDATE SET NULL;

CREATE INDEX idx_fill_date_id ON dim_fill_date(fill_date_id);
ALTER TABLE fact_claims
ADD CONSTRAINT fk_dim_fill_date
FOREIGN KEY (fill_date_id)
REFERENCES dim_fill_date(fill_date_id)
ON DELETE CASCADE
ON UPDATE SET NULL;

CREATE INDEX idx_brand_generic_id ON dim_brand_generic(brand_generic_id);
ALTER TABLE fact_claims
ADD CONSTRAINT fk_dim_brand_generic
FOREIGN KEY (brand_generic_id)
REFERENCES dim_brand_generic(brand_generic_id)
ON DELETE CASCADE
ON UPDATE SET NULL;

CREATE INDEX idx_claim_id ON fact_claim_copay(claim_id);
CREATE INDEX idx_claim_id_fact_claim_copay ON fact_claim_copay(claim_id);
ALTER TABLE fact_claim_copay
DROP FOREIGN KEY fk_fact_claims;

ALTER TABLE fact_claim_copay
ADD CONSTRAINT fk_fact_claims_new
FOREIGN KEY (claim_id)
REFERENCES fact_claims(claim_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Part 4) Analytics and Reporting
-- Number of Prescriptions Grouped by Drug Name
SELECT 
    d.drug_name, 
    COUNT(f.claim_id) AS number_of_prescriptions
FROM 
    fact_claims f
JOIN 
    dim_drug d ON f.drug_id = d.drug_id
GROUP BY 
    d.drug_name;
    
-- How many prescriptions were filled for the drug Ambien?
SELECT 
    COUNT(f.claim_id) AS number_of_prescriptions
FROM 
    fact_claims f
JOIN 
    dim_drug d ON f.drug_id = d.drug_id
WHERE 
    d.drug_name = 'Ambien';
    
-- Query to Count Total Prescriptions, Count Unique Members, Sum Copay, and Sum Insurance Paid Grouped by Age
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, m.member_birth_date, CURDATE()) >= 65 THEN '65+'
        ELSE '< 65'
    END AS age_group,
    COUNT(f.claim_id) AS total_prescriptions,
    COUNT(DISTINCT f.member_id) AS unique_members,
    SUM(fc.copay_value) AS total_copay,  
    SUM(fc.insurancepaid_value) AS total_insurance_paid 
FROM 
    fact_claims f
JOIN 
    dim_member m ON f.member_id = m.member_id
JOIN
    fact_claim_copay fc ON f.claim_id = fc.claim_id 
GROUP BY 
    age_group;
    
-- Query to Identify the Amount Paid by Insurance for the Most Recent Prescription Fill Date
-- Reference: https://www.w3schools.com/sql/func_mysql_greatest.asp
WITH MostRecentFill AS (
    SELECT 
        f.member_id, 
        m.member_first_name, 
        m.member_last_name, 
        d.drug_name, 
        
        GREATEST(
            fd.fill_date1, 
            fd.fill_date2, 
            fd.fill_date3
        ) AS most_recent_fill_date, 
        
        SUM(fc.insurancepaid_value) AS insurance_paid,  
        ROW_NUMBER() OVER (PARTITION BY f.member_id ORDER BY GREATEST(fd.fill_date1, fd.fill_date2, fd.fill_date3) DESC) AS row_num
    FROM 
        fact_claims f
    JOIN 
        dim_member m ON f.member_id = m.member_id
    JOIN 
        dim_drug d ON f.drug_id = d.drug_id
    LEFT JOIN 
        dim_fill_date fd ON f.fill_date_id = fd.fill_date_id
    
    LEFT JOIN 
        fact_claim_copay fc ON f.claim_id = fc.claim_id
    GROUP BY 
        f.member_id, m.member_first_name, m.member_last_name, d.drug_name, most_recent_fill_date
)
SELECT 
    member_id,
    member_first_name,
    member_last_name,
    drug_name,
    most_recent_fill_date,
    insurance_paid
FROM 
    MostRecentFill
WHERE 
    row_num = 1;