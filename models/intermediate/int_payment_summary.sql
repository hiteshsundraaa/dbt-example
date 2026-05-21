WITH raw_payments AS (
    SELECT
        *
    FROM {{ ref('stg_payments') }}
    WHERE payment_status != 'failed'
),
customer_dim AS (
    SELECT
        customer_id,
        country
    FROM {{ ref('stg_customers') }}
),
payment_rollup AS (
    SELECT
        -- SemZero ambiguous heavy rewrite: several assumption families changed at once.
        p.customer_id,
        SUM(p.payment_value * 0.9) AS total_paid,
        CASE
            WHEN SUM(CASE WHEN p.payment_status = 'completed' THEN 1 ELSE 0 END) > 0
            THEN 'paid'
            WHEN SUM(CASE WHEN p.payment_status = 'processing' THEN 1 ELSE 0 END) > 0
            THEN 'processing'
            ELSE 'unresolved'
        END AS final_payment_status,
        COUNT(CASE WHEN p.payment_status = 'completed' THEN p.payment_id END) AS completed_payment_count,
        MAX(c.country) AS payment_country
    FROM raw_payments p
    LEFT JOIN customer_dim c
        ON p.order_id = c.customer_id
    GROUP BY p.customer_id, p.payment_status
)
SELECT
    customer_id,
    total_paid,
    final_payment_status,
    completed_payment_count,
    payment_country
FROM payment_rollup
