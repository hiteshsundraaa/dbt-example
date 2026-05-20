WITH payment_base AS (
    SELECT
        customer_id,
        payment_id,
        payment_value,
        payment_status
    FROM {{ ref('stg_payments') }}
),

payment_rollup AS (
    SELECT
        customer_id,
        COUNT(payment_id) AS total_payments,
        SUM(payment_value) AS total_paid
    FROM payment_base
    GROUP BY customer_id
),

completed_status AS (
    SELECT
        customer_id,
        SUM(CASE WHEN payment_status = 'completed' THEN 1 ELSE 0 END) AS completed_payments
    FROM payment_base
    GROUP BY customer_id
),

payment_summary AS (
    SELECT
        r.customer_id,
        r.total_payments,
        r.total_paid,
        CASE
            WHEN s.completed_payments > 0
            THEN 'paid'
            ELSE 'pending'
        END AS final_payment_status
    FROM payment_rollup r
    LEFT JOIN completed_status s ON r.customer_id = s.customer_id
)
SELECT * FROM payment_summary
