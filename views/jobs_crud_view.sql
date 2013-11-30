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
