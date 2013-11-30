--Declare the controller package of the application
CREATE OR REPLACE PACKAGE jobs_crud_controller
AS

  --CRUD for jobs entity
  PROCEDURE create_job(
    p_job_id varchar2,
    p_job_title varchar2,
    p_min_salary varchar2,
    p_max_salary varchar2
  );
  PROCEDURE update_job(
    p_job_id varchar2,
    p_job_title varchar2 default null,
    p_min_salary varchar2 default null,
    p_max_salary varchar2 default null
  );
  PROCEDURE delete_job(
    p_job_id varchar2
    );

END;
/

--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY jobs_crud_controller
AS

  --Create new job
  PROCEDURE create_job(
    p_job_id varchar2,
    p_job_title varchar2,
    p_min_salary varchar2,
    p_max_salary varchar2
  )
  AS
    job jobs%ROWTYPE;
    duplicate BOOLEAN;
  BEGIN
    --Check for mandatory fields
    IF p_job_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'Job must have an id.');
    ELSIF p_job_title IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'Job must have a title.');
    ELSIF p_min_salary IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'Job must have a min salary.');
    ELSIF p_max_salary IS NULL THEN
      RAISE_APPLICATION_ERROR(-20004, 'Job must have a max salary.');
    END IF;


    IF NOT crud_validator.is_number(p_min_salary) THEN
      RAISE_APPLICATION_ERROR(-20002, 'Min salary should be a number.');
    ELSIF NOT crud_validator.is_number(p_max_salary) THEN
      RAISE_APPLICATION_ERROR(-20002, 'Max salary should be a number.');
    END IF;

    duplicate := TRUE;
    BEGIN
      SELECT * INTO job FROM jobs WHERE job_id = p_job_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        duplicate := FALSE;
    END;

    IF duplicate THEN
      RAISE_APPLICATION_ERROR(-20019, 'There is already a job with such id.');
    END IF;

    duplicate := TRUE;
    BEGIN
      SELECT * INTO job FROM jobs WHERE job_title = p_job_title;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        duplicate := FALSE;
    END;

    IF duplicate THEN
      RAISE_APPLICATION_ERROR(-20019, 'There is already a job with such title.');
    END IF;


    INSERT INTO jobs 
    VALUES (p_job_id,
      p_job_title, 
      p_min_salary,
      p_max_salary);

    COMMIT;

    jobs_crud_view.read_jobs;
    HTP.PRINT('
      <script>
        window.location.href="jobs_crud_view.read_jobs";
        alert("Successfully created new job.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      jobs_crud_view.create_job;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');
  END create_job;

  --Update details of job
  PROCEDURE update_job(
    p_job_id varchar2,
    p_job_title varchar2 default null,
    p_min_salary varchar2 default null,
    p_max_salary varchar2 default null
  )
  AS
    job jobs%ROWTYPE;
    duplicate BOOLEAN;
  BEGIN
    --Check if the department_id is valid
    IF p_job_id IS NULL THEN 
      RAISE_APPLICATION_ERROR(-20020, 'You must specify job id.');
    END IF;

    IF p_job_id IS NOT NULL THEN
      BEGIN
        SELECT * INTO job FROM jobs WHERE job_id = p_job_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20020, 'No job with such id.');
      END;
    END IF;
    --Check for mandatory fields
    IF p_job_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'Job must have an id.');
    ELSIF p_job_title IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'Job must have a title.');
    ELSIF p_min_salary IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'Job must have a min salary.');
    ELSIF p_max_salary IS NULL THEN
      RAISE_APPLICATION_ERROR(-20004, 'Job must have a max salary.');
    END IF;


    IF NOT crud_validator.is_number(p_min_salary) THEN
      RAISE_APPLICATION_ERROR(-20002, 'Min salary should be a number.');
    ELSIF NOT crud_validator.is_number(p_max_salary) THEN
      RAISE_APPLICATION_ERROR(-20002, 'Max salary should be a number.');
    END IF;

    duplicate := TRUE;
    BEGIN
      SELECT * INTO job FROM jobs WHERE job_title = p_job_title AND job_id != p_job_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        duplicate := FALSE;
    END;

    IF duplicate THEN
      RAISE_APPLICATION_ERROR(-20019, 'There is already a job with such title.');
    END IF;

    UPDATE jobs
    SET job_title = p_job_title, 
      min_salary = p_min_salary,
      max_salary = p_max_salary
    WHERE job_id = p_job_id;

    COMMIT;

    jobs_crud_view.read_jobs;
    HTP.PRINT('
      <script>
        window.location.href="jobs_crud_view.read_jobs";
        alert("Successfully updated job''s details.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      jobs_crud_view.update_job(p_job_id);
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');

  END update_job;

  --Deletes an job from jobs entity
  PROCEDURE delete_job(
    p_job_id varchar2
    )
  AS
  BEGIN

    DELETE FROM jobs
    WHERE job_id = p_job_id;

    COMMIT;

    jobs_crud_view.read_jobs;
    HTP.PRINT('
      <script>
        window.location.href="jobs_crud_view.read_jobs";
        alert("Successfully deleted job.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      jobs_crud_view.read_jobs;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');


  END delete_job;

END;
/

SHOW ERRORS
