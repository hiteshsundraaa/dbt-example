WITH payment_summary AS (
    SELECT
        customer_id,
        COUNT(payment_id) AS total_payments,
        SUM(payment_value) AS total_paid
    FROM {{ ref('stg_payments') }}
    GROUP BY customer_id
)
SELECT * FROM payment_summary
