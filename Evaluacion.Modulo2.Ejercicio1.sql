----Evaluación Final Módulo 2

-- Exercise 1 - Extracción de datos de películas navideñas y creación de base de datos 

---Fase 1
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


SELECT * FROM christmas_movie LIMIT 10;

SELECT * 
FROM christmas_movie
LIMIT 5;

---Fase 4 – Consultas en SQL (responder a las preguntas)

---4.1. Top 10 películas mejor valoradas (IMDb): ¿Cuáles son las 10 películas navideñas con mejor rating de IMDb?

SELECT
    title,
    imdb_rating,
    votes
FROM christmas_movie
WHERE imdb_rating IS NOT NULL
ORDER BY imdb_rating DESC, votes DESC
LIMIT 10;

---4.2. Películas por década con rating promedio; ¿Cuántas películas se han producido por década y cuál es el rating promedio de cada década?
SELECT
    (release_year DIV 10) * 10 AS decade,
    COUNT(*) AS num_movies,
    AVG(imdb_rating) AS avg_imdb_rating
FROM christmas_movie
WHERE release_year IS NOT NULL
GROUP BY decade
ORDER BY decade;

---4.3. Pelis de comedia < 120 minutos: ¿Cuáles son las películas de comedia navideñas que duran menos de 120 minutos, ordenadas por rating?

SELECT
    title,
    genre,
    runtime,
    imdb_rating
FROM christmas_movie
WHERE
    genre LIKE '%Comedy%'  -- contiene la palabra Comedy
    AND runtime < 120
ORDER BY imdb_rating DESC;

---4.4. Directores con más de una película + rating promedio:
--- ¿Qué directores han dirigido más de una película navideña y cuál es su rating prom1edio?

SELECT
    director,
    COUNT(*) AS num_movies,
    AVG(imdb_rating) AS avg_imdb_rating
FROM christmas_movie
WHERE director IS NOT NULL AND director <> ''
GROUP BY director
HAVING COUNT(*) > 1
ORDER BY num_movies DESC, avg_imdb_rating DESC;

---4.5. Películas recientes mejor valoradas (últimos 5 años):
¿Cuáles son las películas navideñas de los últimos 5 años con mejor valoración en IMDb?

SELECT
    title,
    release_year,
    imdb_rating
FROM christmas_movie
WHERE
    release_year >= YEAR(CURDATE()) - 5
    AND imdb_rating IS NOT NULL
ORDER BY imdb_rating DESC;