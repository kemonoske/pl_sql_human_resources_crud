--Declare the controller package of the application
CREATE OR REPLACE PACKAGE job_history_crud_controller
AS

  --CRUD for job history entity

  PROCEDURE create_job_history(
    p_employee_id varchar2,
    p_start_date varchar2,
    p_end_date varchar2,
    p_job_id varchar2,
    p_department_id varchar2
  );

  PROCEDURE update_job_history(
    p_employee_id varchar2,
    p_start_date varchar2,
    p_end_date varchar2,
    p_job_id varchar2,
    p_department_id varchar2
  );

  PROCEDURE delete_job_history(
    p_employee_id varchar2,
    p_start_date varchar2
    );

END;
/


--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY job_history_crud_controller
AS

  --Create new employee
  PROCEDURE create_job_history(
    p_employee_id varchar2,
    p_start_date varchar2,
    p_end_date varchar2,
    p_job_id varchar2,
    p_department_id varchar2
  )
  AS
    job_hist job_history%ROWTYPE;
    employee employees%ROWTYPE;
    department departments%ROWTYPE;
    job jobs%ROWTYPE;
    duplicate BOOLEAN;
    today DATE;
  BEGIN
    --Check for mandatory fields
    IF p_employee_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'Job history must have an employee.');
    ELSIF p_start_date IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'Job history must have a start_date.');
    ELSIF p_end_date IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'Job job_history must have a end_date.');
    END IF;


    IF crud_validator.is_valid_date_format(p_start_date, 'DD.MM.YYYY') IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'Start date has invalid format,  it shold look like: "DD.MM.YYYY".');
    ELSIF crud_validator.is_valid_date_format(p_end_date, 'DD.MM.YYYY') IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'End date has invalid format,  it shold look like: "DD.MM.YYYY".');
    END IF;

    BEGIN
      SELECT * INTO employee FROM employees WHERE employee_id = p_employee_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'No employee with such id.');
    END;

    BEGIN
      SELECT * INTO department FROM departments WHERE department_id = p_department_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20019, 'No department with such id, please refresh the page and try again.');
    END;

    BEGIN
      SELECT * INTO job FROM jobs WHERE job_id = p_job_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20019, 'No job with such id, please refresh the page and try again.');
    END;

    duplicate := TRUE;
    BEGIN
      SELECT * INTO job_hist FROM job_history WHERE employee_id = p_employee_id AND start_date = TO_DATE(p_start_date, 'DD.MM.YYYY');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        duplicate := FALSE;
    END;

    IF duplicate THEN
      RAISE_APPLICATION_ERROR(-20019, 'There is already a job history for this employee with such start date.');
    END IF;

    IF TO_DATE(p_start_date, 'DD.MM.YYYY') >= TO_DATE(p_end_date, 'DD.MM.YYYY')  THEN
      RAISE_APPLICATION_ERROR(-20019, 'End date should be bigger than end date.');
    END IF;

    INSERT INTO job_history 
    VALUES (p_employee_id,
      TO_DATE(p_start_date, 'DD.MM.YYYY'),
      TO_DATE(p_end_date, 'DD.MM.YYYY'),
      p_job_id,
      p_department_id);

    COMMIT;

    job_history_crud_view.read_job_history;
    HTP.PRINT('
      <script>
        window.location.href="job_history_crud_view.read_job_history";
        alert("Successfully created new job history.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
    job_history_crud_view.create_job_history;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');
  END create_job_history;

  --Update details of job history
  PROCEDURE update_job_history(
    p_employee_id varchar2,
    p_start_date varchar2,
    p_end_date varchar2,
    p_job_id varchar2,
    p_department_id varchar2
  )
  AS
    job_hist job_history%ROWTYPE;
    employee employees%ROWTYPE;
    department departments%ROWTYPE;
    job jobs%ROWTYPE;
  BEGIN

    -- --Check for mandatory fields
    -- IF p_employee_id IS NULL THEN
    --   RAISE_APPLICATION_ERROR(-20002, 'Job history must have an employee.');
    -- ELSIF p_start_date IS NULL THEN
    --   RAISE_APPLICATION_ERROR(-20003, 'Job history must have a start_date.');
    -- ELSIF p_end_date IS NULL THEN
    --   RAISE_APPLICATION_ERROR(-20003, 'Job job_history must have a end_date.');
    -- END IF;

    -- IF NOT crud_validator.is_valid_date_format(p_start_date, 'DD.MM.YYYY') THEN
    --   RAISE_APPLICATION_ERROR(-20003, 'Start date has invalid format,  it shold look like: "DD.MM.YYYY".');
    -- ELSIF NOT crud_validator.is_valid_date_format(p_end_date, 'DD.MM.YYYY') THEN
    --   RAISE_APPLICATION_ERROR(-20003, 'End date has invalid format,  it shold look like: "DD.MM.YYYY".');
    -- END IF;

    -- IF p_employee_id IS NOT NULL AND p_start_date IS NOT NULL THEN
    --   BEGIN
    --     SELECT * INTO  FROM job_history WHERE employee_id = p_employee_id AND start_date = p_start_date;
    --   EXCEPTION
    --     WHEN NO_DATA_FOUND THEN
    --       RAISE_APPLICATION_ERROR(-20020, 'No Job History with such id.');
    --   END;
    -- END IF;

    -- BEGIN
    --   SELECT * INTO employee FROM employees WHERE employee_id = p_employee_id;
    -- EXCEPTION
    --   WHEN NO_DATA_FOUND THEN
    --     RAISE_APPLICATION_ERROR(-20010, 'No employee with such id.');
    -- END;

    -- BEGIN
    --   SELECT * INTO department FROM departments WHERE department_id = p_department_id;
    -- EXCEPTION
    --   WHEN NO_DATA_FOUND THEN
    --     RAISE_APPLICATION_ERROR(-20019, 'No department with such id, please refresh the page and try again.');
    -- END;

    -- BEGIN
    --   SELECT * INTO job FROM jobs WHERE job_id = p_job_id;
    -- EXCEPTION
    --   WHEN NO_DATA_FOUND THEN
    --     RAISE_APPLICATION_ERROR(-20019, 'No job with such id, please refresh the page and try again.');
    -- END;

    UPDATE job_history
    SET start_date = TO_DATE(p_start_date, 'DD.MM.YYYY'), 
      end_date = TO_DATE(p_end_date, 'DD.MM.YYYY'), 
      job_id = p_job_id,
      department_id = p_department_id
    WHERE employee_id = p_employee_id AND start_date = TO_DATE(p_start_date, 'DD.MM.YYYY');

    COMMIT;

    job_history_crud_view.read_job_history;
    HTP.PRINT('
      <script>
        window.location.href="job_history_crud_view.read_job_history";
        alert("Successfully updated job history''s details.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      job_history_crud_view.update_job_history(p_employee_id, p_start_date);
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');

  END update_job_history;

  --Deletes an employee from employee entity
  PROCEDURE delete_job_history(
    p_employee_id varchar2,
    p_start_date varchar2
    )
  AS
  BEGIN

    DELETE FROM job_history
    WHERE employee_id = p_employee_id AND start_date = TO_DATE(p_start_date, 'DD.MM.YYYY');

    COMMIT;

    job_history_crud_view.read_job_history;
    HTP.PRINT('
      <script>
        window.location.href="job_history_crud_view.read_job_history";
        alert("Successfully deleted job history.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      job_history_crud_view.read_job_history;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');


  END delete_job_history;

END;
/

SHOW ERRORS
