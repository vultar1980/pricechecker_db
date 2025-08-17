select * from indicator_control
order by id


insert into indicator_control (id, timeframe, indicators, active_monitoring, max_buy, active_buy, test_buy)
values (10, '4h', 'macd_crossover, cmf >= -0.05', 1, 10, 0, 0)
