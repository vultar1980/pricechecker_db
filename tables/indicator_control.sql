-- Table: public.indicator_control

-- DROP TABLE IF EXISTS public.indicator_control;

CREATE TABLE IF NOT EXISTS public.indicator_control
(
    id integer NOT NULL DEFAULT nextval('indicator_control_id_seq'::regclass),
    timeframe text COLLATE pg_catalog."default" NOT NULL,
    indicators text COLLATE pg_catalog."default" NOT NULL,
    active_monitoring integer NOT NULL,
    max_buy numeric NOT NULL,
    active_buy integer,
    test_buy integer,
    CONSTRAINT indicator_control_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.indicator_control
    OWNER to postgres;