-- FUNCTION: public.check_bullish_signal_conditions()

-- DROP FUNCTION IF EXISTS public.check_bullish_signal_conditions();

CREATE OR REPLACE FUNCTION public.check_bullish_signal_conditions()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
    v_condition_set INTEGER;
BEGIN

    v_condition_set := NULL; -- Initialize the variable to NULL

   -- Set 1
    IF (NEW.timeframe = '1h' 
	  AND NEW.price_above_ma50 IS TRUE
	  AND NEW.price_above_ma200 IS TRUE
	  AND NEW.rsi_bullish_regime IS TRUE
	  AND NEW.increasing_volume IS TRUE
	  AND NEW.adx >= 50
	  AND NEW.cmf >= 0.06
	  AND NEW.bull_flag IS TRUE) 
	  THEN v_condition_set := 1;
    -- Set 2
    ELSEIF (NEW.timeframe = '1h' 
	  AND NEW.price_above_ma50 IS TRUE
	  AND NEW.price_above_ma200 IS TRUE
	  AND NEW.rsi_bullish_regime IS TRUE
	  AND NEW.increasing_volume IS TRUE
	  AND NEW.adx >= 50
	  AND NEW.cmf >= 0.06) 
	  THEN v_condition_set := 2;
    -- Set 3
     ELSIF (NEW.timeframe = '1h' AND 
	 		NEW.inside_bar IS TRUE AND
			NEW.roc10 >= 11.15) 
		   THEN v_condition_set := 3;
	 -- Set 4
     ELSIF (NEW.timeframe = '1h' AND 
	 		NEW.inside_bar IS TRUE AND
			NEW.rsi >= 70.40) 
		   THEN v_condition_set := 4;
    -- Set 5
     ELSIF (NEW.timeframe = '1h' AND 
	 		NEW.weekly_confirm IS TRUE AND
  			NEW.rsi_bullish_regime IS TRUE AND
  			NEW.inside_bar IS TRUE AND
  			NWE.obv >= 287997131 AND
  			NEW. mfi >= 74.8 AND
  			NEW.roc10 >= 24.6) 
		   THEN v_condition_set := 5;
    -- Set 6
     ELSIF (NEW.timeframe = '4h' AND 
			NEW.break_above_r1 IS TRUE AND
  			NEW.adx >= 44.4)
		   THEN v_condition_set := 6;
	 -- Set 7
     ELSIF (NEW.timeframe = '4h' AND 
			NEW.macd_crossover IS TRUE AND
  			NEW.break_above_r1 IS TRUE)
		   THEN v_condition_set := 7;
	 -- Set 8
     ELSIF (NEW.timeframe = '4h' AND 
		  	NEW.macd_crossover IS TRUE AND 
			NEW.roc10 >= 3.77)
		   THEN v_condition_set := 8;
	 -- Set 9
     ELSIF (NEW.timeframe = '4h' AND 
			NEW.macd_crossover IS TRUE AND
  			NEW.rsi >= 59.98)
		   THEN v_condition_set := 9;
	 -- Set 10
     ELSIF (NEW.timeframe = '4h' AND 
			NEW.macd_crossover IS TRUE AND
  			NEW.cmf >= -0.05)
		   THEN v_condition_set := 10;
	END IF;


    -- Ensure v_condition_set is set when conditions are met; if not matched, return NEW.
    IF v_condition_set IS NULL THEN
        RETURN NEW;
    END IF;

    -- Persist to the source row so downstream triggers/functions can read it
    NEW.condition_set := v_condition_set;

    -- Insert into monitoring with extended columns + bar_time
    INSERT INTO public.bullish_signals_monitoring (
        id, symbol, timeframe, current_price, score, rsi, atr, macd_histogram,
        golden_cross, bullish_engulfing, hammer, close_to_support, morning_star,
        three_white_soldiers, doji, increasing_volume, volume_spike, macd_crossover,
        price_above_ma50, price_above_ma200, rsi_bullish_divergence, falling_wedge_breakout,
        bull_flag, bb_squeeze_breakout, break_above_r1, support_price,
        alert_triggered_at, created_at, 
        bar_time,
        adx, ema200, supertrend_up, donchian_break20, donchian_break55, nr7, inside_bar,
        obv, mfi, cmf, klinger, klinger_signal, roc10, stochrsi_k, stochrsi_d, stochrsi_kxdupbull,
        rsi_bullish_regime, bars_since_macd_cross, bars_in_squeeze, weekly_confirm, btc_bear, condition_set
    ) VALUES (
        NEW.id, NEW.symbol, NEW.timeframe, NEW.current_price, NEW.score, NEW.rsi, NEW.atr, NEW.macd_histogram,
        NEW.golden_cross, NEW.bullish_engulfing, NEW.hammer, NEW.close_to_support, NEW.morning_star,
        NEW.three_white_soldiers, NEW.doji, NEW.increasing_volume, NEW.volume_spike, NEW.macd_crossover,
        NEW.price_above_ma50, NEW.price_above_ma200, NEW.rsi_bullish_divergence, NEW.falling_wedge_breakout,
        NEW.bull_flag, NEW.bb_squeeze_breakout, NEW.break_above_r1, NEW.support_price,
        NEW.alert_triggered_at, NEW.created_at, 
        NEW.bar_time,
        NEW.adx, NEW.ema200, NEW.supertrend_up, NEW.donchian_break20, NEW.donchian_break55, NEW.nr7, NEW.inside_bar,
        NEW.obv, NEW.mfi, NEW.cmf, NEW.klinger, NEW.klinger_signal, NEW.roc10, NEW.stochrsi_k, NEW.stochrsi_d, NEW.stochrsi_kxdupbull,
        NEW.rsi_bullish_regime, NEW.bars_since_macd_cross, NEW.bars_in_squeeze, NEW.weekly_confirm, NEW.btc_bear, NEW.condition_set
    );

    RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.check_bullish_signal_conditions()
    OWNER TO postgres;
