-- Table: public.price_log

-- DROP TABLE IF EXISTS public.price_log;

CREATE TABLE IF NOT EXISTS public.price_log
(
    id integer NOT NULL DEFAULT nextval('price_log_id_seq'::regclass),
    symbol character varying(20) COLLATE pg_catalog."default" NOT NULL,
    inserted_at timestamp with time zone NOT NULL DEFAULT now(),
    current_price numeric NOT NULL,
    trade_id integer,
    CONSTRAINT price_log_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.price_log
    OWNER to postgres;
-- Index: idx_price_log_symbol_inserted_at

-- DROP INDEX IF EXISTS public.idx_price_log_symbol_inserted_at;

CREATE INDEX IF NOT EXISTS idx_price_log_symbol_inserted_at
    ON public.price_log USING btree
    (symbol COLLATE pg_catalog."default" ASC NULLS LAST, inserted_at DESC NULLS FIRST)
    TABLESPACE pg_default;
-- Index: idx_price_log_trade_id

-- DROP INDEX IF EXISTS public.idx_price_log_trade_id;

CREATE INDEX IF NOT EXISTS idx_price_log_trade_id
    ON public.price_log USING btree
    (trade_id ASC NULLS LAST)
    TABLESPACE pg_default;