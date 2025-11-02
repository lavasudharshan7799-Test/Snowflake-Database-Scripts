CREATE OR REPLACE PROCEDURE LOG_AUDIT_MESSAGE(RUN_ID VARCHAR,FILE_PREFIX VARCHAR,FILE_NAME VARCHAR,LOG_MESSAGE VARCHAR)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'main'
EXECUTE AS CALLER
AS $$
def main(session, run_id, file_prefix, file_name, log_message):
    session.sql(
        f"INSERT INTO FILE_LOAD_LOG(RUN_ID, FILE_PREFIX, FILE_NAME, LOG_MESSAGE) VALUES (?, ?, ?, ?)",
        params=[run_id, file_prefix, file_name, log_message]
    ).collect()
    return "Logged successfully"
$$;
