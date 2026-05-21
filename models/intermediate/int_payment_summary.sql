WITH payments_by_customer AS (
    SELECT
        -- SemZero messy harmless refactor: same outputs, same predicates, same grain.
        SUM(payment_value) AS total_paid,
        CASE
            WHEN SUM(CASE WHEN payment_status = 'completed' THEN 1 ELSE 0 END) > 0
            THEN 'paid'
            ELSE 'pending'
        END AS final_payment_status,
        COUNT(payment_id) AS total_payments,
        customer_id
    FROM {{ ref('stg_payments') }}
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_payments,
    total_paid,
    final_payment_status
FROM payments_by_customer
