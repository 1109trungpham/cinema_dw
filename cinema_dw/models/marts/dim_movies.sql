with snap as (
    select * from {{ ref('snap_movie') }}
),

final as (
    select
        dbt_scd_id as movie_key,
        movie_id,
        title,
        genre,
        duration,
        dbt_valid_from as valid_from,
        dbt_valid_to as valid_to,
        case when dbt_valid_to is null then true else false end as is_current
    from snap
)

select * from final

union all

-- Inferred Member cho Phim
select
    'UNKNOWN' as movie_key,
    'UNKNOWN' as movie_id,
    'Unknown Movie' as title,
    'Unknown' as genre,
    0 as duration,
    '1970-01-01 00:00:00'::timestamp as valid_from,
    null::timestamp as valid_to,
    true as is_current