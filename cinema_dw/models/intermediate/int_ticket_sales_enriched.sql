with tickets as (
    select * from {{ ref('stg_ticket_sales') }}
),

customers_snap as (
    select * from {{ ref('snap_customer') }}
),

movies_snap as (
    select * from {{ ref('snap_movie') }}
),

-- 1. Ghép vé với Customer Snapshot theo cơ chế Point-in-Time (SCD Type 2)
enrich_customer as (
    select
        t.ticket_id,
        t.customer_id as original_customer_id,
        t.movie_id,
        t.quantity,
        t.price_per_ticket,
        t.revenue,
        t.payment_method,
        t.sale_ts,
        t.load_ts,
        -- Nếu tìm thấy khách hàng khớp thời gian mua vé -> lấy dbt_scd_id, ngược lại gán 'UNKNOWN' (Late Arriving)
        coalesce(c.dbt_scd_id, 'UNKNOWN') as customer_scd_key,
        coalesce(c.city, 'UNKNOWN') as customer_city_at_sale
    from tickets t
    left join customers_snap c
        on t.customer_id = c.customer_id
       -- Điều kiện Point-in-Time: Thời điểm bán vé phải nằm trong khoảng hiệu lực của Snapshot
       and t.sale_ts >= c.dbt_valid_from
       and (t.sale_ts < c.dbt_valid_to or c.dbt_valid_to is null)
),

-- 2. Ghép tiếp với Movie Snapshot
enrich_movie as (
    select
        ec.*,
        coalesce(m.dbt_scd_id, 'UNKNOWN') as movie_scd_key,
        coalesce(m.title, 'UNKNOWN Movie') as movie_title,
        coalesce(m.genre, 'UNKNOWN') as movie_genre
    from enrich_customer ec
    left join movies_snap m
        on ec.movie_id = m.movie_id
       and ec.sale_ts >= m.dbt_valid_from
       and (ec.sale_ts < m.dbt_valid_to or m.dbt_valid_to is null)
)

select * from enrich_movie