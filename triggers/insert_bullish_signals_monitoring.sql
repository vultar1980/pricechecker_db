CREATE TRIGGER insert_bullish_signals_monitoring
AFTER INSERT ON public.bullish_signals
FOR EACH ROW
EXECUTE FUNCTION check_bullish_signal_conditions();