--Declare the view package of the application
CREATE OR REPLACE PACKAGE departments_crud_view
AS
  --Views for department entity
  PROCEDURE create_department;
  PROCEDURE read_departments;
  PROCEDURE update_department(
    p_department_id varchar2
    );

END;
/

--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY departments_crud_view
AS

  --Return a list of all departments
  PROCEDURE read_departments
  AS
  BEGIN

    HTP.HTMLOPEN;

      HTP.PRINT('<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">');

      HTP.HEADOPEN;

        hr_crud_view.stylize;

      HTP.HEADCLOSE;

      HTP.BODYOPEN;

        HTP.DIV(cattributes => 'class = "container" style = "width:1280px;"');

          hr_crud_view.header;

          HTP.HEADER(3, '<span>Detartments</span>');

          HTP.DIV(cattributes => 'class = "button-wrapper"');
                
            HTP.ANCHOR('departments_crud_view.create_department', 'Add', cattributes => 'class = "button light"');

          HTP.PRINT('</DIV>
            </BR>');

          HTP.CENTEROPEN;

            HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:auto;display:inline-block"');

              HTP.TABLEOPEN;

                HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                  HTP.TABLEHEADER('Id', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Name', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Manager', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Location', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Remove', cattributes => 'class = "table-header light"');

                HTP.TABLEROWCLOSE;

                FOR REC IN (SELECT department_id,
                department_name,
                (SELECT first_name || ' ' || last_name FROM employees WHERE employee_id = departments.manager_id) AS manager_id,
                (SELECT postal_code || ', ' || 
                  street_address || ', ' || 
                  city || ', ' || 
                  state_province || ', ' || 
                  (SELECT country_name FROM countries WHERE country_id = locations.country_id) 
                  FROM locations WHERE location_id = departments.location_id) AS location_id
                 FROM departments ORDER BY department_id) LOOP
                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA(HTF.ANCHOR('departments_crud_view.update_department?p_department_id=' || REC.DEPARTMENT_ID, REC.DEPARTMENT_ID));
                    HTP.TABLEDATA(REC.DEPARTMENT_NAME);
                    HTP.TABLEDATA(REC.MANAGER_ID);
                    HTP.TABLEDATA(REC.LOCATION_ID);
                    HTP.TABLEDATA('

                      <DIV class = "button-wrapper" style = "width:70;height:auto;">

                      ' ||
                      HTF.ANCHOR('departments_crud_controller.delete_department?p_department_id=' || REC.DEPARTMENT_ID, 'Delete', cattributes => 'class = "button strawberry" style = "width:70;height:auto;"') ||
                      '
                      </DIV>

                      ');

                  HTP.TABLEROWCLOSE;
                END LOOP;

              HTP.TABLECLOSE;

            HTP.PRINT('</DIV>');

            HTP.CENTERCLOSE;

          hr_crud_view.footer;

        HTP.PRINT('</DIV>');

      HTP.BODYCLOSE;

    HTP.HTMLCLOSE;

  END read_departments;

  --Create department
  PROCEDURE create_department
  AS
  BEGIN

    HTP.HTMLOPEN;

      HTP.PRINT('<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">');

      HTP.HEADOPEN;

        hr_crud_view.stylize;

      HTP.HEADCLOSE;

      HTP.BODYOPEN;

        HTP.DIV(cattributes => 'class = "container" style = "width:1280px;"');

          hr_crud_view.header;

          HTP.HEADER(3, '<span>Create new department</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('departments_crud_controller.create_department', cattributes => 'id = "form"'); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Name', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_department_name', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Manager', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_manager_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR REC IN (SELECT * FROM employees ORDER BY employee_id) LOOP

                          HTP.FORMSELECTOPTION(REC.FIRST_NAME || ' ' || REC.LAST_NAME, cattributes => 'class = "dropdown-option" value = "' || REC.EMPLOYEE_ID || '"');

                        END LOOP;

                      HTP.FORMSELECTCLOSE;

                    HTP.PRINT('</td>');

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Location', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_location_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR REC IN (SELECT * FROM locations ORDER BY location_id) LOOP

                          HTP.FORMSELECTOPTION(REC.STREET_ADDRESS || ', ' || REC.CITY || ', ' || REC.POSTAL_CODE, cattributes => 'class = "dropdown-option" value = "' || REC.LOCATION_ID || '"');

                        END LOOP;

                      HTP.FORMSELECTCLOSE;

                    HTP.PRINT('</td>');

                  HTP.TABLEROWCLOSE;

                HTP.TABLECLOSE;

              HTP.PRINT('</DIV>');

              HTP.DIV(cattributes => 'class = "button-wrapper"');
                
                HTP.ANCHOR('#', 'Save', cattributes => 'class = "button light" onclick="document.getElementById(''form'').submit();"');

              HTP.PRINT('</DIV>
                </BR>');

            HTP.FORMCLOSE;

          HTP.CENTERCLOSE;

          hr_crud_view.footer;

        HTP.PRINT('</DIV>');

      HTP.BODYCLOSE;

    HTP.HTMLCLOSE;

  END create_department;

  --Update department
  PROCEDURE update_department(
    p_department_id varchar2
    )
  AS
  
  rec departments%ROWTYPE;
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

    SELECT * 
    INTO rec
    FROM departments
    WHERE department_id = p_department_id;

    HTP.HTMLOPEN;

      HTP.PRINT('<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">');

      HTP.HEADOPEN;

        hr_crud_view.stylize;

      HTP.HEADCLOSE;

      HTP.BODYOPEN;

        HTP.DIV(cattributes => 'class = "container" style = "width:1280px;"');

          hr_crud_view.header;

          HTP.HEADER(3, '<span>Update department details</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('departments_crud_controller.update_department', cattributes => 'id = "form"'); 

              HTP.FORMHIDDEN('p_department_id', rec.department_id); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Department Name', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_department_name', cvalue => rec.department_name, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;
                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Manager', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_manager_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR manager IN (SELECT * FROM employees ORDER BY employee_id) LOOP

                          IF manager.employee_id = rec.manager_id THEN
                            HTP.FORMSELECTOPTION(manager.FIRST_NAME || ' ' || manager.LAST_NAME, cselected => 'selected', cattributes => 'class = "dropdown-option" value = "' || manager.EMPLOYEE_ID || '"');
                          ELSE
                            HTP.FORMSELECTOPTION(manager.FIRST_NAME || ' ' || manager.LAST_NAME, cattributes => 'class = "dropdown-option" value = "' || manager.EMPLOYEE_ID || '"');
                          END IF;

                        END LOOP;

                      HTP.FORMSELECTCLOSE;

                    HTP.PRINT('</td>');

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Location', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_location_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR location IN (SELECT * FROM locations ORDER BY location_id) LOOP

                          IF location.location_id = rec.location_id THEN
                            HTP.FORMSELECTOPTION(location.STREET_ADDRESS || ', ' || location.CITY || ', ' || location.POSTAL_CODE, cselected => 'selected', cattributes => 'class = "dropdown-option" value = "' || location.LOCATION_ID || '"');
                          ELSE
                            HTP.FORMSELECTOPTION(location.STREET_ADDRESS || ', ' || location.CITY || ', ' || location.POSTAL_CODE, cattributes => 'class = "dropdown-option" value = "' || location.LOCATION_ID || '"');
                          END IF;

                        END LOOP;

                      HTP.FORMSELECTCLOSE;

                    HTP.PRINT('</td>');

                  HTP.TABLEROWCLOSE;

                HTP.TABLECLOSE;

              HTP.PRINT('</DIV>');

              HTP.DIV(cattributes => 'class = "button-wrapper"');
                
                HTP.ANCHOR('#', 'Save', cattributes => 'class = "button light" onclick="document.getElementById(''form'').submit();"');

              HTP.PRINT('</DIV>
                </BR>');

            HTP.FORMCLOSE;

          HTP.CENTERCLOSE;

          hr_crud_view.footer;

        HTP.PRINT('</DIV>');

      HTP.BODYCLOSE;

    HTP.HTMLCLOSE;


  EXCEPTION
    WHEN OTHERS THEN
      departments_crud_view.read_departments;
      HTP.PRINT('
        <script >
          window.location.href="departments_crud_view.read_departments";
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
        </script>');
  END update_department;

END;
/

SHOW ERRORS
