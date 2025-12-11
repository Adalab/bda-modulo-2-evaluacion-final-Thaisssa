----Evaluación Final Módulo 2

-- Exercise 1 - Extracción de datos de películas navideñas y creación de base de datos 
---Evaluación Final Módulo 2

-- Exercise 1 - Extracción de datos de películas navideñas y creación de base de datos 

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

--- Fase 3
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
