create table chefruns (
  run_id              SERIAL PRIMARY KEY,
  nodename            varchar(255),
  elapsed_time        real,
  start_time          timestamp,
  end_time            timestamp,
  updated_resources   text,
  environment         varchar(255),
  diffs               text
);


