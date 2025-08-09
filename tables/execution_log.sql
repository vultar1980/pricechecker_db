-- Table: public.execution_log

-- DROP TABLE IF EXISTS public.execution_log;

CREATE TABLE IF NOT EXISTS public.execution_log
(
    id integer NOT NULL DEFAULT nextval('execution_log_id_seq'::regclass),
    timeframe character varying(5) COLLATE pg_catalog."default",
    scan_count integer,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    CONSTRAINT execution_log_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.execution_log
    OWNER to postgres;