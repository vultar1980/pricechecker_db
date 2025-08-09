-- FUNCTION: public.check_bullish_signal_conditions()

-- DROP FUNCTION IF EXISTS public.check_bullish_signal_conditions();

CREATE OR REPLACE FUNCTION public.check_bullish_signal_conditions()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
    v_condition_set INTEGER; -- Declare a variable to hold the condition set number
    v_count INTEGER;
    v_has_1h BOOLEAN;
    v_has_4h BOOLEAN;

BEGIN
    v_condition_set := NULL; -- Initialize the variable to NULL

       -- 15m Conditions
   -- Set 301
    IF (NEW.doji IS TRUE AND
        NEW.increasing_volume IS TRUE AND
        NEW.price_above_ma50 IS TRUE AND
        NEW.price_above_ma200 IS TRUE AND
	 NEW.timeframe = '15m') THEN
        v_condition_set := 301;
   	-- Set 303
    ELSEIF (NEW.macd_crossover IS TRUE AND
        NEW.increasing_volume IS TRUE AND
        NEW.price_above_ma50 IS TRUE AND
        NEW.price_above_ma200 IS TRUE AND
		NEW.approaching_golden_cross IS TRUE AND
	 NEW.timeframe = '15m') THEN
        v_condition_set := 303;
    -- Set 302
    ELSEIF (NEW.macd_crossover IS TRUE AND
        NEW.increasing_volume IS TRUE AND
        NEW.price_above_ma50 IS TRUE AND
        NEW.price_above_ma200 IS TRUE AND
		NEW.bull_flag IS TRUE AND
	 NEW.timeframe = '15m') THEN
        v_condition_set := 302;
	-- Set 304
    ELSEIF (NEW.close_to_support IS TRUE AND
        NEW.increasing_volume IS TRUE AND
		NEW.volume_spike IS TRUE AND
        NEW.price_above_ma50 IS TRUE AND
        NEW.price_above_ma200 IS TRUE AND
		NEW.macd_crossover IS TRUE AND
	 NEW.timeframe = '15m') THEN
        v_condition_set := 304;
	-- Set 305
    ELSEIF (NEW.close_to_support IS TRUE AND
        NEW.increasing_volume IS TRUE AND
		NEW.bb_squeeze_breakout IS TRUE AND
        NEW.price_above_ma50 IS TRUE AND
	NEW.timeframe = '15m') THEN
        v_condition_set := 305;

	-- 1hr Conditions
    -- Set 1
    ELSEIF (NEW.macd_crossover IS TRUE AND
        NEW.increasing_volume IS TRUE AND
        NEW.bullish_engulfing IS TRUE AND
		NEW.timeframe = '1h') THEN
        v_condition_set := 1;
    -- Set 2
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.morning_star IS TRUE AND
		   NEW.timeframe = '1h') THEN
           v_condition_set := 2;
    -- Set 3
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.falling_wedge_breakout IS TRUE AND
		   NEW.timeframe = '1h') THEN
           v_condition_set := 3;
    -- Set 4
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
		   NEW.timeframe = '1h') THEN
           v_condition_set := 4;
    -- Set 5
    ELSIF (NEW.close_to_support IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
           NEW.bb_squeeze_breakout IS TRUE AND
		   NEW.timeframe = '1h') THEN
           v_condition_set := 5;
    -- Set 6
    ELSIF (NEW.hammer IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.close_to_support IS TRUE AND
  		   NEW.timeframe = '1h') THEN
           v_condition_set := 6;
    -- Set 7
    ELSIF (NEW.close_to_support IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.macd_crossover IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
           NEW.bb_squeeze_breakout IS TRUE AND
	    NEW.timeframe = '1h') THEN
           v_condition_set := 7;
 -- Set 8
    ELSIF (NEW.bullish_engulfing IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.bull_flag IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
	    NEW.timeframe = '1h') THEN
           v_condition_set := 8;
 -- Set 9
    ELSIF (NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
           NEW.bb_squeeze_breakout IS TRUE AND
	    NEW.timeframe = '1h') THEN
           v_condition_set := 9;
 -- Set 10
    ELSIF (NEW.golden_cross IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
	    NEW.timeframe = '1h') THEN
           v_condition_set := 10;
 -- Set 11
    ELSIF (NEW.doji IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.close_to_support IS TRUE AND
	    NEW.timeframe = '1h') THEN
           v_condition_set := 11;
 -- Set 12
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.rsi_bullish_divergence IS TRUE AND
	    NEW.timeframe = '1h') THEN
           v_condition_set := 12;

    -- 4h Conditions
    -- Set 1
    ELSEIF (NEW.macd_crossover IS TRUE AND
        NEW.increasing_volume IS TRUE AND
        NEW.bullish_engulfing IS TRUE AND
		NEW.timeframe = '4h') THEN
        v_condition_set := 101;
    -- Set 2
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.morning_star IS TRUE AND
		   NEW.timeframe = '4h') THEN
           v_condition_set := 102;
    -- Set 3
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.falling_wedge_breakout IS TRUE AND
		   NEW.timeframe = '4h') THEN
           v_condition_set := 103;
    -- Set 4
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
		   NEW.timeframe = '4h') THEN
           v_condition_set := 104;
  -- Set 5
    ELSIF (NEW.close_to_support IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.macd_crossover IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
           NEW.bb_squeeze_breakout IS TRUE AND
		   NEW.timeframe = '4h') THEN
           v_condition_set := 105;
  -- Set 6
    ELSIF (NEW.increasing_volume IS TRUE AND
           NEW.macd_crossover IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
           NEW.bb_squeeze_breakout IS TRUE AND
		   NEW.timeframe = '4h') THEN
           v_condition_set := 106;
  -- Set 7
    ELSIF (NEW.increasing_volume IS TRUE AND
           NEW.macd_crossover IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
		   NEW.timeframe = '4h') THEN
           v_condition_set := 107;
 -- Set 8
    ELSIF (NEW.increasing_volume IS TRUE AND
           NEW.macd_crossover IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
		   NEW.timeframe = '4h') THEN
           v_condition_set := 108;

 -- Set 10
    ELSIF (NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
	    NEW.timeframe = '4h') THEN
           v_condition_set := 110;
 -- Set 11
    ELSIF (NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
           NEW.bb_squeeze_breakout IS TRUE AND
	    NEW.timeframe = '4h') THEN
           v_condition_set := 111;
 -- Set 12
    ELSIF (NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.macd_crossover IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
           NEW.bb_squeeze_breakout IS TRUE AND
	    NEW.timeframe = '4h') THEN
           v_condition_set := 112;

 -- Set 13
    ELSIF (NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.break_above_r1 IS TRUE AND
	    NEW.timeframe = '4h') THEN
           v_condition_set := 113;

  -- 1d Conditions
    -- Set 1
    ELSEIF (NEW.macd_crossover IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.bullish_engulfing IS TRUE AND
		   NEW.timeframe = '1d') THEN
           v_condition_set := 201;
    -- Set 2
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.morning_star IS TRUE AND
		   NEW.timeframe = '1d') THEN
           v_condition_set := 202;
    -- Set 3
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.falling_wedge_breakout IS TRUE AND
		   NEW.timeframe = '1d') THEN
           v_condition_set := 203;
    -- Set 4
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
		   NEW.timeframe = '1d') THEN
           v_condition_set := 204;
    -- Set 5
    ELSIF (NEW.bullish_engulfing IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma50 IS TRUE AND
           NEW.bb_squeeze_breakout IS TRUE AND
           NEW.timeframe = '1d') THEN
           v_condition_set := 205;
	END IF;

    -- Multiple inserts
    -- Check for existing rows for the same symbol within a 5-hour window in bullish_signals
    
      /* -- Count total matching alerts
       SELECT COUNT(*),
              BOOL_OR(timeframe = '1h'),
              BOOL_OR(timeframe = '4h')
       INTO v_count, v_has_1h, v_has_4h
       FROM public.bullish_signals
       WHERE symbol = NEW.symbol
       AND alert_triggered_at BETWEEN NEW.alert_triggered_at - INTERVAL '5 hours'
                                   AND NEW.alert_triggered_at + INTERVAL '5 hours';

       -- If there are more than 2 alerts and both 1h and 4h are present, override ID
       IF v_count > 2 AND v_has_1h AND v_has_4h THEN
              NEW.id := 1000000;
       END IF;
	   */

    -- Only insert if a condition set was met AND is active for monitoring
    IF v_condition_set IS NOT NULL THEN
        -- Check if the condition set is active in the control table
        IF EXISTS (SELECT 1
                   FROM public.indicator_control ic
                   WHERE ic.id = v_condition_set AND ic.active_monitoring = 1) THEN
            -- If it's active, perform the insert
            INSERT INTO public.bullish_signals_monitoring (
                id, symbol, timeframe, current_price, score, rsi, atr, macd_histogram, golden_cross, bullish_engulfing,
                hammer, close_to_support, morning_star, three_white_soldiers, doji, increasing_volume,
                volume_spike, macd_crossover, price_above_ma50, price_above_ma200, rsi_bullish_divergence,
                falling_wedge_breakout, bull_flag, bb_squeeze_breakout, break_above_r1, support_price,
                alert_triggered_at, created_at, condition_set
            ) VALUES (
                NEW.id, NEW.symbol, NEW.timeframe, NEW.current_price, NEW.score, NEW.rsi, NEW.atr, NEW.macd_histogram,
                NEW.golden_cross, NEW.bullish_engulfing, NEW.hammer, NEW.close_to_support, NEW.morning_star,
                NEW.three_white_soldiers, NEW.doji, NEW.increasing_volume, NEW.volume_spike,
                NEW.macd_crossover, NEW.price_above_ma50, NEW.price_above_ma200, NEW.rsi_bullish_divergence,
                NEW.falling_wedge_breakout, NEW.bull_flag, NEW.bb_squeeze_breakout, NEW.break_above_r1, NEW.support_price,
                NEW.alert_triggered_at, NEW.created_at, v_condition_set
            );
        END IF; -- End of the active monitoring check
    END IF;

    RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.check_bullish_signal_conditions()
    OWNER TO postgres;
