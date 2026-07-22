with source as (
    select * from {{ source('cinema_source', 'movies_raw') }}
),
transform as (
    select
        movie_id,
        trim(title) as title,  
        upper(genre) as genre,
        coalesce(duration, 0) as duration,
        cast(load_ts as timestamp) as load_ts
    from source
)
select * from transform