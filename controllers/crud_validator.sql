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
