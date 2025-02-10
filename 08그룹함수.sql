--그룹함수 - 행에 대한 기초통계값
--SUM, AVG, MAX, MIN, COUNT -전부 NULL이 아닌 데이터에 대해서 통계를 구합니다.

SELECT SUM(SALARY), AVG(SALARY), MAX(SALARY), MIN(SALARY), COUNT(SALARY) FROM EMPLOYEES;
--MIN, MAX 날짜, 문자열에도 적용이 됩니다.
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE), MIN(FIRST_NAME), MAX(FIRST_NAME) FROM EMPLOYEES;
--COUNT함수는 2가지 사용방법이 있음
SELECT COUNT(COMMISSION_PCT) FROM EMPLOYEES; --35, NULL이 아닌 데이터에 대해서 집계
SELECT COUNT(*) FROM EMPLOYEES; --107, 전체행수(NULL포함)

--주의할점: 그룹함수는 일반컬럼과 동시에 사용이 불가능
SELECT FIRST_NAME, AVG(SALARY) FROM EMPLOYEES; --이거 안됨
--그룹함수 뒤에 OVER()를 붙이면 전체행이 출력이 되고, 그룹함수 사용이 가능함
SELECT FIRST_NAME, AVG(SALARY) OVER(), COUNT(*) OVER() FROM EMPLOYEES;

-----------------------------------------------------------------------
--GROUP BY절 - 컴럼기준으로 그룹핑
--그룹함수를 함께 사용할 수 있슴
SELECT DEPARTMENT_ID, SUM(SALARY), AVG(SALARY), MIN(SALARY), MAX(SALARY), COUNT(*) 
FROM EMPLOYEES GROUP BY DEPARTMENT_ID;
--주의할점 - GROUP BY에 지정되지 않는 컬럼은 SELECT절에 사용할 수 없음.

SELECT DEPARTMNET_ID,
        FIRST_NAME, --X
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

--2개 이상의 그룹화
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;

--
SELECT DEPARTMENT_ID, JOB_ID, COUNT(*) AS "각그룹에 대한 행수", COUNT(*) OVER() AS 전체행수
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;

--WHERE절에 그룹의 조건을 넣는것이 아닙니다.
SELECT DEPARTMENT_ID, SUM(SALARY)
FROM EMPLOYEES
WHERE SUM(SALARY) >50000 --GROUP BY조건을 쓰는 곳은 HAVING이라고 있음! //WHERE는 행에 대한 조건을 쓰는것, 그룹화된거에 대한 조건은 HAVING
GROUP BY DEPARTMENT_ID;

--------------------------------------------------------------------------------
--HAVING - 그룹 BY의 조건
--WHERE - 일반행 조건
SELECT DEPARTMENT_ID, AVG(SALARY), COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 5000 AND COUNT(*) >= 1;

--각 직무별 샐러리~들의 급여 평균이 10000이 넘는 직무?
SELECT JOB_ID ,AVG(SALARY)
FROM EMPLOYEES
WHERE JOB_ID LIKE 'SA%'
GROUP BY JOB_ID
HAVING AVG(SALARY)>10000
ORDER BY AVG(SALARY) DESC;

----------------------------------------------------------------------------------
--시험 대비
--ROLLUP - GROUP BY와 함꼐 사용되고, 상위그룹의 소계를 구합니다.
SELECT DEPARTMENT_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID);
--
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID, JOB_ID;

