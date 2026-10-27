with add_tab as (
    select channel, count(*) as total_send
    from campaign_sends
    where campaign_id = 'SUMMER2025'
    group by channel
)
select
    c.channel,                                            
    count(e.id) as conversions,                           
    coalesce(at.total_send, 0) as total_sends,
    to_char(
        coalesce(
            count(e.id)::numeric * 100 / nullif(at.total_send, 0), 0),
        'FM9999999990.00') as cr_pct,
    to_char(
        coalesce(
            count(e.id)::numeric * 100
            / nullif(sum(count(e.id)) over (), 0), 0),
        'FM9999999990.00') as share_of_convs
from (select unnest(array['email','push','sms']) as channel) c
left join add_tab at on at.channel = c.channel
left join (
    select user_id, channel from (
        select user_id, channel,
               row_number() over (partition by user_id, campaign_id
                                  order by event_time, channel) as rn
        from engagement_events
        where campaign_id = 'SUMMER2025'
    ) x where rn = 1
) ft on ft.channel = c.channel
left join engagement_events e
       on e.user_id = ft.user_id
      and e.campaign_id = 'SUMMER2025'
      and e.event_type = 'converted'
group by c.channel, at.total_send
order by conversions desc, total_sends desc, c.channel asc;