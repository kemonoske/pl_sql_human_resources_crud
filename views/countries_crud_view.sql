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
