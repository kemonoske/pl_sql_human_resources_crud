--Declare the view package of the application
CREATE OR REPLACE PACKAGE hr_crud_view
AS

  --Stylesheet
  PROCEDURE stylize;

  --Web header
  PROCEDURE header;

  --Web footer
  PROCEDURE footer;

END;
/

--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY hr_crud_view
AS

  --Set the default style of html components
  PROCEDURE stylize
  AS
  BEGIN

    HTP.PRINT('

      <meta charset="utf-8"/>
      <title>Human resources CRUD demo</title>
      <link rel="stylesheet" href="http://medialoot.com/preview/css-ui-kit/reset.css" type="text/css"/>
      <link rel="stylesheet" href="http://medialoot.com/preview/css-ui-kit/ml-css-ui-kit.css" type="text/css" title="MediaLoot Designer CSS UI Kit"/>
      <style type="text/css">

        select {
                -webkit-appearance: none;
                -webkit-box-shadow: 
                        inset 0 1px 0 rgba(255, 255, 255, 0.6),
                        0 1px 0 rgba(0, 0, 0, 0.2),
                        0 0 0 1px rgb(150, 150, 150),
                        0 1px 2px rgba(0, 0, 0, 0.25);
                background-position: right center, left top;
                background-repeat: no-repeat, repeat-x;
                background-image:
                        url(''https://raw.github.com/mynameisraj/uikit/master/img/arrow.png''),
                        -webkit-gradient(
                                linear,
                                left top,
                                left bottom,
                                from(rgb(240, 240, 240)),
                                to(rgb(210, 210, 210))
                        );
                border-radius: 3px;
                color: rgb(80, 80, 80);
                font-size: 11px;
                font-weight: bold;
                height: 20px;
                outline: 0;
                padding-left: 6px;
                text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5);
        /* for this page only */
                width: 140px;
                display: block;
        }

      </style>
      <script src="http://medialoot.com/preview/css-ui-kit/css_browser_selector.js" type="text/javascript"></script>  
      <!--[if IE]>
          <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
          <link rel="stylesheet" href="http://medialoot.com/preview/css-ui-kit/ie.css" type="text/css" title="Internet Explorer Styles" />
      <![endif]-->
    ');

  END stylize;

  --Prints web header content
  PROCEDURE header
  AS
  BEGIN

    HTP.HEADER(3, '<span>Entities</span>');

    HTP.CENTEROPEN;

      HTP.ulistOpen(cattributes => 'class = "tabs light"  style = "width:1057px;"');

        HTP.listItem(HTF.ANCHOR('employees_crud_view.read_employees', 'Employees'), cattributes => 'class = "light"');
        HTP.listItem(HTF.ANCHOR('departments_crud_view.read_departments', 'Departments'), cattributes => 'class = "light"');
        HTP.listItem(HTF.ANCHOR('jobs_crud_view.read_jobs', 'Jobs'), cattributes => 'class = "light"');
        HTP.listItem(HTF.ANCHOR('job_history_crud_view.read_job_history', 'Job History'), cattributes => 'class = "light"');
        HTP.listItem(HTF.ANCHOR('locations_crud_view.read_locations', 'Locations'), cattributes => 'class = "light"');
        HTP.listItem(HTF.ANCHOR('countries_crud_view.read_countries', 'Countries'), cattributes => 'class = "light"');
        HTP.listItem(HTF.ANCHOR('regions_crud_view.read_regions', 'Regions'), cattributes => 'class = "light"');

      HTP.ulistClose;

    HTP.CENTERCLOSE;

  END header;

  --Prints web footer contents
  PROCEDURE footer
  AS
  BEGIN

    HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:1280px;"');
    
      HTP.CENTEROPEN;

        HTP.HEADER(5, '© 2013 Bostanica Ion, All rights reserved.');

      HTP.CENTERCLOSE;

    HTP.PRINT('</DIV>');

  END footer;
END;
/

SHOW ERRORS
--Declare the view package of the application
CREATE OR REPLACE PACKAGE countries_crud_view
AS
  --Views for department entity
  PROCEDURE create_country;
  PROCEDURE read_countries;
  PROCEDURE update_country(
    p_country_id varchar2
    );

END;
/

--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY countries_crud_view
AS

  --Return a list of all countries
  PROCEDURE read_countries
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

          HTP.HEADER(3, '<span>Countries</span>');

          HTP.DIV(cattributes => 'class = "button-wrapper"');
                
            HTP.ANCHOR('countries_crud_view.create_country', 'Add', cattributes => 'class = "button light"');

          HTP.PRINT('</DIV>
            </BR>');

          HTP.CENTEROPEN;

            HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:auto;display:inline-block"');

              HTP.TABLEOPEN;

                HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                  HTP.TABLEHEADER('Code', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Name', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Region', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Remove', cattributes => 'class = "table-header light"');

                HTP.TABLEROWCLOSE;

                FOR REC IN (SELECT country_id,
                country_name,
                (SELECT region_name FROM regions WHERE region_id = countries.region_id) AS region_id
                 FROM countries ORDER BY country_id) LOOP
                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA(HTF.ANCHOR('countries_crud_view.update_country?p_country_id=' || REC.COUNTRY_ID, REC.COUNTRY_ID));
                    HTP.TABLEDATA(REC.COUNTRY_NAME);
                    HTP.TABLEDATA(REC.REGION_ID);
                    HTP.TABLEDATA('

                      <DIV class = "button-wrapper" style = "width:70;height:auto;">

                      ' ||
                      HTF.ANCHOR('countries_crud_controller.delete_country?p_country_id=' || REC.COUNTRY_ID, 'Delete', cattributes => 'class = "button strawberry" style = "width:70;height:auto;"') ||
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

  END read_countries;


  --Create country
  PROCEDURE create_country
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

          HTP.HEADER(3, '<span>Create new country</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('countries_crud_controller.create_country', cattributes => 'id = "form"'); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Country Id', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('country_id', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Country Name', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('country_name', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Region', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('region_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR REC IN (SELECT * FROM regions ORDER BY region_id) LOOP

                          HTP.FORMSELECTOPTION(REC.REGION_NAME, cattributes => 'class = "dropdown-option" value = "' || REC.REGION_ID || '"');

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

  END create_country;

  --Update country
  PROCEDURE update_country(
    p_country_id varchar2
    )
  AS
  
  rec countries%ROWTYPE;

  BEGIN

    BEGIN
      SELECT * 
      INTO rec
      FROM countries
      WHERE country_id = p_country_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20020, 'No country with such id.');
    END;

    HTP.HTMLOPEN;

      HTP.PRINT('<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">');

      HTP.HEADOPEN;

        hr_crud_view.stylize;

      HTP.HEADCLOSE;

      HTP.BODYOPEN;

        HTP.DIV(cattributes => 'class = "container" style = "width:1280px;"');

          hr_crud_view.header;

          HTP.HEADER(3, '<span>Update country details</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('countries_crud_controller.update_country', cattributes => 'id = "form"'); 

              HTP.FORMHIDDEN('p_country_id', rec.country_id); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Country Name', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_country_name', cvalue => rec.COUNTRY_NAME, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Region', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_region_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR region IN (SELECT * FROM regions ORDER BY region_id) LOOP

                          IF region.region_id = rec.region_id THEN
                            HTP.FORMSELECTOPTION(region.REGION_NAME, cselected => 'selected', cattributes => 'class = "dropdown-option" value = "' || region.REGION_ID || '"');
                          ELSE
                            HTP.FORMSELECTOPTION(region.REGION_NAME, cattributes => 'class = "dropdown-option" value = "' || region.REGION_ID || '"');
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
      countries_crud_view.read_countries;
      HTP.PRINT('
        <script >
          window.location.href="countries_crud_view.read_countries";
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
        </script>');
  END update_country;

END;
/

SHOW ERRORS
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
--Declare the view package of the application
CREATE OR REPLACE PACKAGE employees_crud_view
AS

  --Views for employee entity
  PROCEDURE create_employee;
  PROCEDURE read_employees;
  PROCEDURE update_employee(
    p_employee_id varchar2
    );

END;
/

--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY employees_crud_view
AS

  --Create new employee
  PROCEDURE create_employee
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

          HTP.HEADER(3, '<span>Create new employee</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('employees_crud_controller.create_employee', cattributes => 'id = "form"'); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('First Name', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('first_name', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Last Name', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('last_name', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Email', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('email', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Phone Number', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('phone_number', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Hire Date', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('hire_date', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Job', cattributes => 'style="vertical-align: middle"');

                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_job_id', cattributes => 'style = "width:255px;height:35px;"');

                        HTP.FORMSELECTOPTION('None', cattributes => 'class = "dropdown-option" value = "" selected = "selected"');

                        FOR REC IN (SELECT * FROM jobs ORDER BY job_id) LOOP

                          HTP.FORMSELECTOPTION(REC.JOB_TITLE, cattributes => 'class = "dropdown-option" value = "' || REC.JOB_ID || '"');

                        END LOOP;

                      HTP.FORMSELECTCLOSE;

                    HTP.PRINT('</td>');

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Salary', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('salary', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Commission', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('commission_pct', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Manager', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_manager_id', cattributes => 'style = "width:255px;height:35px;"');

                        HTP.FORMSELECTOPTION('None', cattributes => 'class = "dropdown-option" value = "" selected = "selected"');

                        FOR REC IN (SELECT * FROM employees ORDER BY employee_id) LOOP

                          HTP.FORMSELECTOPTION(REC.FIRST_NAME || ' ' || REC.LAST_NAME, cattributes => 'class = "dropdown-option" value = "' || REC.EMPLOYEE_ID || '"');

                        END LOOP;

                      HTP.FORMSELECTCLOSE;

                    HTP.PRINT('</td>');

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Department', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_department_id', cattributes => 'style = "width:255px;height:35px;"');

                        HTP.FORMSELECTOPTION('None', cattributes => 'class = "dropdown-option" value = "" selected = "selected"');

                        FOR REC IN (SELECT * FROM departments ORDER BY department_id) LOOP

                          HTP.FORMSELECTOPTION(REC.DEPARTMENT_NAME, cattributes => 'class = "dropdown-option" value = "' || REC.DEPARTMENT_ID || '"');

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


  END create_employee;

  --Return a list of all employees
  PROCEDURE read_employees
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

          HTP.HEADER(3, '<span>Employees</span>');

          HTP.DIV(cattributes => 'class = "button-wrapper"');
                
            HTP.ANCHOR('employees_crud_view.create_employee', 'Add', cattributes => 'class = "button light"');

          HTP.PRINT('</DIV>
            </BR>');

          HTP.CENTEROPEN;

            HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:auto;display:inline-block"');

              HTP.TABLEOPEN;

                HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                  HTP.TABLEHEADER('Id', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('First Name', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Last Name', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Email', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Phone Number', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Hire Date', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Job', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Salary', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Commission', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Manager', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Department', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Remove', cattributes => 'class = "table-header light"');

                HTP.TABLEROWCLOSE;

                FOR REC IN (SELECT employee_id,
                  first_name,
                  last_name,
                  email,
                  phone_number,
                  hire_date,
                  (SELECT job_title FROM jobs WHERE job_id = employees.job_id) AS job_id,
                  salary,
                  commission_pct,
                  (SELECT first_name || ' ' || last_name FROM employees m WHERE m.employee_id = employees.manager_id) AS manager_id,
                  (SELECT department_name FROM departments WHERE department_id = employees.department_id) AS department_id
                   FROM EMPLOYEES ORDER BY EMPLOYEE_ID) LOOP
                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA(HTF.ANCHOR('employees_crud_view.update_employee?p_employee_id=' || REC.EMPLOYEE_ID, REC.EMPLOYEE_ID));
                    HTP.TABLEDATA(REC.FIRST_NAME);
                    HTP.TABLEDATA(REC.LAST_NAME);
                    HTP.TABLEDATA(REC.EMAIL);
                    HTP.TABLEDATA(REC.PHONE_NUMBER);
                    HTP.TABLEDATA(TO_CHAR(REC.HIRE_DATE, 'DD.MM.YYYY'));
                    HTP.TABLEDATA(REC.JOB_ID);
                    HTP.TABLEDATA(REC.SALARY);
                    HTP.TABLEDATA(REC.COMMISSION_PCT);
                    HTP.TABLEDATA(REC.MANAGER_ID);
                    HTP.TABLEDATA(REC.DEPARTMENT_ID);
                    HTP.TABLEDATA('

                      <DIV class = "button-wrapper" style = "width:70;height:auto;">

                      ' ||
                      HTF.ANCHOR('employees_crud_controller.delete_employee?P_EMPLOYEE_ID=' || REC.EMPLOYEE_ID, 'Delete', cattributes => 'class = "button strawberry" style = "width:70;height:auto;"') ||
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

  END read_employees;

  --Update details of employee
  PROCEDURE update_employee(
    p_employee_id varchar2
    )
  AS
  
  rec employees%ROWTYPE;
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

    SELECT * 
    INTO rec
    FROM employees
    WHERE employee_id = p_employee_id;

    HTP.HTMLOPEN;

      HTP.PRINT('<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">');

      HTP.HEADOPEN;

        hr_crud_view.stylize;

      HTP.HEADCLOSE;

      HTP.BODYOPEN;

        HTP.DIV(cattributes => 'class = "container" style = "width:1280px;"');

          hr_crud_view.header;

          HTP.HEADER(3, '<span>Update employee details</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('employees_crud_controller.update_employee', cattributes => 'id = "form"'); 

              HTP.FORMHIDDEN('p_employee_id', rec.employee_id); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('First Name', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_first_name', cvalue => rec.first_name, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Last Name', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_last_name', cvalue => rec.last_name, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Email', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_email', cvalue => rec.email, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Phone Number', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_phone_number', cvalue => rec.phone_number, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Hire Date', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_hire_date', cvalue => TO_CHAR(rec.hire_date, 'DD.MM.YYYY'), cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Job', cattributes => 'style="vertical-align: middle"');

                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_job_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR job IN (SELECT * FROM jobs ORDER BY job_id) LOOP

                          IF job.JOB_ID = rec.JOB_ID THEN
                            HTP.FORMSELECTOPTION(job.JOB_TITLE, cselected => 'selected', cattributes => 'class = "dropdown-option" value = "' || job.JOB_ID || '"');
                          ELSE
                            HTP.FORMSELECTOPTION(job.JOB_TITLE, cattributes => 'class = "dropdown-option" value = "' || job.JOB_ID || '"');
                          END IF;

                        END LOOP;

                      HTP.FORMSELECTCLOSE;

                    HTP.PRINT('</td>');

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Salary', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_salary', cvalue => rec.salary, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Commission', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_commission_pct', cvalue => rec.commission_pct, cattributes => 'class = "search-field"'));

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

                    HTP.TABLEDATA('Department', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_department_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR department IN (SELECT * FROM departments ORDER BY department_id) LOOP

                          IF department.department_id = rec.department_id THEN
                            HTP.FORMSELECTOPTION(department.DEPARTMENT_NAME, cselected => 'selected', cattributes => 'class = "dropdown-option" value = "' || department.DEPARTMENT_ID || '"');
                          ELSE
                            HTP.FORMSELECTOPTION(department.DEPARTMENT_NAME, cattributes => 'class = "dropdown-option" value = "' || department.DEPARTMENT_ID || '"');
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
      employees_crud_view.read_employees;
      HTP.PRINT('
        <script >
          window.location.href="employees_crud_view.read_employees";
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
        </script>');

  END update_employee;


END;
/

SHOW ERRORS
--Declare the view package of the application
CREATE OR REPLACE PACKAGE jobs_crud_view
AS

  -- --Views for job entity
  PROCEDURE create_job;
  PROCEDURE read_jobs;
  PROCEDURE update_job(
    p_job_id varchar2
    );

END;
/


--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY jobs_crud_view
AS

  --Return a list of all jobs
  PROCEDURE read_jobs
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

          HTP.HEADER(3, '<span>Jobs</span>');

          HTP.DIV(cattributes => 'class = "button-wrapper"');
                
            HTP.ANCHOR('jobs_crud_view.create_job', 'Add', cattributes => 'class = "button light"');

          HTP.PRINT('</DIV>
            </BR>');

          HTP.CENTEROPEN;

            HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

              HTP.TABLEOPEN;

                HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                  HTP.TABLEHEADER('Id', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Title', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Min Salary', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Max Salary', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Remove', cattributes => 'class = "table-header light"');

                HTP.TABLEROWCLOSE;

                FOR REC IN (SELECT * FROM jobs ORDER BY job_id) LOOP
                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA(HTF.ANCHOR('jobs_crud_view.update_job?p_job_id=' || REC.JOB_ID, REC.JOB_ID));
                    HTP.TABLEDATA(REC.JOB_TITLE);
                    HTP.TABLEDATA(REC.MIN_SALARY);
                    HTP.TABLEDATA(REC.MAX_SALARY);
                    HTP.TABLEDATA('

                      <DIV class = "button-wrapper" style = "width:70;height:auto;">

                      ' ||
                      HTF.ANCHOR('jobs_crud_controller.delete_job?p_job_id=' || REC.JOB_ID, 'Delete', cattributes => 'class = "button strawberry" style = "width:70;height:auto;"') ||
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

  END read_jobs;


  --Create job
  PROCEDURE create_job
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

          HTP.HEADER(3, '<span>Create new job</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('jobs_crud_controller.create_job', cattributes => 'id = "form"'); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Id', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_job_id', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Title', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_job_title', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Min Salary', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_min_salary', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Max Salary', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_max_salary', cattributes => 'class = "search-field"'));

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

  END create_job;

  --Update details of a job
  PROCEDURE update_job(
    p_job_id varchar2
    )
  AS
  
  rec jobs%ROWTYPE;

  BEGIN

    BEGIN
      SELECT * 
      INTO rec
      FROM jobs
      WHERE job_id = p_job_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20020, 'No job with such id.');
    END;

    HTP.HTMLOPEN;

      HTP.PRINT('<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">');

      HTP.HEADOPEN;

        hr_crud_view.stylize;

      HTP.HEADCLOSE;

      HTP.BODYOPEN;

        HTP.DIV(cattributes => 'class = "container" style = "width:1280px;"');

          hr_crud_view.header;

          HTP.HEADER(3, '<span>Update job details</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('jobs_crud_controller.update_job', cattributes => 'id = "form"'); 

              HTP.FORMHIDDEN('p_job_id', rec.JOB_ID); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Title', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_job_title', cvalue => rec.JOB_TITLE, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Min Salary', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_min_salary', cvalue => rec.MIN_SALARY, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Max Salary', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_max_salary', cvalue => rec.MAX_SALARY, cattributes => 'class = "search-field"'));

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
      jobs_crud_view.read_jobs;
      HTP.PRINT('
        <script >
          window.location.href="jobs_crud_view.read_jobs";
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
        </script>');
  END update_job;

END;
/

SHOW ERRORS
--Declare the view package of the application
CREATE OR REPLACE PACKAGE job_history_crud_view
AS

  -- --Views for job_history entity
  PROCEDURE create_job_history;
  PROCEDURE read_job_history;
  PROCEDURE update_job_history(
     p_employee_id varchar2,
     p_start_date varchar2
     );

END;
/
 
 --Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY job_history_crud_view
AS

  --Return job history
  PROCEDURE read_job_history
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

          HTP.HEADER(3, '<span>Job History</span>');

          HTP.DIV(cattributes => 'class = "button-wrapper"');
                
            HTP.ANCHOR('job_history_crud_view.create_job_history', 'Add', cattributes => 'class = "button light"');

          HTP.PRINT('</DIV>
            </BR>');

          HTP.CENTEROPEN;

            HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:auto;display:inline-block"');

              HTP.TABLEOPEN;

                HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                  HTP.TABLEHEADER('Id', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Start Date', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('End Date', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Job', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Department', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Remove', cattributes => 'class = "table-header light"');

                HTP.TABLEROWCLOSE;

                FOR REC IN (SELECT employee_id,
                start_date,
                end_date,
                (SELECT job_title FROM jobs WHERE job_id = job_history.job_id) AS job_id,
                (SELECT department_name FROM departments WHERE department_id = job_history.department_id) AS department_id
                FROM job_history ORDER BY employee_id) LOOP
                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA(HTF.ANCHOR('job_history_crud_view.update_job_history?p_employee_id=' || REC.EMPLOYEE_ID || chr(38) || 'p_start_date=' || TO_CHAR(REC.START_DATE, 'DD.MM.YYYY'), REC.EMPLOYEE_ID));
                    HTP.TABLEDATA(TO_CHAR(REC.START_DATE, 'DD.MM.YYYY'));
                    HTP.TABLEDATA(TO_CHAR(REC.END_DATE, 'DD.MM.YYYY'));
                    HTP.TABLEDATA(REC.JOB_ID);
                    HTP.TABLEDATA(REC.DEPARTMENT_ID);
                    HTP.TABLEDATA('

                      <DIV class = "button-wrapper" style = "width:70;height:auto;">

                      ' ||
                      HTF.ANCHOR('job_history_crud_controller.delete_job_history?p_employee_id=' || REC.EMPLOYEE_ID || chr(38) || 'p_start_date=' || TO_CHAR(REC.START_DATE, 'DD.MM.YYYY'), 'Delete', cattributes => 'class = "button strawberry" style = "width:70;height:auto;"') ||
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

  END read_job_history;

  --Create new job_history
  PROCEDURE create_job_history
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

          HTP.HEADER(3, '<span>Create new job history</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('job_history_crud_controller.create_job_history', cattributes => 'id = "form"'); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('For Employee', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_employee_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR REC IN (SELECT * FROM employees ORDER BY employee_id) LOOP

                          HTP.FORMSELECTOPTION(REC.FIRST_NAME || ' ' || REC.LAST_NAME, cattributes => 'class = "dropdown-option" value = "' || REC.EMPLOYEE_ID || '"');

                        END LOOP;

                      HTP.FORMSELECTCLOSE;

                    HTP.PRINT('</td>');

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Start Date', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_start_date', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('End Date', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_end_date', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Job', cattributes => 'style="vertical-align: middle"');

                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_job_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR REC IN (SELECT * FROM jobs ORDER BY job_id) LOOP

                          HTP.FORMSELECTOPTION(REC.JOB_TITLE, cattributes => 'class = "dropdown-option" value = "' || REC.JOB_ID || '"');

                        END LOOP;

                      HTP.FORMSELECTCLOSE;

                    HTP.PRINT('</td>');

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Department', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_department_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR REC IN (SELECT * FROM departments ORDER BY department_id) LOOP

                          HTP.FORMSELECTOPTION(REC.DEPARTMENT_NAME, cattributes => 'class = "dropdown-option" value = "' || REC.DEPARTMENT_ID || '"');

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


  END create_job_history;

  --Update details of employee
  PROCEDURE update_job_history(
    p_employee_id varchar2,
    p_start_date varchar2
    )
  AS
  
  rec job_history%ROWTYPE;

  BEGIN

    BEGIN
      SELECT * 
      INTO rec
      FROM job_history
      WHERE employee_id = p_employee_id AND start_date = TO_DATE(p_start_date,'DD.MM.YYYY');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20020, 'No job with such id.');
    END;

    HTP.HTMLOPEN;

      HTP.PRINT('<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">');

      HTP.HEADOPEN;

        hr_crud_view.stylize;

      HTP.HEADCLOSE;

      HTP.BODYOPEN;

        HTP.DIV(cattributes => 'class = "container" style = "width:1280px;"');

          hr_crud_view.header;

          HTP.HEADER(3, '<span>Update job history details</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('job_history_crud_controller.update_job_history', cattributes => 'id = "form"'); 

              HTP.FORMHIDDEN('p_employee_id', rec.employee_id); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Start Date', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_start_date', cvalue => TO_CHAR(rec.start_date, 'DD.MM.YYYY'), cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('End Date', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_end_date', cvalue => TO_CHAR(rec.end_date, 'DD.MM.YYYY'), cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Job', cattributes => 'style="vertical-align: middle"');

                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_job_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR job IN (SELECT * FROM jobs ORDER BY job_id) LOOP

                          IF job.JOB_ID = rec.JOB_ID THEN
                            HTP.FORMSELECTOPTION(job.JOB_TITLE, cselected => 'selected', cattributes => 'class = "dropdown-option" value = "' || job.JOB_ID || '"');
                          ELSE
                            HTP.FORMSELECTOPTION(job.JOB_TITLE, cattributes => 'class = "dropdown-option" value = "' || job.JOB_ID || '"');
                          END IF;

                        END LOOP;

                      HTP.FORMSELECTCLOSE;

                    HTP.PRINT('</td>');

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Department', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_department_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR department IN (SELECT * FROM departments ORDER BY department_id) LOOP

                          IF department.department_id = rec.department_id THEN
                            HTP.FORMSELECTOPTION(department.DEPARTMENT_NAME, cselected => 'selected', cattributes => 'class = "dropdown-option" value = "' || department.DEPARTMENT_ID || '"');
                          ELSE
                            HTP.FORMSELECTOPTION(department.DEPARTMENT_NAME, cattributes => 'class = "dropdown-option" value = "' || department.DEPARTMENT_ID || '"');
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
      job_history_crud_view.read_job_history;
      HTP.PRINT('
        <script >
          window.location.href="job_history_crud_view.read_job_history";
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
        </script>');

  END update_job_history;

END;
/

SHOW ERRORS
--Declare the view package of the application
CREATE OR REPLACE PACKAGE locations_crud_view
AS
  --Views for department entity
  PROCEDURE create_location;
  PROCEDURE read_locations;
  PROCEDURE update_location(
    p_location_id varchar2
    );

END;
/

--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY locations_crud_view
AS

  --Return a list of all locations
  PROCEDURE read_locations
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

          HTP.HEADER(3, '<span>Locations</span>');

          HTP.DIV(cattributes => 'class = "button-wrapper"');
                
            HTP.ANCHOR('locations_crud_view.create_location', 'Add', cattributes => 'class = "button light"');

          HTP.PRINT('</DIV>
            </BR>');

          HTP.CENTEROPEN;

            HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:auto;display:inline-block"');

              HTP.TABLEOPEN;

                HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                  HTP.TABLEHEADER('Id', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Street Address', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Postal Code', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('City', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('State Province', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Country', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Remove', cattributes => 'class = "table-header light"');

                HTP.TABLEROWCLOSE;

                FOR REC IN (SELECT location_id,
                street_address,
                postal_code,
                city,
                state_province,
                (SELECT country_name FROM countries WHERE country_id = locations.country_id) AS country_id
                FROM locations ORDER BY location_id) LOOP
                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA(HTF.ANCHOR('locations_crud_view.update_location?p_location_id=' || REC.LOCATION_ID, REC.LOCATION_ID));
                    HTP.TABLEDATA(REC.STREET_ADDRESS);
                    HTP.TABLEDATA(REC.POSTAL_CODE);
                    HTP.TABLEDATA(REC.CITY);
                    HTP.TABLEDATA(REC.STATE_PROVINCE);
                    HTP.TABLEDATA(REC.COUNTRY_ID);
                    HTP.TABLEDATA('

                      <DIV class = "button-wrapper" style = "width:70;height:auto;">

                      ' ||
                      HTF.ANCHOR('locations_crud_controller.delete_location?p_location_id=' || REC.LOCATION_ID, 'Delete', cattributes => 'class = "button strawberry" style = "width:70;height:auto;"') ||
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

  END read_locations;

  --Create location
  PROCEDURE create_location
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

          HTP.HEADER(3, '<span>Create new location</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('locations_crud_controller.create_location', cattributes => 'id = "form"'); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Street Address', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('street_address', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Postal Code', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('postal_code', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('City', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('city', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('State Province', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('state_province', cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Country', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('country_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR REC IN (SELECT * FROM countries ORDER BY country_id) LOOP

                          HTP.FORMSELECTOPTION(REC.COUNTRY_NAME, cattributes => 'class = "dropdown-option" value = "' || REC.COUNTRY_ID || '"');

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

  END create_location;

  --Update department
  PROCEDURE update_location(
    p_location_id varchar2
    )
  AS
  
  rec locations%ROWTYPE;

  BEGIN

    BEGIN
      SELECT * 
      INTO rec
      FROM locations
      WHERE location_id = p_location_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20020, 'No location with such id.');
    END;

    HTP.HTMLOPEN;

      HTP.PRINT('<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">');

      HTP.HEADOPEN;

        hr_crud_view.stylize;

      HTP.HEADCLOSE;

      HTP.BODYOPEN;

        HTP.DIV(cattributes => 'class = "container" style = "width:1280px;"');

          hr_crud_view.header;

          HTP.HEADER(3, '<span>Update location details</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('locations_crud_controller.update_location', cattributes => 'id = "form"'); 

              HTP.FORMHIDDEN('p_location_id', rec.location_id); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Street Address', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_street_address', cvalue => rec.STREET_ADDRESS, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Postal Code', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_postal_code', cvalue => rec.POSTAL_CODE, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('City', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_city', cvalue => rec.CITY, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('State Province', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_state_province', cvalue => rec.STATE_PROVINCE, cattributes => 'class = "search-field"'));

                  HTP.TABLEROWCLOSE;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Country', cattributes => 'style="vertical-align: middle"');
                    HTP.PRINT('<td>');

                      HTP.FORMSELECTOPEN('p_country_id', cattributes => 'style = "width:255px;height:35px;"');


                        FOR country IN (SELECT * FROM countries ORDER BY country_id) LOOP

                          IF rec.country_id = country.country_id THEN
                            HTP.FORMSELECTOPTION(country.COUNTRY_NAME, cselected => 'selected', cattributes => 'class = "dropdown-option" value = "' || country.COUNTRY_ID || '"');
                          ELSE
                            HTP.FORMSELECTOPTION(country.COUNTRY_NAME, cattributes => 'class = "dropdown-option" value = "' || country.COUNTRY_ID || '"');
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
      locations_crud_view.read_locations;
      HTP.PRINT('
        <script >
          window.location.href="locations_crud_view.read_locations";
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
        </script>');

  END update_location;

END;
/

SHOW ERRORS
--Declare the view package of the application
CREATE OR REPLACE PACKAGE regions_crud_view
AS
  --Views for department entity
  PROCEDURE create_region;
  PROCEDURE read_regions;
  PROCEDURE update_region(
    p_region_id varchar2
    );

END;
/

--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY regions_crud_view
AS

  --Return regions
  PROCEDURE read_regions
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

          HTP.HEADER(3, '<span>Regions</span>');

          HTP.DIV(cattributes => 'class = "button-wrapper"');
                
            HTP.ANCHOR('regions_crud_view.create_region', 'Add', cattributes => 'class = "button light"');

          HTP.PRINT('</DIV>
            </BR>');

          HTP.CENTEROPEN;

            HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

              HTP.TABLEOPEN;

                HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                  HTP.TABLEHEADER('Id', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Name', cattributes => 'class = "table-header light"');
                  HTP.TABLEHEADER('Remove', cattributes => 'class = "table-header light"');

                HTP.TABLEROWCLOSE;

                FOR REC IN (SELECT * FROM regions ORDER BY region_id) LOOP
                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA(HTF.ANCHOR('regions_crud_view.update_region?p_region_id=' || REC.REGION_ID, REC.REGION_ID));
                    HTP.TABLEDATA(REC.REGION_NAME);
                    HTP.TABLEDATA('

                      <DIV class = "button-wrapper" style = "width:70;height:auto;">

                      ' ||
                      HTF.ANCHOR('regions_crud_controller.delete_region?p_region_id=' || REC.REGION_ID, 'Delete', cattributes => 'class = "button strawberry" style = "width:70;height:auto;"') ||
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

  END read_regions;

  --Create region
  PROCEDURE create_region
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

          HTP.HEADER(3, '<span>Create new region</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('regions_crud_controller.create_region', cattributes => 'id = "form"'); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;
                
                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Region Name', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('region_name', cattributes => 'class = "search-field"'));

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

  END create_region;

  --Update region
  PROCEDURE update_region(
    p_region_id varchar2
    )
  AS
  
  rec regions%ROWTYPE;

  BEGIN

    BEGIN
      SELECT * 
      INTO rec
      FROM regions
      WHERE region_id = p_region_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20020, 'No region with such id.');
    END;

    HTP.HTMLOPEN;

      HTP.PRINT('<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">');

      HTP.HEADOPEN;

        hr_crud_view.stylize;

      HTP.HEADCLOSE;

      HTP.BODYOPEN;

        HTP.DIV(cattributes => 'class = "container" style = "width:1280px;"');

          hr_crud_view.header;

          HTP.HEADER(3, '<span>Update region details</span>');

          HTP.CENTEROPEN;

            HTP.FORMOPEN('regions_crud_controller.update_region', cattributes => 'id = "form"'); 

              HTP.FORMHIDDEN('p_region_id', rec.region_id); 
            
              HTP.DIV(cattributes => 'class = "table-wrapper" style = "width:460px;"');

                HTP.TABLEOPEN;

                  HTP.TABLEROWOPEN(cattributes => 'class = "table-row"');

                    HTP.TABLEDATA('Region Name', cattributes => 'style="vertical-align: middle"');
                    HTP.TABLEDATA(HTF.FORMTEXT('p_region_name', cvalue => rec.region_name, cattributes => 'class = "search-field"'));

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
      regions_crud_view.read_regions;
      HTP.PRINT('
        <script >
          window.location.href="regions_crud_view.read_regions";
          alert("An error was encountered - ' || REPLACE(SQLERRM, '"', '\"') || '.");
        </script>');
  END update_region;

END;
/

SHOW ERRORS
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
    -- job_hist job_history%ROWTYPE;
    -- employee employees%ROWTYPE;
    -- department departments%ROWTYPE;
    -- job jobs%ROWTYPE;
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
--Declare the controller package of the application
CREATE OR REPLACE PACKAGE crud_validator
AS

  FUNCTION is_valid_date_format ( p_date IN VARCHAR2,
      p_format IN VARCHAR2 ) 
  RETURN BOOLEAN;

  FUNCTION is_number( p_str IN VARCHAR2 )
    RETURN BOOLEAN;

  FUNCTION is_phone_number( p_str IN VARCHAR2 )
    RETURN BOOLEAN;

END;
/

--Define the controller package of the application
CREATE OR REPLACE PACKAGE BODY crud_validator
AS

  FUNCTION is_valid_date_format ( p_date IN VARCHAR2,
      p_format IN VARCHAR2 ) 
  RETURN BOOLEAN IS
      l_date DATE := NULL;
  BEGIN
      l_date := TO_DATE( p_date, p_format );
      RETURN TRUE;
  EXCEPTION
      WHEN OTHERS THEN
          RETURN FALSE;
  END is_valid_date_format;

  FUNCTION is_number( p_str IN VARCHAR2 )
    RETURN BOOLEAN
  IS
    l_num NUMBER;
  BEGIN
    l_num := to_number( p_str );
    RETURN TRUE;
  EXCEPTION
    WHEN others THEN
      RETURN FALSE;
  END is_number;

  FUNCTION is_phone_number( p_str IN VARCHAR2 )
    RETURN BOOLEAN
  IS
  BEGIN

    IF LTRIM(p_str, '0123456789.') IS NULL THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END is_phone_number;

END;
/

SHOW ERRORS
