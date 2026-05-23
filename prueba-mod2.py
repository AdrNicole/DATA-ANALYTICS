

# pip install psycopg2-binary
# !pip install sqlalchemy

# Para crear la base de datos (en el SQLshell)
#psql -h localhost -p 5432 -U postgres -c "CREATE DATABASE classicmodels;"

# Para caragr los datos del archivo (en el SQLshell)
# psql -h localhost -p 5432 -U postgres -d classicmodels -f classicmodels.sql


from sqlalchemy import create_engine

db_url = "postgresql://postgres:password@localhost:5432/classicmodels"
engine = create_engine(db_url)

# 1. Genera una función llamada leer_tabla(tabla, engine) y utilízala para leer tablas
# completas desde la base de datos en dataframes independientes. 

def leer_tabla(tabla, engine):
    query = f'SELECT * FROM {tabla}'
    return pd.read_sql(query, con=engine)

#  Utilizando esta función, importa las siguientes tablas:
# order, orderdetails, customers, products, employees

# veo el nombre de las tablas antes de cargarlas
#from sqlalchemy import inspect
inspector = inspect(engine)
tablas = inspector.get_table_names()
print(tablas)

# importo las tablas con sus respectivos nombres
orders = leer_tabla('orders',engine)
orderdetails = leer_tabla('orderdetails',engine)
customers = leer_tabla('customers',engine)
products = leer_tabla('products',engine)
employees = leer_tabla('employees',engine)

# probamos si funciona imprimiendo la tabla orders
print(orders)

# 2. Realiza el cruce entre los DataFrames, asegurándote de utilizar correctamente el
# parámetro validate para asegurar la integridad referencial
import pandas as pd

print(f'Tabla: orders {orders.shape}\n{orders.columns.tolist()}\n')
print(f'Tabla: customers {customers.shape}\n{customers.columns.tolist()}\n')
print(f'Tabla: orderdetails {orderdetails.shape}\n {orderdetails.columns.tolist()}\n')
print(f'Tabla: products {products.shape}\n{products.columns.tolist()}\n')
print(f'Tabla: employees {employees.shape}\n {employees.columns.tolist()}\n')

# Union1 = orders + customers -> id_comun = 'customerNumber'
# Union2 = Union1 + orderdetails -> id_comun = 'orderNumber'
# Union3 = Union2 + products -> id_comun = 'productCode'
# Union4 = Union3 + employees.columns -> id_comun = 'salesRepEmployeeNumber', 'employeeNumber'

# ¿Hay customerNumber duplicados en customers?
print(f'Las tablas tienen la siguiente cantidad de filas duplicadas')
print(orders.duplicated().sum())
print(orderdetails.duplicated().sum())
print(customers.duplicated().sum())
print(products.duplicated().sum())
print(employees.duplicated().sum())

# ¿Cuántos únicos hay?
unicos = orders['customerNumber'].nunique()
print(f'La tabla orders solo debe tener {len(orders) - orders.duplicated().sum()} filas de {len(orders)}')

# eliminamos duplicados de cada tabla
orders = orders.drop_duplicates()
orderdetails = orderdetails.drop_duplicates()
customers = customers.drop_duplicates()
products = products.drop_duplicates()
employees = employees.drop_duplicates()

print(f'Tabla: orders {orders.shape}')
print(f'Tabla: customers {customers.shape}')
print(f'Tabla: orderdetails {orderdetails.shape}')
print(f'Tabla: products {products.shape}')
print(f'Tabla: employees {employees.shape}')

# Hallamos que tipo de relacion tiene cada ID
# Many_to_one
print(orders['customerNumber'].duplicated().sum())
print(customers['customerNumber'].duplicated().sum())

# One_to_many
print(orders['orderNumber'].duplicated().sum())
print(orderdetails['orderNumber'].duplicated().sum())

# Many_to_one
print(orderdetails['productCode'].duplicated().sum())
print(products['productCode'].duplicated().sum())

# Many_to_one
print(customers['salesRepEmployeeNumber'].duplicated().sum())
print(employees['employeeNumber'].duplicated().sum())

# Unimos las tablas
Union1 = pd.merge(
    orders, customers,
    on = 'customerNumber',
    how = 'left',
    validate = "many_to_one" # muchas ordenes -> 1 customer
)

Union2 = pd.merge(
    Union1, orderdetails,
    on = 'orderNumber',
    how = 'left',
    validate = "one_to_many" # un numero de orden -> muchos detalles de pedido
)

Union3 = pd.merge(
    Union2, products,
    on = 'productCode',
    how = 'left',
    validate = 'many_to_one' # muchos detalles de productos -> un codigo de producto
)

df_base = pd.merge(
    Union3, employees,
    left_on = 'salesRepEmployeeNumber', # ID comun en Union3
    right_on = 'employeeNumber', # ID comun en employees
    how = 'left',
    validate = 'many_to_one' # muchos clientes atenditos -> por un mismo empleado
)

# dimensiones
print(df_base.shape)

# verifico que no tenga ninguna fila duplicada
print(df_base.duplicated().sum())

df_base.head()

