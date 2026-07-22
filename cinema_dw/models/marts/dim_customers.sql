with snap as (
    select * from {{ ref('snap_customer') }}
),

final as (
    select
        dbt_scd_id as customer_key, -- Surrogate Key đại diện cho từng phiên bản khách hàng
        customer_id,
        gender,
        city,
        dbt_valid_from as valid_from,
        dbt_valid_to as valid_to,
        case when dbt_valid_to is null then true else false end as is_current
    from snap
)

select * from final

union all

-- Thêm một bản ghi giả (Inferred Member) để map với các vé chưa có thông tin khách (Late Arriving)
select
    'UNKNOWN' as customer_key,
    'UNKNOWN' as customer_id,
    'Unknown' as gender,
    'Unknown' as city,
    '1970-01-01 00:00:00'::timestamp as valid_from,
    null::timestamp as valid_to,
    true as is_current