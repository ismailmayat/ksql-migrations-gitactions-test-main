# ksql-migrations-gitactions-test-main

Based on [blog post]([https://website-name.com](https://www.confluent.io/blog/easily-manage-database-migrations-with-evolving-schemas-in-ksqldb/))

If you get failures on build with errors around missing streams then you can create those manually first.


```

CREATE STREAM migration_events ( /* name will be configurable */
  version_key  STRING KEY,
  version      STRING,
  name         STRING,
  state        STRING,  
  checksum     STRING,
  started_on   STRING, /* may use the new TIMESTAMP type, depending on availability at time of release */
  completed_on STRING, /* may use the new TIMESTAMP type, depending on availability at time of release */
  previous     STRING,
  error_reason     STRING
) WITH (  
  KAFKA_TOPIC='default_ksql_migration_events', /* topic name will be configurable */
  VALUE_FORMAT='JSON',
  PARTITIONS=1,
  REPLICAS=1 /* value will be configurable */
);

```

```
CREATE TABLE MIGRATION_SCHEMA_VERSIONS
  WITH (
    KAFKA_TOPIC='ksql-service-idksql_MIGRATION_SCHEMA_VERSIONS'
  )
  AS SELECT 
    version_key, 
    latest_by_offset(version) as version, 
    latest_by_offset(name) AS name, 
    latest_by_offset(state) AS state,     
    latest_by_offset(checksum) AS checksum, 
    latest_by_offset(started_on) AS started_on, 
    latest_by_offset(completed_on) AS completed_on, 
    latest_by_offset(previous) AS previous, 
    latest_by_offset(error_reason) AS error_reason 
  FROM MIGRATION_EVENTS 
  GROUP BY version_key;
```

