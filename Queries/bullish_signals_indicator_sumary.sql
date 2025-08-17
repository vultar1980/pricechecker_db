/* Summarise indicator counts */
select bsm.condition_set, ic.indicators, count(bsm.id)
from bullish_signals_monitoring bsm 
inner join indicator_control ic on bsm.condition_set = ic.id
group by bsm.condition_set, ic.indicators
order by bsm.condition_set