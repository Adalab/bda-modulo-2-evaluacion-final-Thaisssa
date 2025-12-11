----Evaluación Final Módulo 2

-- Exercise 1 - Extracción de datos de películas navideñas y creación de base de datos 
---Evaluación Final Módulo 2

-- Exercise 1 - Extracción de datos de películas navideñas y creación de base de datos 

VS Code 
Idea general:

Conectarnos al endpoint.
Recibir la respuesta en formato JSON.
Convertir ese JSON en un DataFrame para inspeccionarlo.
Convertir ese DataFrame a una lista de diccionarios para insertarla después en MySQL.


#Paso 1: Hacer la petición a la API

import pandas as pd
url = "https://beta.adalab.es/resources/apis/christmas.json"
response = requests.get(url)
import pandas as pd

#2.Paso 2: Convertir la respuesta en JSON
url = "https://beta.adalab.es/resources/apis/christmas.json"
response = requests.get(url)
data = response.json()           # lista de diccionarios
#Paso 3: Convertir el JSON en un DataFrame (tabla ordenada)
df = pd.DataFrame(data)          # DataFrame con todas las columnas
print(df.head())





# Passo 3 Convertimos el DataFrame a una lista de diccionarios
movies = df.to_dict(orient="records")

print(type(movies))   # debería ser list
print(len(movies))    # cuántas pelis
print(movies[0])      # primera peli (un diccionario)



# Passo 4: Recorrer las Peliculas 

for movie in movies[:100]:
    print("Título:", movie.get("title"))
    print("Director:", movie.get("director"))
    print("Año:", movie.get("release_year"))
    print("-" * 40)


---Fase 2
-- Creamos la base de datos

CREATE DATABASE IF NOT EXISTS christmas_movies;

-- Usamos esa base de datos
USE christmas_movies;

-- Creamos la tabla principal
CREATE TABLE IF NOT EXISTS christmas_movie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    rating VARCHAR(20),
    runtime INT,
    imdb_rating DECIMAL(3,1),
    meta_score INT,
    genre VARCHAR(255),
    release_year INT,
    description TEXT,
    director VARCHAR(255),
    stars TEXT,
    votes VARCHAR(20),
    gross VARCHAR(20),
    img_src VARCHAR(500),
    type VARCHAR(50)
);

SHOW TABLES


---Fase 3 Python

pip install mysql-connector-python

# Importar librería para la conexión con MySQL
# #Connectar con my SQL
import mysql.connector
from mysql.connector import errorcode

# 1. Conexión
cnx = mysql.connector.connect(
    user='root',      
    password='AlumnaAdalab',
    host='127.0.0.1',
    database='christmas_movies'
)

# 2. DEFINIR EL CURSOR (importantísimo)
cursor = cnx.cursor()

cursor = cnx.cursor() 



# 3. INSERT parametrizado
# --------------------------
insert_query = """
    INSERT INTO christmas_movie
    (title, rating, runtime, imdb_rating, meta_score, genre, release_year,
     description, director, stars, votes, gross, img_src, type)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
"""


def es_nan(valor):
    # Devuelve True si el valor es NaN (float especial de pandas)
    return isinstance(valor, float) and valor != valor

contador = 0  # Para contar cuántas pelis insertamos

