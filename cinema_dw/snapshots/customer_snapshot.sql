{% snapshot snap_customer %}
{{
    config(
      target_schema=target.schema,
      unique_key='customer_id',
      strategy='timestamp',
      updated_at='load_ts',
    )
}}
select * from {{ ref('stg_customers') }}
{% endsnapshot %}