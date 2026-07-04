SELECT 
    COUNT(telco.customerID) AS Totalcustomer,
    SUM(CASE WHEN telco.churn="Yes" THEN 1 ELSE 0 END) AS churned_customers,
    ROUND((SUM(CASE WHEN telco.churn="Yes" THEN 1 ELSE 0 END) / COUNT(telco.customerID)) * 100.0, 2) AS churned_percentage
FROM telco.telco;

SELECT 
     COUNT(telco.customerID) AS Totalcustomer,
     telco.Contract,
     SUM(CASE WHEN churn="Yes" THEN 1 ELSE 0 END ) AS churned_customers,
     ROUND((SUM(CASE WHEN churn="Yes" Then 1 ELSE 0 END ) / COUNT(telco.customerID)) * 100.0, 2) AS churn_rate_pct
FROM telco.telco
GROUP BY  telco.Contract ;


SELECT telco.InternetService ,
      ROUND(AVG(telco.MonthlyCharges),2)  AS avg_monthly_charges,
      SUM(CASE WHEN churn="Yes" THEN 1 ELSE 0 END ) AS churned_customers,
	  ROUND((SUM(CASE WHEN churn="Yes" Then 1 ELSE 0 END ) / COUNT(telco.customerID)) * 100.0, 2) AS churn_rate
FROM telco.telco
GROUP BY telco.InternetService;

SELECT telco.PaymentMethod,
       SUM(CASE WHEN churn="Yes" THEN 1 ELSE 0 END) AS churned_customers,
       ROUND((SUM(CASE WHEN churn="Yes" THEN 1 ELSE 0 END) / COUNT(telco.customerID)) * 100.0, 2) AS churn_rate
FROM telco.telco
GROUP BY telco.PaymentMethod;

SELECT telco.customerID, telco.MonthlyCharges,
      NTILE(4) OVER (ORDER BY telco.MonthlyCharges DESC ) AS spend_quartile
FROM telco.telco;

WITH customer_quartiles AS (
      SELECT telco.customerID, telco.MonthlyCharges,telco.churn,
            NTILE(4) OVER (ORDER BY telco.MonthlyCharges DESC ) AS spend_quartile
	  FROM telco.telco
)
SELECT spend_quartile,
COUNT(*) AS total_customerID,
SUM(CASE WHEN churn="Yes" THEN 1 ELSE 0 END ) AS churned_customers
FROM customer_quartiles
GROUP BY spend_quartile;

SELECT customerID, Contract, tenure,
  RANK() OVER(PARTITION BY Contract ORDER BY tenure DESC)  AS tenure_rank
FROM telco.telco;

SELECT customerID,InternetService,MonthlyCharges,
      AVG(MonthlyCharges) OVER(PARTITION BY InternetService ) AS group_avg ,
      CASE 
           WHEN MonthlyCharges > AVG(MonthlyCharges) OVER(PARTITION BY InternetService ) THEN 'Above_Average'
           ELSE 'Bad_Average'
      END spend_comparison
FROM telco.telco;

WITH Categories_based AS ( 
          SELECT customerID, tenure, Churn,
             CASE 
                  WHEN tenure BETWEEN 0 AND 12 THEN "New"
                  WHEN tenure BETWEEN 13 AND 36 THEN "Established"
				   ELSE "Loyal" 
END AS Tenure_case
FROM telco.telco
)
 SELECT Tenure_case,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned_customers,
	 ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM Categories_based
GROUP BY Tenure_case;

WITH customer_quartiles AS (
      SELECT telco.customerID, telco.MonthlyCharges,telco.churn,  tenure,
            NTILE(4) OVER (ORDER BY telco.MonthlyCharges DESC ) AS spend_quartile
	  FROM telco.telco
),
average_tenure AS (
        SELECT spend_quartile,
		COUNT(*) AS total_customers,
		AVG(tenure) AS avg_tenure,
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned_customers,
	    ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customer_quartiles 
GROUP BY spend_quartile 
)
SELECT * 
FROM  average_tenure;

WITH customer_risk AS(
SELECT customerID,
       tenure,
       MonthlyCharges,
       Contract,
       churn,
     CASE 
          WHEN Contract = 'Month-to-month'  AND MonthlyCharges > 70 AND tenure < 12 THEN 'High_Risk'
          WHEN Contract = 'Month-to-month'  AND MonthlyCharges > 70 THEN 'Medium_Risk'
          ELSE 'Low_Risk'
END AS risk_level
FROM telco.telco
)
SELECT
           risk_level ,
          COUNT(*) AS total_customers,
          SUM(CASE WHEN churn ='Yes' THEN 1 ELSE 0 END ) AS churned_customers,
          ROUND(SUM(CASE WHEN churn ='Yes' THEN 1 ELSE 0 END ) *100.0/ COUNT(*),2) AS churn_rate 
 FROM customer_risk
 GROUP BY  risk_level
 ORDER BY churn_rate DESC 
 ;

SELECT Contract,
COUNT(*) AS total_customers,
ROUND(AVG(tenure),2) AS average_tenure,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END ) AS churned_customers,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) *100.0/COUNT(*), 2 ) AS churn_rate
FROM telco.telco
GROUP BY Contract
ORDER BY churn_rate DESC;