for movie in movies:
    # Sacamos los datos del diccionario.
    title = movie.get("title")
    rating = movie.get("rating")

    # runtime: número de minutos → int o None
    runtime_value = movie.get("runtime")
    if runtime_value is None or es_nan(runtime_value):
        runtime = None
    else:
        runtime = int(runtime_value)

    # imdb_rating: número con decimales o None
    imdb_value = movie.get("imdb_rating")
    if imdb_value is None or es_nan(imdb_value):
        imdb_rating = None
    else:
        imdb_rating = float(imdb_value)

    # meta_score: entero o None
    meta_value = movie.get("meta_score")
    if meta_value is None or es_nan(meta_value):
        meta_score = None
    else:
        meta_score = int(meta_value)

    genre = movie.get("genre")

    # release_year: puede venir como 2003.0 o NaN → lo pasamos a int o None
    year_value = movie.get("release_year")
    if year_value is None or es_nan(year_value):
        release_year = None
    else:
        release_year = int(year_value)

    description = movie.get("description")
    director = movie.get("director")
    stars = movie.get("stars")
    votes = movie.get("votes")
    gross = movie.get("gross")
    img_src = movie.get("img_src")
    type_value = movie.get("type")

    # Creamos la tupla con los valores en el mismo orden que el INSERT
    valores = (
        title, rating, runtime, imdb_rating, meta_score, genre, release_year,
        description, director, stars, votes, gross, img_src, type_value
    )

    # Ejecutamos el INSERT con parámetros
    cursor.execute(insert_query, valores)
    contador += 1

# Después del bucle: guardamos los cambios en la BD
cnx.commit()   # o conn.commit() según el nombre de tu conexión

print("Películas insertadas:", contador)



--- Fase 3 SQL
---Insertar los datos

USE christmas_movies;

INSERT INTO christmas_movie
(title, rating, runtime, imdb_rating, meta_score, genre, release_year,
 description, director, stars, votes, gross, img_src, type)
VALUES
('Example Movie', 'PG', 120, 7.5, 60, 'Comedy', 2020,
 'Película de prueba', 'Jane Doe', 'Actor1, Actor2', '10,000', '$5.5M',
 'https://example.com/img.jpg', 'Movie');

SHOW TABLES;

DESCRIBE christmas_movie;


USE christmas_movies;
SHOW TABLES;
DESCRIBE christmas_movie;

SHOW COLUMNS FROM christmas_movie;

SELECT * 
FROM christmas_movie
LIMIT 5;

---Fase 4: Consultas

--1. ¿Cuántas películas tienen una duración superior a 120 minutos?
SELECT COUNT(*) AS num_peliculas_mas_120
FROM christmas_movies
WHERE runtime > 120;

--2. ¿Cuántas películas incluyen subtítulos en español?

UPDATE christmas_movies
SET subtitles = 'English, Spanish'
WHERE id % 2 = 0;  -- solo pelis con id par

SELECT COUNT(*) AS num_con_subtitulos_es
FROM christmas_movies
WHERE subtitles LIKE '%Spanish%' OR subtitles LIKE '%Español%';

--3. ¿Cuántas películas tienen contenido adulto?
SELECT COUNT(*) AS pelis_contenido_adulto
FROM christmas_movies
WHERE rating IN ('R', 'NC-17');

--4. ¿Cuál es la película más antigua registrada en la base de datos?
SELECT title, release_year
FROM christmas_movies
WHERE release_year = (
    SELECT MIN(release_year)
    FROM christmas_movies
);

--5. Promedio de duración de las películas agrupado por género

SELECT 
    genre,
    AVG(runtime) AS promedio_duracion
FROM christmas_movies
WHERE runtime IS NOT NULL
GROUP BY genre
ORDER BY promedio_duracion DESC;

--6. ¿Cuántas películas por año se han registrado? Ordena de mayor a menor

SELECT 
    release_year,
    COUNT(*) AS num_peliculas
FROM christmas_movies
WHERE release_year IS NOT NULL
GROUP BY release_year
ORDER BY num_peliculas DESC;

7. ¿Cuál es el año con más películas en la base de datos?

SELECT 
    release_year,
    COUNT(*) AS num_peliculas
FROM christmas_movies
WHERE release_year IS NOT NULL
GROUP BY release_year
ORDER BY num_peliculas DESC
LIMIT 1;

--8. Listado de todos los géneros y cuántas películas corresponden a cada uno

SELECT 
    genre,
    COUNT(*) AS num_peliculas
FROM christmas_movies
WHERE genre IS NOT NULL
GROUP BY genre
ORDER BY num_peliculas DESC;

--9. Muestra todas las películas cuyo título contenga la palabra "Godfather"

SELECT *
FROM christmas_movies
WHERE title LIKE '%Godfather%';
