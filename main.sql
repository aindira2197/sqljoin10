WITH cohort AS (
    SELECT 
        id AS user_id,
        DATE_TRUNC('month', signup_date) AS cohort_month
    FROM users
),

activity AS (
    SELECT 
        c.cohort_month,
        DATE_TRUNC('month', s.start_date) AS active_month,
        s.user_id,
        s.price
    FROM subscriptions s
    JOIN cohort c ON s.user_id = c.user_id
),

cohort_stats AS (
    SELECT 
        cohort_month,
        active_month,
        COUNT(DISTINCT user_id) AS active_users,
        SUM(price) AS revenue
    FROM activity
    GROUP BY cohort_month, active_month
)

SELECT 
    cohort_month,
    active_month,
    active_users,
    revenue,
    ROUND(revenue * 1.0 / active_users, 2) AS ltv
FROM cohort_stats;
