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
