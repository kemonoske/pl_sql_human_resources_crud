--Declare the controller package of the application
CREATE OR REPLACE PACKAGE departments_crud_controller
AS

  --CRUD for departments entity
  PROCEDURE create_department(
    p_department_name varchar2,
    p_manager_id varchar2,
    p_location_id varchar2
  );
  PROCEDURE update_department(
    p_department_id varchar2,
    p_department_name varchar2 default null,
    p_manager_id varchar2 default null,
    p_location_id varchar2 default null
  );
  PROCEDURE delete_department(
    p_department_id varchar2
    );

END;
/

--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY departments_crud_controller
AS

  --Create new department
  PROCEDURE create_department(
    p_department_name varchar2,
    p_manager_id varchar2,
    p_location_id varchar2
  )
  AS
    department departments%ROWTYPE;
    manager employees%ROWTYPE;
    location locations%ROWTYPE;
    duplicate BOOLEAN;
  BEGIN
    --Check for mandatory fields
    IF p_department_name IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'Department must have a name.');
    ELSIF p_manager_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'Department must have a manager.');
    ELSIF p_location_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20004, 'Department must have a location.');
    END IF;

    IF p_manager_id IS NOT NULL THEN
      BEGIN
        SELECT * INTO manager FROM employees WHERE employee_id = p_manager_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20010, 'No manager with such id, please refresh the page and try again.');
      END;
    END IF;

    BEGIN
      SELECT * INTO location FROM locations WHERE location_id = p_location_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20019, 'No location with such id, please refresh the page and try again.');
    END;

    duplicate := TRUE;
    BEGIN
      SELECT * INTO department FROM departments WHERE department_name = p_department_name;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        duplicate := FALSE;
    END;

    IF duplicate THEN
      RAISE_APPLICATION_ERROR(-20019, 'There is already a departmnet with such name.');
    END IF;

    INSERT INTO departments 
    VALUES ((SELECT MAX(department_id) + 1 FROM departments),
      p_department_name, 
      p_manager_id,
      p_location_id);

    COMMIT;

    departments_crud_view.read_departments;
    HTP.PRINT('
      <script>
        window.location.href="departments_crud_view.read_departments";
        alert("Successfully created new department.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      departments_crud_view.create_department;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');
  END create_department;

  --Update details of department
  PROCEDURE update_department(
    p_department_id varchar2,
    p_department_name varchar2 default null,
    p_manager_id varchar2 default null,
    p_location_id varchar2 default null
  )
  AS
    department departments%ROWTYPE;
    manager employees%ROWTYPE;
    location locations%ROWTYPE;
    duplicate BOOLEAN;
  BEGIN
    --Check if the department_id is valid
    IF p_department_id IS NULL THEN 
      RAISE_APPLICATION_ERROR(-20020, 'You must specify department id.');
    ELSIF NOT crud_validator.is_number(p_department_id) THEN
      RAISE_APPLICATION_ERROR(-20020, 'Invalid department identificator received.');
    END IF;

    IF p_department_id IS NOT NULL THEN
      BEGIN
        SELECT * INTO department FROM departments WHERE department_id = p_department_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20020, 'No department with such id.');
      END;
    END IF;
    
    --Check for mandatory fields
    IF p_department_name IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'Department must have a name.');
    ELSIF p_manager_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'Department must have a manager.');
    ELSIF p_location_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20004, 'Department must have a location.');
    END IF;

    IF p_manager_id IS NOT NULL THEN
      BEGIN
        SELECT * INTO manager FROM employees WHERE employee_id = p_manager_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20010, 'No manager with such id, please refresh the page and try again.');
      END;
    END IF;

    BEGIN
      SELECT * INTO location FROM locations WHERE location_id = p_location_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20019, 'No location with such id, please refresh the page and try again.');
    END;

    duplicate := TRUE;
    BEGIN
      SELECT * INTO department FROM departments WHERE department_name = p_department_name AND department_id != p_department_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        duplicate := FALSE;
    END;

    IF duplicate THEN
      RAISE_APPLICATION_ERROR(-20019, 'There is already a departmnet with such name.');
    END IF;

    UPDATE departments
    SET department_name = p_department_name, 
      manager_id = p_manager_id,
      location_id = p_location_id
    WHERE department_id = p_department_id;

    COMMIT;

    departments_crud_view.read_departments;
    HTP.PRINT('
      <script>
        window.location.href="departments_crud_view.read_departments";
        alert("Successfully updated department''s details.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      departments_crud_view.update_department(p_department_id);
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');

  END update_department;

  --Deletes an employee from employee entity
  PROCEDURE delete_department(
    p_department_id varchar2
    )
  AS

  department departments%ROWTYPE;

  BEGIN
    --Check if the employee_id is valid
    IF p_department_id IS NULL THEN 
      RAISE_APPLICATION_ERROR(-20020, 'You must specify department id.');
    ELSIF NOT crud_validator.is_number(p_department_id) THEN
      RAISE_APPLICATION_ERROR(-20020, 'Invalid department identificator received.');
    END IF;

    IF p_department_id IS NOT NULL THEN
      BEGIN
        SELECT * INTO department FROM departments WHERE department_id = p_department_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20020, 'No department with such id.');
      END;
    END IF;

    DELETE FROM departments
    WHERE department_id = p_department_id;

    COMMIT;

    departments_crud_view.read_departments;
    HTP.PRINT('
      <script>
        window.location.href="departments_crud_view.read_departments";
        alert("Successfully deleted department.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      departments_crud_view.read_departments;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.location.href="departments_crud_view.read_departments";
        </script>');


  END delete_department;

END;
/

SHOW ERRORS
