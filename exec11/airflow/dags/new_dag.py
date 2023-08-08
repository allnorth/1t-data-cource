from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.models import Variable
from airflow.hooks.base_hook import BaseHook

import requests
import psycopg2
from psycopg2 import sql

default_args = {
    'start_date': datetime(2023, 8, 6),
    'owner': 'airflow'
}

def get_curr():
    response = requests.get(Variable.get("url"))
    data = response.json()

    my_conn = BaseHook.get_connection("pg_conn")
    conn = psycopg2.connect(dbname='test', user=my_conn.login,
                            password=my_conn.password, host=my_conn.host, port = my_conn.port)

    with conn.cursor() as cursor:
        conn.autocommit = True
        insert = sql.SQL('INSERT INTO exchange_rate (rate_dt, rate_amt) VALUES {}').format(sql.SQL(',').join(map(sql.Literal, data['date'], data['rates']['RUB'])))
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
