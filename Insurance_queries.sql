use insurance;
##Q1.No of Invoice by Account Exec;
Select * from invoice;
desc invoice;
ALTER TABLE invoice 
CHANGE COLUMN `Account Executive` Account_Executive VARCHAR(255);
select Account_Executive,count(*) as no_of_invoice from invoice group by 1 order by 2 desc;

##Q2.Yearly Meeting Count:
Select * from meeting;
desc meeting;
ALTER TABLE meeting 
CHANGE COLUMN `Account Exe ID` Account_ExeId int(100);
ALTER TABLE meeting
MODIFY COLUMN meeting_date DATE;
UPDATE meeting 
SET meeting_date = STR_TO_DATE(meeting_date, '%d-%m-%Y');
SELECT YEAR(meeting_date) AS meeting_year, COUNT(*) AS meeting_count
FROM meeting
WHERE meeting_date IS NOT NULL  -- Exclude NULL values
GROUP BY YEAR(meeting_date)
ORDER BY meeting_year DESC;

##Q3.Stage by revenue;
select * from opportunity;
select stage,sum(revenue_amount) as Total_revenue from opportunity group by stage order by Total_revenue desc;

##Q4.No of meeting by Account Executive;
select * from meeting;
ALTER TABLE meeting 
CHANGE COLUMN `Account Executive` Account_Executive VARCHAR(255);
select Account_Executive,count(*) as no_of_meeting from meeting group by 1 order by 2 desc;

##Q5.Top 4 opportunity;
select * from opportunity;
select opportunity_name,sum(revenue_amount) as Total_rev from opportunity where stage in ('propose solution','Qualify opportunity') group by 1 order by Total_rev desc limit 4;

##Q6.cross sell(Target,Achieved,invoice)
ALTER TABLE brokerage 
CHANGE COLUMN `Account Exe ID` Account_ExeId int(100);
ALTER TABLE fees
CHANGE COLUMN `Account Exe ID` Account_ExeId int(100);
ALTER TABLE individual_budgets
CHANGE COLUMN `Account Exe ID` Account_ExeId int(100);
ALTER TABLE individual_budgets 
CHANGE COLUMN `Cross sell bugdet` Cross_sell_budget int(100);
ALTER TABLE individual_budgets 
CHANGE COLUMN `Employee Name` Employee_name varchar(255);
SELECT 
    ib.Employee_name,  
    ib.cross_sell_budget as Target,  
    COALESCE (SUM(b.amount) + SUM(f.amount), 0) as Achieved,  
    COALESCE(SUM(inv.amount), 0) as Invoice  
    FROM Individual_Budgets ib  
LEFT JOIN Brokerage b ON ib.Account_ExeId = b.Account_ExeId AND b.income_class = 'Cross Sell'  
LEFT JOIN Fees f ON ib.Account_ExeId = f.Account_ExeId AND f.income_class = 'Cross Sell'  
LEFT JOIN Invoice inv ON ib.Account_ExeId = inv.Account_ExeId AND inv.income_class = 'Cross Sell'  
GROUP BY ib.employee_name, ib.cross_sell_budget  
ORDER BY ib.employee_name;

##Q6.New(Target,Achieved,invoice)
ALTER TABLE individual_budgets 
CHANGE COLUMN `New budget` New_budget int(100);
SELECT 
    ib.Employee_name,  
    ib.new_budget as Target,  
    COALESCE(SUM(b.amount) + SUM(f.amount), 0) as Achieved,  
    COALESCE(SUM(inv.amount), 0) as Invoice  
FROM Individual_Budgets ib  
LEFT JOIN Brokerage b ON ib.Account_ExeId = b.Account_ExeId AND b.income_class = 'New'  
LEFT JOIN Fees f ON ib.Account_ExeId = f.Account_ExeId AND f.income_class = 'New'  
LEFT JOIN Invoice inv ON ib.Account_ExeId = inv.Account_ExeId AND inv.income_class = 'New'  
GROUP BY ib.employee_name, ib.new_budget  
ORDER BY ib.employee_name;

##Q6.Renewal(Target,Achieved,invoice)
ALTER TABLE individual_budgets 
CHANGE COLUMN `Renewal budget` Renewal_budget int(100);
SELECT 
    ib.Employee_name,  
    ib.renewal_budget as Target,  
    COALESCE(SUM(b.amount) + SUM(f.amount), 0) as Achieved,  
    COALESCE(SUM(inv.amount), 0) as Invoice  
FROM Individual_Budgets ib  
LEFT JOIN Brokerage b ON ib.Account_ExeId = b.Account_ExeId AND b.income_class = 'Renewal'  
LEFT JOIN Fees f ON ib.Account_ExeId = f.Account_ExeId AND f.income_class = 'Renewal'  
LEFT JOIN Invoice inv ON ib.Account_ExeId = inv.Account_ExeId AND inv.income_class = 'Renewal'  
GROUP BY ib.employee_name, ib.renewal_budget  
ORDER BY ib.employee_name;

