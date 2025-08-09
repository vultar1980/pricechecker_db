-- Table: public.bullish_signals

-- DROP TABLE IF EXISTS public.bullish_signals;

CREATE TABLE IF NOT EXISTS public.bullish_signals
(
    id integer NOT NULL DEFAULT nextval('bullish_signals_id_seq'::regclass),
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
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    bull_flag boolean DEFAULT false,
    break_above_r1 boolean,
    bb_squeeze_breakout boolean,
    support_price numeric,
    approaching_golden_cross boolean,
    CONSTRAINT bullish_signals_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.bullish_signals
    OWNER to postgres;
-- Index: ix_bullish_signals_alert_triggered_at

-- DROP INDEX IF EXISTS public.ix_bullish_signals_alert_triggered_at;

CREATE INDEX IF NOT EXISTS ix_bullish_signals_alert_triggered_at
    ON public.bullish_signals USING btree
    (alert_triggered_at ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: ix_bullish_signals_symbol

-- DROP INDEX IF EXISTS public.ix_bullish_signals_symbol;

CREATE INDEX IF NOT EXISTS ix_bullish_signals_symbol
    ON public.bullish_signals USING btree
    (symbol COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: insert_bullish_signals_monitoring

-- DROP TRIGGER IF EXISTS insert_bullish_signals_monitoring ON public.bullish_signals;

CREATE OR REPLACE TRIGGER insert_bullish_signals_monitoring
    AFTER INSERT
    ON public.bullish_signals
    FOR EACH ROW
    EXECUTE FUNCTION public.check_bullish_signal_conditions();