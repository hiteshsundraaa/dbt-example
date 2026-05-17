WITH payment_summary AS (
    SELECT
        customer_id,
        COUNT(payment_id) AS total_payments,
        SUM(payment_value) AS total_paid,
        CASE 
            WHEN SUM(CASE WHEN payment_status = 'completed' THEN 1 ELSE 0 END) > 0 
            THEN 'paid'
            ELSE 'unresolved'
        END AS final_payment_status
    FROM {{ ref('stg_payments') }}
    GROUP BY customer_id
)
SELECT * FROM payment_summary
-- trigger evidence-adjusted priority scoring 20260517115635
-- trigger reviewer comment cleanup validation 20260517123010
