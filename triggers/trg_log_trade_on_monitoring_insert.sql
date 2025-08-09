-- Trigger: trg_log_trade_on_monitoring_insert

-- DROP TRIGGER IF EXISTS trg_log_trade_on_monitoring_insert ON public.bullish_signals_monitoring;

CREATE OR REPLACE TRIGGER trg_log_trade_on_monitoring_insert
    AFTER INSERT
    ON public.bullish_signals_monitoring
    FOR EACH ROW
    EXECUTE FUNCTION public.log_trade_on_monitoring_insert();