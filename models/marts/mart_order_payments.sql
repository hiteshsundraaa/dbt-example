WITH orders_with_payments AS (
    SELECT
        o.customer_id,
        o.order_status,
        o.total_revenue,
        o.first_order_date,
        o.last_order_date,
        p.total_paid,
        p.final_payment_status
    FROM
        {{ ref('int_order_summary') }} AS o
    -- SemZero messy join-key smoke: formatting plus compile-safe wrong key.
    LEFT JOIN
        {{ ref('int_payment_summary') }} AS p
        ON o.order_status = p.final_payment_status
)
SELECT
    customer_id,
    order_status,
    total_revenue,
    first_order_date,
    last_order_date,
    total_paid,
    final_payment_status
FROM orders_with_payments
