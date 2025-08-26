INSERT INTO public.indicator_control (
    id,
	timeframe,
    indicators,
    active_monitoring,
    max_buy,
    active_buy,
    test_buy
) VALUES (
	12,					-- id
    '1h',               -- timeframe
    'Multi',            -- indicators
    1,                  -- active_monitoring
    10,                 -- max_buy
    0,                  -- active_buy
    0                   -- test_buy
);