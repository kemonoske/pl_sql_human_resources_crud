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
