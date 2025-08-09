-- Table: public.bullish_signals_monitoring

-- DROP TABLE IF EXISTS public.bullish_signals_monitoring;

CREATE TABLE IF NOT EXISTS public.bullish_signals_monitoring
(
    id integer NOT NULL,
    symbol text COLLATE pg_catalog."default",
    timeframe text COLLATE pg_catalog."default",
    current_price numeric,
    score numeric,
    rsi numeric,
    atr numeric,
    macd_histogram numeric,
    golden_cross boolean,
    bullish_engulfing boolean,
    hammer boolean,
    close_to_support boolean,
    morning_star boolean,
    three_white_soldiers boolean,
    doji boolean,
    increasing_volume boolean,
    volume_spike boolean,
    macd_crossover boolean,
    price_above_ma50 boolean,
    price_above_ma200 boolean,
    rsi_bullish_divergence boolean,
    falling_wedge_breakout boolean,
    alert_triggered_at timestamp without time zone,
    created_at timestamp without time zone,
    condition_set integer,
    notification integer DEFAULT 0,
    bull_flag boolean DEFAULT false,
    break_above_r1 boolean,
    bb_squeeze_breakout boolean,
    support_price numeric(20,10)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.bullish_signals_monitoring
    OWNER to postgres;

-- Trigger: trg_log_trade_on_monitoring_insert

-- DROP TRIGGER IF EXISTS trg_log_trade_on_monitoring_insert ON public.bullish_signals_monitoring;

CREATE OR REPLACE TRIGGER trg_log_trade_on_monitoring_insert
    AFTER INSERT
    ON public.bullish_signals_monitoring
    FOR EACH ROW
    EXECUTE FUNCTION public.log_trade_on_monitoring_insert();