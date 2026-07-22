with source as (
    select * from {{ source('cinema_source', 'ticket_sales_raw') }}
),
transform as (
    select
        ticket_id,
        customer_id,
        movie_id,
        quantity,
        cast(price_per_ticket as numeric(12,2)) as price_per_ticket,
        cast(revenue as numeric(12,2)) as revenue,
        payment_method,
        cast(sale_ts as timestamp) as sale_ts,
        cast(load_ts as timestamp) as load_ts
    from source
)
select * from transform