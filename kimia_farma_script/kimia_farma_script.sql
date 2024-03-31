/*
Author: Reza Alfarizi
Date: 31/03/2024
Tool: Google BigQuery
*/

/*
---------------------
CREATE ANALYTIC TABLE
---------------------
*/

 SELECT
  ft.transaction_id,
  ft.date,
  ft.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  ft.customer_name,
  ft.product_id,
  p.product_name,
  p.price AS actual_price,
  ft.discount_percentage, 
  CASE
    WHEN p.price <= 50000 THEN 0.10
    WHEN p.price BETWEEN 50000 AND 99999 THEN 0.15
    WHEN p.price BETWEEN 100000 AND 299999 THEN 0.20
    WHEN p.price BETWEEN 300000 AND 499999 THEN 0.25
    ELSE 0.30
  END AS presentase_gross_laba,
  ft.price * (1 - ft.discount_percentage) AS nett_sales,
  (ft.price * (1 - ft.discount_percentage)) *
  CASE
    WHEN p.price <= 50000 THEN 0.10
    WHEN p.price BETWEEN 50000 AND 99999 THEN 0.15
    WHEN p.price BETWEEN 100000 AND 299999 THEN 0.20
    WHEN p.price BETWEEN 300000 AND 499999 THEN 0.25
    ELSE 0.30
  END AS nett_profit,
  ft.rating as rating_transaksi
FROM `kimia_farma.kf_final_transaction` AS ft
  LEFT JOIN `kimia_farma.kf_kantor_cabang` AS kc
    ON ft.branch_id = kc.branch_id
  LEFT JOIN `kimia_farma.kf_product` AS p
    ON ft.product_id = p.product_id;
