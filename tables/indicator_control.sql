create table indicator_control (
id SERIAL PRIMARY KEY,
timeframe TEXT NOT NULL,
indicators TEXT NOT NULL,
active INT NOT NULL,
max_buy NUMERIC NOT NULL
)