--CUBE -롤업에 의해서 구해진 값+ 서브그룹의 통계가 추가됨
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY CUBE(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID, JOB_ID;

--GROUPING() - 그룹절로 만들어진 경우에는 0을 반환, 롤업OR 큐브로 만들어진 행인 경우에는 1을 반환
SELECT DECODE(GROUPING(DEPARTMENT_ID),1,'총계',DEPARTMENT_ID) AS DEPARTMENT_ID
        ,DECODE(GROUPING(JOB_ID),1,'소계', JOB_ID) AS JOB_ID
        ,JOB_ID
        ,AVG(SALARY)
        ,GROUPING(DEPARTMENT_ID)
        ,GROUPING(JOB_ID)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID;

--
--문제 1.
--사원 테이블에서 JOB_ID별 사원 수를 구하세요.
--사원 테이블에서 JOB_ID별 월급의 평균을 구하세요. 월급의 평균 순으로 내림차순 정렬하세요.
--시원 테이블에서 JOB_ID별 가장 빠른 입사일을 구하세요. JOB_ID로 내림차순 정렬하세요.

SELECT * FROM EMPLOYEES;

SELECT JOB_ID,
        COUNT(*) AS 사원수
        ,AVG(SALARY) AS 월급평균
        ,MIN(HIRE_DATE) AS "가장 빠른 입사일"
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY AVG(SALARY) DESC,  JOB_ID DESC;

--문제 2.
--사원 테이블에서 입사 년도 별 사원 수를 구하세요.

SELECT  TO_CHAR(HIRE_DATE,'YY') AS 입사년도, COUNT(*) AS 사원수
FROM EMPLOYEES
GROUP BY TO_CHAR(HIRE_DATE,'YY');


--급여가 1000 이상인 사원들의 부서별 평균 급여를 출력하세요. 단 부서 평균 급여가 2000이상인 부서만 출력
SELECT DEPARTMENT_ID, AVG(SALARY)  
FROM EMPLOYEES WHERE SALARY>1000 
GROUP BY DEPARTMENT_ID HAVING AVG(SALARY)>=2000;


--문제 3.
--부서아이디가 NULL이 아니고, 입사일은 05년도 인 사람들의 부서 급여평균과, 급여합계를 평균기준 내림차순 조회하세요.
----조건은 급여평균이 10000이상인 데이터만.

SELECT DEPARTMENT_ID, 
        AVG(SALARY) AS 급여평균,
        SUM(SALARY) AS 급여합계 
FROM EMPLOYEES 
WHERE DEPARTMENT_ID IS NOT NULL AND TO_CHAR(HIRE_DATE,'YY')='05' 
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY)>=10000
ORDER BY AVG(SALARY) DESC;


--문제 4.
--사원 테이블에서 commission_pct(커미션) 컬럼이 null이 아닌 사람들의
--department_id(부서별) salary(월급)의 평균, 합계, count를 구합니다.
--조건 1) 월급의 평균은 커미션을 적용시킨 월급입니다.
--조건 2) 평균은 소수 2째 자리에서 절삭 하세요.

SELECT DEPARTMENT_ID
        ,ROUND(AVG(SALARY+SALARY*COMMISSION_PCT),2) AS 월급의평균
        ,SUM(SALARY+SALARY*COMMISSION_PCT) AS 합계
        ,COUNT(*) AS 직원수
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL
GROUP BY DEPARTMENT_ID ;

--문제 5.
--부서아이디가 NULL이 아니고, 입사일은 05년도 인 사람들의 부서 급여평균과, 급여합계를 평균기준 내림차순합니다
--조건) 평균이 10000이상인 데이터만

SELECT DEPARTMENT_ID
       ,AVG(SALARY) AS 급여평균
        ,SUM(SALARY) AS 급여합계 
        FROM EMPLOYEES
WHERE JOB_ID IS NOT NULL AND HIRE_DATE LIKE '05%'
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY)>=10000
ORDER BY AVG(SALARY) DESC;

--문제 6.
--직업별 월급합, 총합계를 출력하세요

SELECT DECODE(GROUPING(JOB_ID),1,'총합계',JOB_ID) AS JOB_ID
      ,SUM(SALARY) AS 직업별월급합
FROM EMPLOYEES
GROUP BY ROLLUP(JOB_ID);

--문제7.
--부서별, JOB_ID를 그룹핑하여
--토탈, 합계를출력하세요.
-- GROUPING() 을 이용하여
--소계합계를표현하세요

SELECT DECODE(GROUPING(DEPARTMENT_ID),1,'합계',DEPARTMENT_ID)
        ,DECODE(GROUPING(JOB_ID),1,'소계',JOB_ID)
        ,COUNT(*) AS TOTAL
        ,SUM(SALARY) 
FROM EMPLOYEES 
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY SUM(SALARY);

SELECT * FROM EMPLOYEES;





















