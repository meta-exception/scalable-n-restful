#!/bin/sh -e

psql -U postgres -c "ALTER USER postgres PASSWORD 'badbadbad';"
psql -U postgres -c 'CREATE DATABASE technical_training_department;'
#psql -U postgres -c '\connect technical_training_department;'

psql -U postgres -d technical_training_department -c 'DROP DATABASE postgres;'

psql -U postgres -d technical_training_department -c "CREATE USER dev PASSWORD 'low';"
psql -U postgres -d technical_training_department -c "CREATE USER usr PASSWORD 'low';"

psql -U postgres -d technical_training_department -c 'CREATE SCHEMA main AUTHORIZATION dev;'
psql -U postgres -d technical_training_department -c 'GRANT ALL ON SCHEMA main TO dev;'
psql -U postgres -d technical_training_department -c 'GRANT ALL ON ALL TABLES IN SCHEMA main TO usr;'

psql -U postgres -d technical_training_department -c 'CREATE TABLE main.specialties (
specialty_id SERIAL PRIMARY KEY NOT NULL,
code INTEGER NOT NULL,
title TEXT NOT NULL,
description TEXT
);'


psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.push_specialties(code INTEGER, title TEXT, description TEXT)
  RETURNS INTEGER
AS $function$
INSERT INTO main.specialties (code, title, description) VALUES ($1, $2, $3)
RETURNING specialty_id::INTEGER
$function$ LANGUAGE SQL VOLATILE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.update_specialties(specialty_id INTEGER, code INTEGER, title TEXT, description TEXT)
  RETURNS setof record
AS $function$
UPDATE main.specialties SET code = $2, title = $3, description = $4 WHERE specialty_id = $1
RETURNING *
$function$ LANGUAGE SQL VOLATILE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.fetch_specialties()
  RETURNS TABLE
  (specialty_id INTEGER,
  code INTEGER,
  title TEXT,
  description TEXT)
AS $function$
SELECT * FROM main.specialties
$function$ LANGUAGE SQL STABLE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.pop_specialties(specialty_id INTEGER)
  RETURNS setof record
AS $function$
DELETE FROM main.specialties WHERE specialty_id = $1
RETURNING *
$function$ LANGUAGE SQL VOLATILE;'



psql -U postgres -d technical_training_department -c 'CREATE TABLE main.employees (
employee_id SERIAL PRIMARY KEY,
full_name TEXT,
birth_date DATE,
employment_record TEXT,
hire_date DATE
);'


psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.push_employees(full_name TEXT, birth_date DATE, employment_record TEXT, hire_date DATE)
  RETURNS INTEGER
AS $function$
INSERT INTO main.employees (full_name, birth_date, employment_record, hire_date) VALUES ($1, $2, $3, $4)
RETURNING employee_id::INTEGER
$function$ LANGUAGE SQL VOLATILE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.update_employees(employee_id INTEGER, full_name TEXT, birth_date DATE, employment_record TEXT, hire_date DATE)
  RETURNS setof record
AS $function$
UPDATE main.employees SET full_name = $2, birth_date = $3, employment_record = $4, hire_date = $5 WHERE employee_id = $1
RETURNING *
$function$ LANGUAGE SQL VOLATILE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.fetch_employees()
  RETURNS TABLE
  (employee_id INTEGER,
  full_name TEXT,
  birth_date DATE,
  employment_record TEXT,
  hire_date DATE)
AS $function$
SELECT * FROM main.employees
$function$ LANGUAGE SQL STABLE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.pop_employees(employee_id INTEGER)
  RETURNS setof record
AS $function$
DELETE FROM main.employees WHERE employee_id = $1
RETURNING *
$function$ LANGUAGE SQL VOLATILE;'



psql -U postgres -d technical_training_department -c 'CREATE TABLE main.qualification (
qualification_id SERIAL PRIMARY KEY,
employee_id INTEGER references main.employees(employee_id) ON DELETE CASCADE,
specialty_id INTEGER references main.specialties(specialty_id) ON DELETE CASCADE,
rank INTEGER,
category INTEGER
);'


psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.push_qualification(employee_id INTEGER, specialty_id INTEGER, rank INTEGER, category INTEGER)
  RETURNS INTEGER
AS $function$
INSERT INTO main.qualification (employee_id, specialty_id, rank, category) VALUES ($1, $2, $3, $4)
RETURNING qualification_id::INTEGER
$function$ LANGUAGE SQL VOLATILE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.update_qualification(qualification_id INTEGER, employee_id INTEGER, specialty_id INTEGER, rank INTEGER, category INTEGER)
  RETURNS setof record
AS $function$
UPDATE main.qualification SET employee_id = $2, specialty_id = $3, rank = $4, category = $5 WHERE qualification_id = $1
RETURNING *
$function$ LANGUAGE SQL VOLATILE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.fetch_qualification()
  RETURNS TABLE
  (qualification_id INTEGER,
  employee_id INTEGER,
  specialty_id INTEGER,
  rank INTEGER,
  category INTEGER)
AS $function$
SELECT * FROM main.qualification
$function$ LANGUAGE SQL STABLE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.pop_qualification(qualification_id INTEGER)
  RETURNS setof record
AS $function$
DELETE FROM main.qualification WHERE qualification_id = $1
RETURNING *
$function$ LANGUAGE SQL VOLATILE;'



psql -U postgres -d technical_training_department -c 'CREATE TABLE main.education (
education_id SERIAL PRIMARY KEY,
education_date DATE,
employee_id INTEGER references main.employees(employee_id) ON DELETE CASCADE,
schedule INTEGER,
results_count INTEGER DEFAULT 0
);'


psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.push_education(education_date DATE, employee_id INTEGER, schedule INTEGER)
  RETURNS INTEGER
AS $function$
INSERT INTO main.education (education_date, employee_id, schedule) VALUES ($1, $2, $3)
RETURNING education_id::INTEGER
$function$ LANGUAGE SQL VOLATILE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.update_education(education_id INTEGER, education_date DATE, employee_id INTEGER, schedule INTEGER)
  RETURNS setof record
AS $function$
UPDATE main.education SET education_date = $2, employee_id = $3, schedule = $4 WHERE education_id = $1
RETURNING *
$function$ LANGUAGE SQL VOLATILE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.fetch_education()
  RETURNS TABLE
  (education_id INTEGER,
  education_date DATE,
  employee_id INTEGER,
  schedule INTEGER,
  results_count INTEGER)
AS $function$
SELECT * FROM main.education
$function$ LANGUAGE SQL STABLE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.pop_education(education_id INTEGER)
  RETURNS setof record
AS $function$
DELETE FROM main.education WHERE education_id = $1
RETURNING *
$function$ LANGUAGE SQL VOLATILE;'



psql -U postgres -d technical_training_department -c 'CREATE TABLE main.results (
result_id SERIAL PRIMARY KEY,
designated_education INTEGER references main.education(education_id) ON DELETE CASCADE,
prev_qualification INTEGER references main.qualification(qualification_id) ON DELETE CASCADE,
attestation_date DATE,
success_state BOOLEAN,
new_qualification INTEGER references main.qualification(qualification_id) ON DELETE CASCADE
);'


psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.push_results(designated_education INTEGER, prev_qualification INTEGER, attestation_date DATE, success_state BOOLEAN, new_qualification INTEGER)
  RETURNS INTEGER
AS $function$
INSERT INTO main.results (designated_education, prev_qualification, attestation_date, success_state, new_qualification) VALUES ($1, $2, $3, $4, $5)
RETURNING result_id::INTEGER
$function$ LANGUAGE SQL VOLATILE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.update_results(result_id INTEGER, designated_education INTEGER, prev_qualification INTEGER, attestation_date DATE, success_state BOOLEAN, new_qualification INTEGER)
  RETURNS setof record
