-- Создаю таблицы Staff и Jobtitles 

CREATE TABLE Jobtitles (
 jobtitle_id SERIAL,
  name VARCHAR(100) NOT NULL,
	CONSTRAINT PK_jobtitles_jobtitles_id PRIMARY KEY(jobtitle_id)
);

INSERT INTO Jobtitles (jobtitle_id, name) VALUES
  (1, 'Разработчик'),
  (2, 'Системный аналитик'),
  (3, 'Менеджер проектов'),
  (4, 'Системный администратор'),
  (5, 'Руководитель группы'),
  (6, 'Инженер тестирования'),
  (7, 'Сотрудник группы поддержки');
  
CREATE TABLE Staff (
  staff_id SERIAL,
  name VARCHAR(100) NOT NULL,
  salary DECIMAL(10,2) NOT NULL,
  email VARCHAR(100) NOT NULL,
  birthday DATE NOT NULL,
  jobtitle_id INT NOT NULL,
	CONSTRAINT PK_staff_staff_id PRIMARY KEY(staff_id),
	CONSTRAINT FK_staff_jobtitles FOREIGN KEY(jobtitle_id) REFERENCES Jobtitles(jobtitle_id)
);

INSERT INTO Staff (staff_id, name, salary, email, birthday, jobtitle_id) VALUES
  (1, 'Иванов Сергей', 100000, 'test@test.ru', '1990-03-03', 1),
  (2, 'Петров Пётр', 60000, 'petr@test.ru', '2000-12-01', 7),
  (3, 'Сидоров Василий', 80000, 'test@test.ru', '1999-02-04', 6),
  (4, 'Максимов Иван', 70000, 'ivan.m@test.ru', '1997-10-02', 4),
  (5, 'Попов Иван', 120000, 'popov@test.ru', '2001-04-25', 5);

--  Задание 1. Напишите запрос, с помощью которого можно найти дубли в поле email из таблицы Sfaff.

SELECT email, COUNT(*) AS count
FROM Staff
GROUP BY email
HAVING COUNT(*) > 1;

--  – Задание 2. Напишите запрос, с помощью которого можно определить возраст каждого сотрудника из таблицы Staff на момент запроса.

SELECT name, 
       email, 
       birthday, 
       date_part('year', age(birthday)) AS age
FROM Staff;

--  Задание 3.  Напишите запрос, с помощью которого можно определить должность (Jobtitles.name) со вторым по величине уровнем зарплаты.

SELECT j.name FROM Jobtitles j
JOIN Staff s ON j.jobtitle_id=s.jobtitle_id
GROUP BY j.name 
HAVING MAX(salary) NOT IN (SELECT max(salary) FROM Staff)
LIMIT 1;

--  Или

SELECT j.name AS job_title,
       MAX(s.salary) AS second_highest_salary
FROM Staff s
JOIN Jobtitles j ON s.jobtitle_id = j.jobtitle_id
WHERE s.salary < (SELECT MAX(salary) FROM Staff)
GROUP BY j.name
ORDER BY second_highest_salary DESC
OFFSET 1 ROW FETCH NEXT 1 ROW ONLY;
