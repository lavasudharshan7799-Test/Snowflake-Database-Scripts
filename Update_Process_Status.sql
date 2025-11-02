--here i am doing the code chages 
CREATE OR REPLACE PROCEDURE UPDATE_PROCESS_STATUS(RUN_ID VARCHAR,FILE_PREFIX VARCHAR,BUSINESS_DATE VARCHAR,FILE_NAME VARCHAR,STATUS VARCHAR,PROCEDURE_NAME VARCHAR DEFAULT 'UNKNOWN',RECORD_COUNT_IN_FILE NUMBER DEFAULT -1,RECORD_COUNT_LOADED NUMBER DEFAULT -1)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'main'
EXECUTE AS CALLER
AS $$
import json

def main(session, run_id, file_prefix, business_date, file_name, status, procedure_name, record_count_in_file, record_count_loaded):
    log_steps = []
    try:
        log_steps.append(f"{procedure_name}: Status={status}, Date={business_date if business_date else 'N/A'}, RecordCountInFile={record_count_in_file}, RecordCountLoaded={record_count_loaded}")
        session.sql(
            f"INSERT INTO FILE_LOAD_STATUS(RUN_ID, FILE_PREFIX, BUSINESS_DATE, FILE_NAME, STATUS, RECORD_COUNT_IN_FILE, RECORD_COUNT_LOADED) VALUES (?, ?, ?, ?, ?, ?, ?)",
            params=[run_id, file_prefix, business_date if business_date is not None else '', file_name, status, record_count_in_file, record_count_loaded]
        ).collect()
        return json.dumps({'message': 'Status updated', 'log_steps': log_steps})
    except Exception as err:
        error_msg = str(err)
        log_steps.append(f"{procedure_name}: Error - {error_msg}")
        return json.dumps({'message': f"Error: {error_msg}", 'log_steps': log_steps})
$$;