AS $function$
UPDATE main.results SET designated_education = $2, prev_qualification = $3, attestation_date = $4, success_state = $5, new_qualification = $6 WHERE result_id = $1
RETURNING *
$function$ LANGUAGE SQL VOLATILE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.fetch_results()
  RETURNS TABLE
  (result_id INTEGER,
  designated_education INTEGER,
  prev_qualification INTEGER,
  attestation_date DATE,
  success_state BOOLEAN,
  new_qualification INTEGER)
AS $function$
SELECT * FROM main.results
$function$ LANGUAGE SQL STABLE;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.pop_results(result_id INTEGER)
  RETURNS setof record
AS $function$
DELETE FROM main.results WHERE result_id = $1
RETURNING *
$function$ LANGUAGE SQL VOLATILE;'


psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE VIEW main.qual_empl_spec
AS
  SELECT
	  qual.qualification_id,
	  empl.employee_id,
	  empl.full_name,
	  spec.code as specialty_code,
	  spec.title as specialty_title,
	  qual.rank,
	  qual.category
  FROM
	  main.qualification as qual
	  LEFT OUTER JOIN
	    main.specialties AS spec
	  ON qual.specialty_id = spec.specialty_id
	  LEFT OUTER JOIN
	    main.employees AS empl
	  ON qual.employee_id = empl.employee_id;'

psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.results_counting()
  RETURNS TRIGGER
AS $function$
BEGIN
    IF (TG_OP = '\''INSERT'\'') THEN
        UPDATE main.education SET results_count = (results_count + 1) WHERE education_id = NEW.designated_education;
        RETURN NEW;
    ELSIF TG_OP = '\''UPDATE'\'' THEN
        UPDATE main.education SET results_count = (results_count + 1) WHERE education_id = NEW.designated_education;
        UPDATE main.education SET results_count = (results_count - 1) WHERE education_id = OLD.designated_education;
        RETURN NEW;
    ELSIF TG_OP = '\''DELETE'\'' THEN
        UPDATE main.education SET results_count = (results_count - 1) WHERE education_id = OLD.designated_education;
        RETURN OLD;
    END IF;
END
$function$ LANGUAGE plpgsql;'


psql -U postgres -d technical_training_department -c 'CREATE TRIGGER education_results_counting
AFTER INSERT OR UPDATE OR DELETE ON main.results FOR EACH ROW
EXECUTE PROCEDURE main.results_counting();'


psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.ordered_qual_empl_spec(ord TEXT)
  RETURNS TABLE
  (qualification_id INTEGER,
  employee_id INTEGER,
  full_name TEXT,
  specialty_code INTEGER,
  specialty_title TEXT,
  rank INTEGER,
  category INTEGER)
AS $function$
BEGIN
SELECT
  qualification_id,
  employee_id,
  full_name,
  specialty_code,
  specialty_title,
  rank,
  category
FROM
  main.qual_empl_spec
ORDER BY $1;
END
$function$ LANGUAGE plpgsql;'


psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.successful_results(first DATE, last DATE)
  RETURNS TABLE
  (result_id INTEGER,
  designated_education INTEGER,
  prev_qualification INTEGER,
  attestation_date DATE,
  new_qualification INTEGER,
  unrelated_educations INTEGER)
AS $function$
BEGIN
SELECT
  result_id,
  designated_education,
  prev_qualification,
  attestation_date,
  new_qualification,
  (
    SELECT count(*)
    FROM main.education
    WHERE education_id NOT IN (
      SELECT designated_education
      FROM
      (
        SELECT *
        FROM main.results
        WHERE attestation_date < $1 and success_state = true
      ) AS r
      WHERE r.employee_id IN (
        SELECT
          employee_id
        FROM
          main.employees
        WHERE
          hire_date BETWEEN $1 AND $2
      )
    )
  ) AS unrelated_educations
FROM
  (
    SELECT *
    FROM main.results
    WHERE attestation_date < $1 and success_state = true
  ) AS r
