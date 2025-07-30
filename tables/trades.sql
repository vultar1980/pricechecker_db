DROP TABLE IF EXISTS public.trades;

CREATE TABLE IF NOT EXISTS public.trades
(
    id integer NOT NULL,
    symbol text COLLATE pg_catalog."default",
    timeframe text COLLATE pg_catalog."default",
    inserted_at timestamp without time zone,
	buy_at timestamp without time zone,
	close_at timestamp without time zone,
	test_buy bool,
    buy_price numeric,
	buy_quantity numeric,
	buy_total numeric,
    sell_rule integer,
	sell_price numeric,
	sell_quanity numeric,
	sell_total numeric,
	active bool
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.trades
    OWNER to postgres;