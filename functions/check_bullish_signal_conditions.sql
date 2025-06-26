CREATE OR REPLACE FUNCTION check_bullish_signal_conditions()
RETURNS TRIGGER AS $$
DECLARE
    v_condition_set INTEGER; -- Declare a variable to hold the condition set number
BEGIN
    v_condition_set := NULL; -- Initialize the variable to NULL

	-- 1hr Conditions
    -- Set 1
    IF (NEW.macd_crossover IS TRUE AND
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
    -- 1d Conditions
    -- Set 5
    ELSEIF (NEW.macd_crossover IS TRUE AND
        NEW.increasing_volume IS TRUE AND
        NEW.bullish_engulfing IS TRUE AND
		NEW.timeframe = '1d') THEN
        v_condition_set := 5;
    -- Set 6
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.morning_star IS TRUE AND
		   NEW.timeframe = '1d') THEN
           v_condition_set := 6;
    -- Set 7
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.falling_wedge_breakout IS TRUE AND
		   NEW.timeframe = '1d') THEN
           v_condition_set := 7;
    -- Set 8
    ELSIF (NEW.macd_crossover IS TRUE AND
           NEW.increasing_volume IS TRUE AND
           NEW.volume_spike IS TRUE AND
           NEW.price_above_ma200 IS TRUE AND
		   NEW.timeframe = '1d') THEN
           v_condition_set := 8;
	END IF;

    -- Only insert if a condition set was met
    IF v_condition_set IS NOT NULL THEN
        INSERT INTO public.bullish_signals_monitoring (
            symbol, timeframe, current_price, score, rsi, atr, macd_histogram, golden_cross, bullish_engulfing,
            hammer, close_to_support, morning_star, three_white_soldiers, doji, increasing_volume,
            volume_spike, macd_crossover, price_above_ma50, price_above_ma200, rsi_bullish_divergence,
            falling_wedge_breakout, alert_triggered_at, created_at, condition_set
        ) VALUES (
            NEW.symbol, NEW.timeframe, NEW.current_price, NEW.score, NEW.rsi, NEW.atr, NEW.macd_histogram,
            NEW.golden_cross, NEW.bullish_engulfing, NEW.hammer, NEW.close_to_support, NEW.morning_star,
            NEW.three_white_soldiers, NEW.doji, NEW.increasing_volume, NEW.volume_spike,
            NEW.macd_crossover, NEW.price_above_ma50, NEW.price_above_ma200, NEW.rsi_bullish_divergence,
            NEW.falling_wedge_breakout, NEW.alert_triggered_at, NEW.created_at, v_condition_set -- Use the variable here
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;