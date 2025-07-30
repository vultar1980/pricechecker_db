CREATE TABLE IF NOT EXISTS bullish_signals (
id SERIAL PRIMARY KEY,
symbol TEXT,
timeframe TEXT,
current_price NUMERIC,
score NUMERIC, -- Changed to NUMERIC to allow decimal scores
rsi NUMERIC,
atr NUMERIC,
macd_histogram NUMERIC,
golden_cross BOOLEAN,
bullish_engulfing BOOLEAN,
hammer BOOLEAN,
close_to_support BOOLEAN,
morning_star BOOLEAN,
three_white_soldiers BOOLEAN,
doji BOOLEAN,
increasing_volume BOOLEAN,
volume_spike BOOLEAN,           -- Added Volume Spike
macd_crossover BOOLEAN,         -- Added MACD Crossover
price_above_ma50 BOOLEAN,
price_above_ma200 BOOLEAN,
rsi_bullish_divergence BOOLEAN,
falling_wedge_breakout BOOLEAN, -- Added Falling Wedge Breakout
bull_flag BOOLEAN,
bb_squeeze_breakout BOOLEAN,
break_above_r1 BOOLEAN,
support_price NUMERIC,
alert_triggered_at TIMESTAMP,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)