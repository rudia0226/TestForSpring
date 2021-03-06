


SELECT * FROM EXAM_RSLT;


-- 51페이지 
SELECT 
     DECODE(NO, 1, NAME, 2, CLASS,'TOT')  NM
     , SUM(KOR) KOR
     , SUM(ENG) ENG
     , SUM(MAT) MAT 
     , SUM(KOR+ENG+MAT) TOT 
FROM EXAM_RSLT A, 
(SELECT NO FROM COPY_T WHERE ROWNUM <= 3) B
GROUP BY DECODE(NO, 1, NAME, 2, CLASS,'TOT')
ORDER BY MAX(B.NO)
;



-- 52 페이지
--1번
SELECT NAME
    , SUM(KOR) KOR
    , SUM(ENG) ENG
    , SUM(MAT) MAT 
    , SUM(KOR+ENG+MAT) TOT
FROM EXAM_RSLT A 
GROUP BY CLASS, NAME
UNION ALL 
SELECT CLASS
	, SUM(KOR) KOR
    , SUM(ENG) ENG
    , SUM(MAT) MAT 
    , SUM(KOR+ENG+MAT) TOT
FROM EXAM_RSLT A 
GROUP BY CLASS
UNION ALL 
SELECT 'TOT'
	, SUM(KOR) KOR
    , SUM(ENG) ENG
    , SUM(MAT) MAT 
    , SUM(KOR+ENG+MAT) TOT
FROM EXAM_RSLT A 
GROUP BY NULL  -- 결과는 1건 출력 
;



--2번
SELECT DECODE(NO, 1, NAME, 2, CLASS, 'TOT') NAME 
		, SUM(KOR) KOR
		, SUM(ENG) ENG
	    , SUM(MAT) MAT 
	    , SUM(KOR+ENG+MAT) TOT
FROM EXAM_RSLT  A,
( 
SELECT NO FROM COPY_T 
WHERE ROWNUM <= 3
) B
GROUP BY DECODE(NO, 1, CLASS)
			, DECODE(NO, 1, NAME, 2, CLASS, 'TOT')
ORDER BY MIN(NO), KOR 
;			


--3번 ; ROLLUP 예제  N 개의 컬럼을 이용 -> N+1개의 GROUP BY 결과값 나옴 
SELECT DECODE(GROUPING(CLASS)||GROUPING(NAME), '00' , NAME, '01', CLASS, 'TOT') NAME
        , SUM(KOR) KOR
		, SUM(ENG) ENG
	    , SUM(MAT) MAT 
	    , SUM(KOR+ENG+MAT) TOT
		, GROUPING(CLASS)||GROUPING(NAME) GR
FROM EXAM_RSLT
GROUP BY ROLLUP(CLASS, NAME) 
ORDER BY GR, KOR
;


-- 61페이지 
-- LAG() 이전의 로우 값 반환 (순서가 중요 -> ORDER BY 필요)
-- LEAD() 이후의 로우 값 반환 (순서가 중요 -> ORDER BY 필요)

SELECT NAME 
	    , CLASS
	    , KOR
	    , ENG
	    , MAT 
	    , KOR+ENG+MAT TOT 
	    , LAG(KOR+ENG+MAT) OVER(ORDER BY KOR+ENG+MAT)
	    , LEAD(KOR+ENG+MAT) OVER(ORDER BY KOR+ENG+MAT)
FROM EXAM_RSLT;



-- 62페이지 예제 
SELECT NAME 
     , CLASS
     , KOR  , ENG  , MAT 
     , TOT
     , RANK() OVER(ORDER BY TOT DESC) RK   -- 중복순위 다음은 해당개수만큼 건너뛰고 반환
     , DENSE_RANK() OVER(ORDER BY TOT DESC) D_RK  -- 중복순위 상관없이 순차적으로 반환
     , SUM(TOT) OVER(ORDER BY TOT DESC) 누적합  -- ORDER BY TOT 하면 TOT값정렬에 의한 TOT 누적합 산출 
     , SUM(TOT) OVER(PARTITION BY CLASS ORDER BY TOT, CLASS) 구분누적합
     , RANK() OVER(PARTITION BY CLASS ORDER BY TOT) 구분랭킹  -- CLASS  별로 구분해서 순위매김 
     , TOT - LAG(TOT) OVER(ORDER BY TOT DESC) AS 이전값
     , TOT - LEAD(TOT) OVER(ORDER BY TOT DESC) AS 이후값
FROM 
(
	SELECT NAME
			, CLASS
			, KOR, ENG, MAT
			, KOR+ENG+MAT TOT 
	FROM EXAM_RSLT
)
;



DESC V_TESTCD;
SELECT LTRIM(MAX(SYS_CONNECT_BY_PATH(NID,'+')),'+')||'='||SUM(NID) STR
FROM (
            SELECT ROWNUM +:ARG_STVAL-1 NID
                     ,ROWNUM +:ARG_STVAL P_NID
            FROM DUAL
            CONNECT BY LEVEL <= :ARG_ETVAL - :ARG_STVAL +1            
           ) 
CONNECT BY PRIOR DECODE(:ARG_DIR,'F',P_NID,NID) = DECODE(:ARG_DIR,'F',NID,P_NID) 
START WITH NID = DECODE(:ARG_DIR,'F',:ARG_STVAL ,:ARG_ETVAL)     
;    



SELECT LTRIM(MAX(SYS_CONNECT_BY_PATH(NID, '+')),'+') 
							|| ' = ' || SUM(NID)   RUDI
--SELECT NID, PID
FROM 
(
SELECT ROWNUM + :SRART-1 NID 
		,ROWNUM + :SRART PID 
FROM DUAL 
CONNECT BY LEVEL <= :END - :SRART + 1
)
CONNECT BY PRIOR NID = PID 
START WITH NID  IS NOT NULL
;



SELECT * FROM STUDENT;
SELECT * FROM PROFESSOR;


SELECT NAME
          , SUM(KOR) KOR
          , SUM(ENG) ENG
          , SUM(MAT) MAT
          , SUM(KOR+ENG+MAT) TOT
FROM EXAM_RSLT
GROUP BY CLASS, NAME
UNION ALL
SELECT CLASS
          , SUM(KOR) KOR
          , SUM(ENG) ENG
          , SUM(MAT) MAT
          , SUM(KOR+ENG+MAT) TOT
FROM EXAM_RSTL
GROUP BY CLASS
UNION ALL
SELECT 'TOT'
          , SUM(KOR) KOR
          , SUM(ENG) ENG
          , SUM(MAT) MAT
          , SUM(KOR+ENG+MAT) TOT
FROM EXAM_RSTL
GROUP BY NULL
;


SELECT DECODE(NO,1,NAME,2,CLASS,'TOT') NAME
          , SUM(KOR) KOR
          , SUM(ENG) ENG
          , SUM(MAT) MAT
          , SUM(KOR+ENG+MAT) TOT
FROM EXAM_RSLT A,
  ( SELECT NO FROM COPY_T
    WHERE ROWNUM <= 3 ) B
GROUP BY DECODE(NO,1,CLASS)
                             , DECODE(NO, 1, NAME, 2, CLASS, 'TOT')
ORDER BY MIN(NO) , KOR
;