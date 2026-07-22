with source as (
    select * from {{ source('cinema_source', 'customers_raw') }}
),
transform as (
    select
        customer_id, 
        case 
            when lower(gender) in ('m', 'male') then 'Male'
            when lower(gender) in ('f', 'female') then 'Female'
            else 'Unknown'
        end as gender,
        upper(trim(city)) as city,
        cast(load_ts as timestamp) as load_ts
    from source
)
select * from transform