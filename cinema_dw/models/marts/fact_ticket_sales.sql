with int_tickets as (
    select * from {{ ref('int_ticket_sales_enriched') }}
),

final as (
    select
        ticket_id,
        -- Khóa ngoại trỏ tới Dimension Tables (dùng Surrogate Key từ Snapshot/Intermediate)
        customer_scd_key as customer_key,
        movie_scd_key as movie_key,
        
        -- Dữ liệu thời gian
        sale_ts,
        cast(sale_ts as date) as sale_date,
        
        -- Thuộc tính giao dịch
        payment_method,
        
        -- Measures (Các con số có thể tính toán)
        quantity,
        price_per_ticket,
        revenue
    from int_tickets
)

select * from final