from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

import requests
import psycopg2
from psycopg2 import sql

default_args = {
    'start_date': datetime(2023, 8, 6),
    'owner': 'airflow'
}

def get_curr():
    url = 'https://api.exchangerate.host/latest?base=BTC&symbols=RUB'
    response = requests.get(url)
    data = response.json()
    lst = []
    lst.append((data['date'], data['rates']['RUB']))

    conn = psycopg2.connect(dbname='test', user='postgres',
                            password='password', host='db', port = '5430')

    with conn.cursor() as cursor:
        conn.autocommit = True
        insert = sql.SQL('INSERT INTO exchange_rate (rate_dt, rate_amt) VALUES {}').format(sql.SQL(',').join(map(sql.Literal, lst)))
        cursor.execute(insert)

my_dag = DAG(
    dag_id="simple_dag",
    default_args = default_args,
    schedule_interval='*/10 * * * *',
    catchup=False
)

task1 = BashOperator(
    task_id='echo_hi',
    bash_command='echo "Good morning my diggers!"',
    dag = my_dag
)

task2 = PythonOperator(
    task_id='get_curr_latest',
    python_callable = get_curr,
    dag = my_dag
)
