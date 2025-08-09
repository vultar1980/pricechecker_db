-- FUNCTION: public.log_trade_on_monitoring_insert()

-- DROP FUNCTION IF EXISTS public.log_trade_on_monitoring_insert();

CREATE OR REPLACE FUNCTION public.log_trade_on_monitoring_insert()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
    v_active_monitoring INTEGER;
    v_test_buy INTEGER;
BEGIN
    -- Check if the condition_set for the newly inserted row is actively monitored.
    -- This ensures that we only log trades for signals that are configured for it.
    SELECT ic.active_monitoring
    INTO v_active_monitoring
    FROM public.indicator_control ic
    WHERE ic.id = NEW.condition_set;

    SELECT ic.test_buy
    INTO v_test_buy
    FROM public.indicator_control ic
    WHERE ic.id = NEW.condition_set;

    -- The trigger should only fire if active_monitoring is 1.
    IF v_active_monitoring = 1 THEN
        -- Check if a trade for this symbol is already open (close_at IS NULL).
        IF EXISTS (SELECT 1 FROM public.trades WHERE symbol = NEW.symbol AND close_at IS NULL) THEN
            -- If it exists, just update the last_update timestamp of the existing open trade.
            UPDATE public.trades
            SET last_update = NOW()
            WHERE symbol = NEW.symbol AND close_at IS NULL;
        ELSE
            -- If no open trade exists for the symbol, insert a new record.
            INSERT INTO public.trades (
                id,
                symbol,
                timeframe,
                inserted_at,
                test_buy,
                last_update
            ) VALUES (
                NEW.id,
                NEW.symbol,
                NEW.timeframe,
                NOW(), -- Use the current timestamp for when the log entry is created.
                v_test_buy,
                NOW()
            );
        END IF;
    END IF;

    -- Return the new row to complete the trigger action.
    RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.log_trade_on_monitoring_insert()
    OWNER TO postgres;
