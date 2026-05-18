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
-- trigger refined reviewer comment validation 20260517123610
-- trigger simplified summary validation 20260517124044
-- trigger analysis incomplete baseline validation 20260517143336
-- trigger changed-file trust diagnostics validation 20260517145157
-- trigger config error diagnostics happy path validation 20260517150439
-- trigger discovery mode validation 20260517151233
-- trigger repo snapshot validation 20260517180840
-- trigger fixed repo snapshot validation 20260517181645
-- trigger baseline causality validation 20260518081217
