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