WHERE
  r.employee_id IN (
    SELECT
      employee_id
    FROM
      main.employees
    WHERE
      hire_date BETWEEN $1 AND $2
  );
END
$function$ LANGUAGE plpgsql;'


psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.results_same_qualification()
  RETURNS TABLE
  (qualification_id INTEGER,
  employee_id INTEGER,
  specialty_id INTEGER,
  rank INTEGER,
  category INTEGER)
AS $function$
BEGIN
SELECT
  qualification_id
  employee_id,
  specialty_id,
  rank
  category
FROM main.qualification
WHERE employee_id = ANY (
	SELECT
	  employee_id
	FROM
	  main.results AS r
	INNER JOIN main.education as ed
	ON r.designated_education = ed.education_id
	WHERE
		prev_qualification = new_qualification
);
END
$function$ LANGUAGE plpgsql;'


psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.no_results()
  RETURNS TABLE
  (
    employee_id INTEGER,
    edu_count INTEGER,
    edu_days TEXT,
    edu_results_count INTEGER
  )
AS $function$
BEGIN
SELECT
  empl.employee_id,
  count(education_id) as edu_count,
  array_agg(education_date) edu_days,
  count(designated_education) as edu_results_count
FROM
  main.employees AS empl
  LEFT OUTER JOIN
    main.education AS edu
  ON empl.employee_id = edu.employee_id
  LEFT OUTER JOIN
    main.results AS res
  ON edu.education_id = res.designated_education
GROUP BY empl.employee_id
HAVING count(designated_education) <> count(education_id);
END
$function$ LANGUAGE plpgsql;'


psql -U postgres -d technical_training_department -c 'CREATE OR REPLACE FUNCTION main.wrong_results()
  RETURNS TABLE
  (
    employee_id INTEGER,
    full_name TEXT,
    errors INTEGER
  )
AS $function$
BEGIN
select
  employee_id,
  full_name,
  count(
  	case when status = '\''SOMETHING WRONG'\''
  	  then 1
  	  else null
  	end
  	) as errors
from
  (
  	select
  	  empl.employee_id,
  	  full_name,
  	  birth_date,
  	  employment_record,
      hire_date,
      education_id,
      schedule,
      results_count,
      result_id,
      prev_qualification,
      attestation_date,
      success_state,
      new_qualification,
  	  case when ((EXTRACT(YEAR from age(birth_date)) > 18) and ((result_id is null) or (success_state = false)))
  	    then '\''SOMETHING WRONG'\''
  	    else '\''OK'\''
  	  end as status
	FROM
	  main.employees AS empl
	  LEFT OUTER JOIN
	    main.education AS edu
	  ON empl.employee_id = edu.employee_id
	  LEFT OUTER JOIN
	    main.results AS res
	  ON edu.education_id = res.designated_education
  	) as mid
group by employee_id, full_name;
END
$function$ LANGUAGE plpgsql;'



psql -U postgres -d technical_training_department -c 'CREATE INDEX CONCURRENTLY employee_id_index ON main.employees (employee_id);'
psql -U postgres -d technical_training_department -c 'CREATE INDEX CONCURRENTLY result_id_index ON main.results (result_id);'
psql -U postgres -d technical_training_department -c 'CREATE INDEX CONCURRENTLY qualification_id_index ON main.qualification (qualification_id);'
psql -U postgres -d technical_training_department -c 'CREATE INDEX CONCURRENTLY specialty_id_index ON main.specialties (specialty_id);'
psql -U postgres -d technical_training_department -c 'CREATE INDEX CONCURRENTLY education_id_index ON main.education (education_id);'


psql -U postgres -d technical_training_department -c '\du'
psql -U postgres -d technical_training_department -c '\dn'
psql -U postgres -d technical_training_department -c '\list'
#psql -U postgres -c '\connect database_name'

DECLARE
	объявление переменных
	объявление курсора
BEGIN
     открытие курсора
	перебор данных и операции над ними
     закрытие курсора
     RETURN возвращение значения;
END;
