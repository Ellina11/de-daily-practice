import pandas as pd
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')

def read_data(filepath):
    logging.info(f'Reading data from {filepath}')
    df = pd.read_csv(filepath)
    logging.info(f'Loaded {len(df)} rows and {len(df.columns)} columns')
    return df

def clean_data(df):
    logging.info('Cleaning data...')
    df = df.drop_duplicates()
    df = df.dropna()
    df['hire_date'] = pd.to_datetime(df['hire_date'])
    logging.info(f'After cleaning: {len(df)} rows remaining')
    return df

def transform_data(df):
    logging.info('Transforming data...')
    df['hire_year']    = df['hire_date'].dt.year
    df['hire_month']   = df['hire_date'].dt.month
    df['salary_grade'] = df['salary'].apply(
        lambda x: 'High' if x >= 8000 else ('Mid' if x >= 7000 else 'Low')
    )
    return df

def write_data(df, filepath):
    logging.info(f'Writing output to {filepath}')
    df.to_parquet(filepath, index=False)
    logging.info('Done!')

def run_etl():
    try:
        df = read_data('employees.csv')
        df = clean_data(df)
        df = transform_data(df)
        write_data(df, 'employees_clean.parquet')
        logging.info('ETL pipeline completed successfully!')
    except FileNotFoundError:
        logging.error('Input file not found — check the filepath!')
    except pd.errors.EmptyDataError:
        logging.error('Input file is empty!')
    except Exception as e:
        logging.error(f'Pipeline failed with error: {e}')

run_etl()