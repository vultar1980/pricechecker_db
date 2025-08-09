-- Table: public.trades

-- DROP TABLE IF EXISTS public.trades;

CREATE TABLE IF NOT EXISTS public.trades
(
    id integer NOT NULL,
    symbol text COLLATE pg_catalog."default",
    timeframe text COLLATE pg_catalog."default",
    inserted_at timestamp without time zone,
    buy_at timestamp without time zone,
    close_at timestamp without time zone,
    test_buy integer,
    buy_price numeric,
    buy_quantity numeric,
    sell_rule integer,
    sell_price numeric,
    sell_quanity numeric,
    sell_total numeric,
    last_update timestamp without time zone
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.trades
    OWNER to postgres;