DROP TABLE IF EXISTS tmp_price_summary;

CREATE TEMP TABLE tmp_price_summary AS
WITH s AS (
  SELECT id, symbol, timeframe, condition_set, rsi, alert_triggered_at
  FROM public.bullish_signals
  where alert_triggered_at >= NOW() - interval '24 hours'),
fp AS (
  -- First price at/after the signal = buy_time / buy_price
  SELECT
    s.id,
    s.symbol,
    s.timeframe,
    s.condition_set,
    s.rsi,
    s.alert_triggered_at,
    pc.inserted_at   AS buy_time,
    pc.current_price AS buy_price
  FROM s
  JOIN LATERAL (
    SELECT inserted_at, current_price
    FROM public.price_checker
    WHERE symbol = s.symbol
      AND inserted_at >= s.alert_triggered_at
    ORDER BY inserted_at
    LIMIT 1
  ) pc ON TRUE
),
w AS (
  -- All prices in the 24h window after buy_time
  SELECT fp.id, fp.symbol, fp.buy_time, pc.inserted_at, pc.current_price
  FROM fp
  JOIN public.price_checker pc
    ON pc.symbol = fp.symbol
   AND pc.inserted_at >= fp.buy_time
   AND pc.inserted_at <  fp.buy_time + interval '24 hours'
),
max_row AS (
  -- First time the max price is hit (handles ties deterministically)
  SELECT DISTINCT ON (w.id)
         w.id,
         w.inserted_at AS max_time,
         w.current_price AS max_price
  FROM w
  ORDER BY w.id, w.current_price DESC, w.inserted_at ASC
),
min_between AS (
  -- Min price between buy_time and max_time (inclusive)
  SELECT w.id,
         MIN(w.current_price) AS min_price
  FROM w
  JOIN max_row mx ON mx.id = w.id
  WHERE w.inserted_at >= w.buy_time
    AND w.inserted_at <= mx.max_time
  GROUP BY w.id
),
last_in_window AS (
  -- Last tick inside the 24h window
  SELECT id, MAX(inserted_at) AS last_time
  FROM w
  GROUP BY id
),
price_at_last AS (
  -- Price at the end of the 24h window
  SELECT l.id, w.current_price AS price_at_24h
  FROM last_in_window l
  JOIN w ON w.id = l.id AND w.inserted_at = l.last_time
)
SELECT
  fp.id,                  -- join key back to bullish_signals
  fp.symbol,
  fp.timeframe,
  fp.condition_set,
  fp.rsi,
  fp.buy_time     AS inserted_time,
  fp.buy_price,
  mb.min_price,
  mx.max_price,
  ROUND(((mx.max_price - fp.buy_price) / NULLIF(fp.buy_price, 0)) * 100, 2) AS pct_increase_to_max,
  ROUND(((mb.min_price - fp.buy_price) / NULLIF(fp.buy_price, 0)) * 100, 2) AS pct_drawdown_to_min,
  pal.price_at_24h,
  ROUND(((pal.price_at_24h - fp.buy_price) / NULLIF(fp.buy_price, 0)) * 100, 2) AS pct_change_after_24h,
  ROUND(EXTRACT(EPOCH FROM (mx.max_time - fp.buy_time)) / 3600.0, 4) AS hours_to_max
FROM fp
JOIN max_row mx      ON mx.id  = fp.id
JOIN min_between mb  ON mb.id  = fp.id
JOIN price_at_last pal ON pal.id = fp.id
ORDER BY pct_increase_to_max DESC;

SELECT t.*, b.*
FROM public.bullish_signals b
JOIN tmp_price_summary t ON b.id = t.id
WHERE b.timeframe = '1h'
ORDER BY t.pct_increase_to_max DESC;
