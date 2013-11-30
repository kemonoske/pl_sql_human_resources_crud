--Declare the controller package of the application
CREATE OR REPLACE PACKAGE countries_crud_controller
AS

  --CRUD for countries entity
  PROCEDURE create_country(
    country_id varchar2,
    country_name varchar2,
    region_id varchar2
  );
  PROCEDURE update_country(
    p_country_id varchar2,
    p_country_name varchar2,
    p_region_id varchar2
  );
  PROCEDURE delete_country(
    p_country_id varchar2
    );

END;
/

--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY countries_crud_controller
AS

  --Create new country
  PROCEDURE create_country(
    country_id varchar2,
    country_name varchar2,
    region_id varchar2
  )
  AS
  BEGIN

    INSERT INTO countries 
    VALUES (country_id,
      country_name, 
      region_id);

    COMMIT;

    countries_crud_view.read_countries;
    HTP.PRINT('
      <script>
        window.location.href="countries_crud_view.read_countries";
        alert("Successfully created new country.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      countries_crud_view.create_country;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');
  END create_country;

  --Update details of country
  PROCEDURE update_country(
    p_country_id varchar2,
    p_country_name varchar2,
    p_region_id varchar2
  )
  AS
  BEGIN

    UPDATE countries
    SET country_name = p_country_name, 
      region_id = p_region_id
    WHERE country_id = p_country_id;

    COMMIT;

    countries_crud_view.read_countries;
    HTP.PRINT('
      <script>
        window.location.href="countries_crud_view.read_countries";
        alert("Successfully updated country''s details.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      countries_crud_view.update_country(p_country_id);
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');

  END update_country;

  --Deletes an employee from employee entity
  PROCEDURE delete_country(
    p_country_id varchar2
    )
  AS

    country countries%ROWTYPE;

  BEGIN
    --Check if the employee_id is valid
    IF p_country_id IS NULL THEN 
      RAISE_APPLICATION_ERROR(-20020, 'You must specify country id.');
    END IF;

    IF p_country_id IS NOT NULL THEN
      BEGIN
        SELECT * INTO country FROM countries WHERE country_id = p_country_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20020, 'No country with such id.');
      END;
    END IF;

    DELETE FROM countries
    WHERE country_id = p_country_id;

    COMMIT;

    countries_crud_view.read_countries;
    HTP.PRINT('
      <script>
        window.location.href="countries_crud_view.read_countries";
        alert("Successfully deleted country.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      countries_crud_view.read_countries;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
        window.location.href="countries_crud_view.read_countries";
        </script>');


  END delete_country;

END;
/

SHOW ERRORS
