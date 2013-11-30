--Declare the controller package of the application
CREATE OR REPLACE PACKAGE locations_crud_controller
AS

  --CRUD for locations entity
  PROCEDURE create_location(
    street_address varchar2,
    postal_code varchar2,
    city varchar2,
    state_province varchar2,
    country_id varchar2
  );
  PROCEDURE update_location(
    p_location_id varchar2,
    p_street_address varchar2,
    p_postal_code varchar2,
    p_city varchar2,
    p_state_province varchar2,
    p_country_id varchar2
  );
  PROCEDURE delete_location(
    p_location_id varchar2
    );

END;
/

--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY locations_crud_controller
AS

  --Create new location
  PROCEDURE create_location(
    street_address varchar2,
    postal_code varchar2,
    city varchar2,
    state_province varchar2,
    country_id varchar2
  )
  AS
  BEGIN

    INSERT INTO locations 
    VALUES ((SELECT MAX(location_id) + 1 FROM locations),
      street_address,
      postal_code,
      city,
      state_province,
      country_id);

    COMMIT;

    locations_crud_view.read_locations;
    HTP.PRINT('
      <script>
        window.location.href="locations_crud_view.read_locations";
        alert("Successfully created new location.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      locations_crud_view.create_location;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');
  END create_location;

  --Update details of location
  PROCEDURE update_location(
    p_location_id varchar2,
    p_street_address varchar2,
    p_postal_code varchar2,
    p_city varchar2,
    p_state_province varchar2,
    p_country_id varchar2
  )
  AS
  BEGIN

    UPDATE locations
    SET street_address = p_street_address, 
      postal_code = p_postal_code,
      city = p_city,
      state_province = p_state_province,
      country_id = p_country_id
    WHERE location_id = p_location_id;

    COMMIT;

    locations_crud_view.read_locations;
    HTP.PRINT('
      <script>
        window.location.href="locations_crud_view.read_locations";
        alert("Successfully updated location''s details.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      locations_crud_view.update_location(p_location_id);
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');

  END update_location;

  --Deletes an employee from employee entity
  PROCEDURE delete_location(
    p_location_id varchar2
    )
  AS
  BEGIN

    DELETE FROM locations
    WHERE location_id = p_location_id;

    COMMIT;

    locations_crud_view.read_locations;
    HTP.PRINT('
      <script>
        window.location.href="locations_crud_view.read_locations";
        alert("Successfully deleted location.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      locations_crud_view.read_locations;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');


  END delete_location;

END;
/

SHOW ERRORS
