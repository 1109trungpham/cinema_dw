{% snapshot snap_movie %}
{{
    config(
      target_schema=target.schema,
      unique_key='movie_id',
      strategy='timestamp',
      updated_at='load_ts',
    )
}}
select * from {{ ref('stg_movies') }}
{% endsnapshot %}