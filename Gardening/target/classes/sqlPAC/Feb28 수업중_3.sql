DECLARE 
	V_ROW_SALECNT SALE_TBL%ROWTYPE;
	V_AREA_CD SALE_TBL.AREA_CD%TYPE := 20;
	
	-- 커서 선언, 매개변수로 지역번호를 받는다.
	CURSOR CUR_DIA_DATA IS
	SELECT MAX(AREA_CD) COL1, MAX(REGION_AREA) COL2,  MAX(CD_NM) COL3 , SUM(SALE_CNT) COL4
	FROM SALE_TBL A , CD_TBL B
	WHERE AREA_CD = V_AREA_CD
	AND A.PROD_ID = B.CD_ID
	GROUP BY PROD_ID;
	
BEGIN
-- 커서 오픈
	OPEN CUR_DIA_DATA;
	-- 반복문을 통한 커서 패치작업
	LOOP
		-- 커서 결과로 나온 로우를 패치함(사원명을 변수에 할당)
		FETCH CUR_DIA_DATA INTO  V_ROW_SALECNT 
		-- 패치된 참조 로우가 더 없으면 LOOP 탈출
		EXIT WHEN CUR_DIA_DATA%NOTFOUND ;
		--사원명을 출력
		DBMS_OUTPUT.PUT_LINE( '판매 가구 : ' || V_ROW_SALECNT.COL3 || ', 판매량(총액) : '  || V_ROW_SALECNT.COL4);
	END LOOP;
	-- 반복문 종료 후 커서 닫기
	CLOSE CUR_DIA_DATA ;
END;
