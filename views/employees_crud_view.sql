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
