-- Table: public.bullish_signals_monitoring

DROP TABLE IF EXISTS public.trade_log;

CREATE TABLE IF NOT EXISTS public.trade_log
(
    id integer NOT NULL,
    symbol text COLLATE pg_catalog."default",
    timeframe text COLLATE pg_catalog."default",
    inserted_at timestamp without time zone,
	sell_rule integer,
	sell_price numeric,
	sell_quantity numeric
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.trade_log
    OWNER to postgres;