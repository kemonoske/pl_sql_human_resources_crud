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
