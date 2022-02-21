{{ config(materialized='table') }}

with fhv_data as (
    select *, 
        'FHV' as service_type 
    from {{ ref('stg_fhv_tripdata') }}
),

dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)

SELECT fhv_data.*
,z1.borough as pickup_burough
,z1.zone as pickup_zone
,z2.borough as dropoff_burough
,z2.zone as dropoff_zone
FROM fhv_data inner join dim_zones as z1
on fhv_data.pickup_locationid =z1.locationid
inner join dim_zones as z2
on fhv_data.dropoff_locationid =z2.locationid

