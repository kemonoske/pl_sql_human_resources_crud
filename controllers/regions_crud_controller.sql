--Declare the controller package of the application
CREATE OR REPLACE PACKAGE regions_crud_controller
AS

  --CRUD for regions entity
  PROCEDURE create_region(
    region_name varchar2
  );
  PROCEDURE update_region(
    p_region_id varchar2,
    p_region_name varchar2
  );
  PROCEDURE delete_region(
    p_region_id varchar2
    );

END;
/

--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY regions_crud_controller
AS

  --Create new region
  PROCEDURE create_region(
    region_name varchar2
  )
  AS
  BEGIN

    INSERT INTO regions 
    VALUES ((SELECT MAX(region_id) + 1 FROM regions),
      region_name);

    COMMIT;

    regions_crud_view.read_regions;
    HTP.PRINT('
      <script>
        window.location.href="regions_crud_view.read_regions";
        alert("Successfully created new region.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      regions_crud_view.create_region;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');
  END create_region;

  --Update details of region
  PROCEDURE update_region(
    p_region_id varchar2,
    p_region_name varchar2
  )
  AS
  BEGIN

    UPDATE regions
    SET region_name = p_region_name
    WHERE region_id = p_region_id;

    COMMIT;

    regions_crud_view.read_regions;
    HTP.PRINT('
      <script>
        window.location.href="regions_crud_view.read_regions";
        alert("Successfully updated region''s details.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      regions_crud_view.update_region(p_region_id);
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');

  END update_region;

  --Deletes an employee from employee entity
  PROCEDURE delete_region(
    p_region_id varchar2
    )
  AS
  BEGIN

    DELETE FROM regions
    WHERE region_id = p_region_id;

    COMMIT;

    regions_crud_view.read_regions;
    HTP.PRINT('
      <script>
        window.location.href="regions_crud_view.read_regions";
        alert("Successfully deleted region.");
      </script>');

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      regions_crud_view.read_regions;
      HTP.PRINT('
        <script >
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
          window.history.back(-1);
        </script>');


  END delete_region;

END;
/

SHOW ERRORS
