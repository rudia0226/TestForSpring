CREATE OR REPLACE PROCEDURE P_DIA_COLLECTION02(V_NAME VARCHAR2)
IS 
	TYPE STD_TYPE IS TABLE OF VARCHAR2(1000) INDEX BY VARCHAR2(200); 
    VAR_STD  STD_TYPE;
    
    CURSOR DIA_CURSOR IS
    SELECT NAME
		, NAME || ' | ' ||  
		 ID || ' | ' || 
		 GRADE || ' | ' || 
		 JUMIN || ' | ' || 
		 BIRTHDAY || ' | ' || 
		 TEL || ' | ' || 
		 DEPTNO1 || ' | ' || 
		 DEPTNO2 || ' | ' || 
		 PROFNO 		STD_INFO
	FROM STUDENT 
	;

  	REC_STUD  DIA_CURSOR%ROWTYPE;
  	
BEGIN
	OPEN DIA_CURSOR;
	LOOP
		FETCH DIA_CURSOR INTO REC_STUD; 
		EXIT WHEN DIA_CURSOR%NOTFOUND;
				VAR_STD(REC_STUD.NAME) := REC_STUD.STD_INFO ;
		
	END LOOP;
	DBMS_OUTPUT.PUT_LINE(  VAR_STD(V_NAME)  );
		
	CLOSE DIA_CURSOR; 
END;