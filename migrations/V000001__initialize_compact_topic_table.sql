CREATE TABLE STOCK_TABLE_COMPACT_V1 (
  userid VARCHAR PRIMARY KEY,
  quantity BIGINT,
  side VARCHAR,
  symbol VARCHAR,
  price BIGINT,
  account VARCHAR
) WITH (
  kafka_topic='compact_topic_test',
  partitions=1,
  value_format='json'
);