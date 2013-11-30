--Declare the controller package of the application
CREATE OR REPLACE PACKAGE employees_crud_controller
AS

  --CRUD for employees entity

  PROCEDURE create_employee(
    first_name varchar2 default null,
    last_name varchar2 default null,
    email varchar2 default null,
    phone_number varchar2 default null,
    p_job_id varchar2 default null,
    hire_date varchar2 default null,
    salary varchar2 default null,
    commission_pct varchar2 default null,
    p_manager_id varchar2 default null,
    p_department_id varchar2 default null
  );

  PROCEDURE update_employee(
    p_employee_id varchar2 default null,
    p_first_name varchar2 default null,
    p_last_name varchar2 default null,
    p_email varchar2 default null,
    p_phone_number varchar2 default null,
    p_job_id varchar2 default null,
    p_hire_date varchar2 default null,
    p_salary varchar2 default null,
    p_commission_pct varchar2 default null,
    p_manager_id varchar2 default null,
    p_department_id varchar2 default null
  );

  PROCEDURE delete_employee(
    p_employee_id varchar2 default null
    );

END;
/


--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY employees_crud_controller
AS

  --Create new employee
  PROCEDURE create_employee(
    first_name varchar2 default null,
    last_name varchar2 default null,
    email varchar2 default null,
    phone_number varchar2 default null,
    p_job_id varchar2 default null,
    hire_date varchar2 default null,
    salary varchar2 default null,
    commission_pct varchar2 default null,
    p_manager_id varchar2 default null,
    p_department_id varchar2 default null
  )
  AS
    job jobs%ROWTYPE;
    manager employees%ROWTYPE;
    department departments%ROWTYPE;
  BEGIN

    --Check for mandatory fields
    IF first_name IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'Employee must have a first name.');
    ELSIF last_name IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'Employee must have a last name.');
    ELSIF email IS NULL THEN
      RAISE_APPLICATION_ERROR(-20004, 'Employee must have an email.');
    ELSIF p_job_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20005, 'Employee must have a job.');
    ELSIF hire_date IS NULL THEN
      RAISE_APPLICATION_ERROR(-20006, 'Employee must have a hire date.');
    ELSIF salary IS NULL THEN
      RAISE_APPLICATION_ERROR(-20007, 'Employee must have a salary.');
    ELSIF p_department_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20009, 'Employee must have a department.');
    END IF;

    --Validate fields data type
    IF NOT crud_validator.is_number(salary) THEN
      RAISE_APPLICATION_ERROR(-20013, 'Invalid salary received, salary must be a number.');
    ELSIF NOT crud_validator.is_number(commission_pct) THEN
      RAISE_APPLICATION_ERROR(-20014, 'Invalid commission received, commission must be a number.');
    ELSIF NOT crud_validator.is_number(p_department_id) THEN
      RAISE_APPLICATION_ERROR(-20016, 'Invalid department identificator received.');
    ELSIF p_manager_id IS NOT NULL AND NOT crud_validator.is_number(p_manager_id) THEN
      RAISE_APPLICATION_ERROR(-20017, 'Invalid manager identificator received.');
    ELSIF NOT crud_validator.is_valid_date_format(hire_date, 'DD.MM.YYYY') THEN
      RAISE_APPLICATION_ERROR(-20016, 'Invalid hire date format, must be like: "DD.MM.YYYY".');
    ELSIF phone_number IS NOT NULL AND NOT crud_validator.is_phone_number(phone_number) THEN
      RAISE_APPLICATION_ERROR(-20020, 'Invalid phone number format, should contain only numbers and dots.');
    END IF;

    BEGIN
      SELECT * INTO job FROM jobs WHERE jobs.job_id = p_job_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'No job with such id, please refresh the page and try again.');
    END;

    IF p_manager_id IS NOT NULL THEN
      BEGIN
        SELECT * INTO manager FROM employees WHERE employee_id = p_manager_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20010, 'No manager with such id, please refresh the page and try again.');
      END;
    END IF;

    BEGIN
      SELECT * INTO department FROM departments WHERE department_id = p_department_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20019, 'No department with such id, please refresh the page and try again.');
    END;


    IF salary < job.min_salary OR salary > job.max_salary THEN
      RAISE_APPLICATION_ERROR(-20011, 'The salary for an employee who works as a: "' || job.job_title || '" must be in range from: ' || job.min_salary || '$ to: ' || job.max_salary || '$ .');
    END IF;

    INSERT INTO employees 
    VALUES ((SELECT MAX(employee_id) + 1 FROM employees),
      first_name, 
      last_name, 
      email, 
      phone_number, 
      TO_DATE(hire_date, 'DD.MM.YYYY'), 
      p_job_id, 
      salary, 
      commission_pct, 
      p_manager_id,
      p_department_id);

    COMMIT;

    employees_crud_view.read_employees;
    HTP.PRINT('
      <script>
        window.location.href="employees_crud_view.read_employees";
        alert("Successfully created new employee.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      employees_crud_view.create_employee;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');
  END create_employee;

  --Update details of employee
  PROCEDURE update_employee(
    p_employee_id varchar2 default null,
    p_first_name varchar2 default null,
    p_last_name varchar2 default null,
    p_email varchar2 default null,
    p_phone_number varchar2 default null,
    p_job_id varchar2 default null,
    p_hire_date varchar2 default null,
    p_salary varchar2 default null,
    p_commission_pct varchar2 default null,
    p_manager_id varchar2 default null,
    p_department_id varchar2 default null
  )
  AS
    employee employees%ROWTYPE;
    job jobs%ROWTYPE;
    manager employees%ROWTYPE;
    department departments%ROWTYPE;
  BEGIN

    --Check if the employee_id is valid
    IF p_employee_id IS NULL THEN 
      RAISE_APPLICATION_ERROR(-20020, 'You must specify employee id.');
    ELSIF NOT crud_validator.is_number(p_employee_id) THEN
      RAISE_APPLICATION_ERROR(-20020, 'Invalid employee identificator received.');
    END IF;

    IF p_employee_id IS NOT NULL THEN
      BEGIN
        SELECT * INTO employee FROM employees WHERE employee_id = p_employee_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20020, 'No employee with such id.');
      END;
    END IF;

    --Check if employee still exists
    IF NOT crud_validator.is_number(p_employee_id) THEN
      RAISE_APPLICATION_ERROR(-20021, 'Invalid employee identificator received.');
    END IF;

    --Check for mandatory fields
    IF p_first_name IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'Employee must have a first name.');
    ELSIF p_last_name IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'Employee must have a last name.');
    ELSIF p_email IS NULL THEN
      RAISE_APPLICATION_ERROR(-20004, 'Employee must have an email.');
    ELSIF p_job_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20005, 'Employee must have a job.');
    ELSIF p_hire_date IS NULL THEN
      RAISE_APPLICATION_ERROR(-20006, 'Employee must have a hire date.');
    ELSIF p_salary IS NULL THEN
      RAISE_APPLICATION_ERROR(-20007, 'Employee must have a salary.');
    ELSIF p_department_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20009, 'Employee must have a department.');
    END IF;

    --Validate fields data type
    IF NOT crud_validator.is_number(p_salary) THEN
      RAISE_APPLICATION_ERROR(-20013, 'Invalid salary received, salary must be a number.');
    ELSIF NOT crud_validator.is_number(p_commission_pct) THEN
      RAISE_APPLICATION_ERROR(-20014, 'Invalid commission received, commission must be a number.');
    ELSIF NOT crud_validator.is_number(p_department_id) THEN
      RAISE_APPLICATION_ERROR(-20016, 'Invalid department identificator received.');
    ELSIF p_manager_id IS NOT NULL AND NOT crud_validator.is_number(p_manager_id) THEN
      RAISE_APPLICATION_ERROR(-20017, 'Invalid manager identificator received.');
    ELSIF NOT crud_validator.is_valid_date_format(p_hire_date, 'DD.MM.YYYY') THEN
      RAISE_APPLICATION_ERROR(-20016, 'Invalid hire date format, must be like: "DD.MM.YYYY".');
    ELSIF p_phone_number IS NOT NULL AND NOT crud_validator.is_phone_number(p_phone_number) THEN
      RAISE_APPLICATION_ERROR(-20020, 'Invalid phone number format, should contain only numbers and dots.');
    END IF;

    BEGIN
      SELECT * INTO job FROM jobs WHERE jobs.job_id = p_job_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'No job with such id, please refresh the page and try again.');
    END;

    IF p_manager_id IS NOT NULL THEN
      BEGIN
        SELECT * INTO manager FROM employees WHERE employee_id = p_manager_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20010, 'No manager with such id, please refresh the page and try again.');
      END;
    END IF;

    BEGIN
      SELECT * INTO department FROM departments WHERE department_id = p_department_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20019, 'No department with such id, please refresh the page and try again.');
    END;


    IF p_salary < job.min_salary OR p_salary > job.max_salary THEN
      RAISE_APPLICATION_ERROR(-20011, 'The salary for an employee who works as a: "' || job.job_title || '" must be in range from: ' || job.min_salary || '$ to: ' || job.max_salary || '$ .');
    END IF;

    UPDATE employees
    SET first_name = p_first_name, 
      last_name = p_last_name, 
      email = p_email, 
      phone_number = p_phone_number, 
      hire_date = TO_DATE(p_hire_date, 'DD.MM.YYYY'), 
      job_id = p_job_id, 
      salary = p_salary, 
      commission_pct = p_commission_pct, 
      manager_id = p_manager_id,
      department_id = p_department_id
    WHERE employee_id = p_employee_id;

    COMMIT;

    employees_crud_view.read_employees;
    HTP.PRINT('
      <script>
        window.location.href="employees_crud_view.read_employees";
        alert("Successfully updated employee''s details.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      employees_crud_view.update_employee(p_employee_id);
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');

  END update_employee;

  --Deletes an employee from employee entity
  PROCEDURE delete_employee(
    p_employee_id varchar2 default null
    )
  AS

    employee employees%ROWTYPE;

  BEGIN
    --Check if the employee_id is valid
    IF p_employee_id IS NULL THEN 
      RAISE_APPLICATION_ERROR(-20020, 'You must specify employee id.');
    ELSIF NOT crud_validator.is_number(p_employee_id) THEN
      RAISE_APPLICATION_ERROR(-20020, 'Invalid employee identificator received.');
    END IF;

    IF p_employee_id IS NOT NULL THEN
      BEGIN
        SELECT * INTO employee FROM employees WHERE employee_id = p_employee_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20020, 'No employee with such id.');
      END;
    END IF;

    DELETE FROM employees
    WHERE employee_id = p_employee_id;

    COMMIT;

    employees_crud_view.read_employees;
    HTP.PRINT('
      <script>
        window.location.href="employees_crud_view.read_employees";
        alert("Successfully deleted employee.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      employees_crud_view.read_employees;
      HTP.PRINT('
        <script >
          window.location.href="employees_crud_view.read_employees";
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
        </script>');


  END delete_employee;

END;
/

SHOW ERRORS
