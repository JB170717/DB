--DDL (트랜잭션이 없습니다)
DROP TABLE DEPTS;
CREATE TABLE DEPTS(
    DEPT_NO NUMBER(2), --숫자 2자리
    DEPT_NAME VARCHAR2(30), --30BYTE (한글 15글자, 영어30글자)
    DEPT_YB CHAR(1), --고정문자 1BYTE (고정크기의 1BYTE를 사용함)
    DEPT_DATE DATE, --날짜타입
    DEPT_BONUS NUMBER(10, 2), --전체 숫자 10자리 , 소수점 2자리 사용
    DEPT_CONTENT LONG --최대 2기가 가변문자열 (VACHAR2 보다 더큰무자열), 많이사용X   
);

DESC DEPTS;
INSERT INTO DEPTS VALUES(99, 'HELLO', 'Y', SYSDATE, 3.14, 'HELLO WORLD ~~ BYE');
INSERT INTO DEPTS VALUES(100, 'HELLO', 'N', SYSDATE, 3.14, 'HELLO WORLD'); -- DEPT_NO 크기초과
INSERT INTO DEPTS VALUES(10,'HELLO','가',SYSDATE, 3.14,'HELLO'); --DEPT_YN초과
SELECT * FROM DEPTS;
----------------------------------------------------------------------------------
--컬럼 추가 ADD
ALTER TABLE DEPTS ADD (DEPT_COUNT NUMBER(3) );
SELECT * FROM DEPTS;
--컬럼명 변경 RENAME COLUMN TO 
ALTER TABLE DEPTS RENAME COLUMN DEPT_COUNT TO EMP_COUNT;
--컬럼 수정 MODIFY
ALTER TABLE DEPTS MODIFY EMP_COUNT NUMBER(5);
ALTER TABLE DEPTS MODIFY DEPT_NAME VARCHAR2(1); --기존데이터가 변경할 크기를 넘어가는 경우, 변경불가
DESC DEPTS;
--컬럼 삭제 DROP COLUMN
ALTER TABLE DEPTS DROP COLUMN EMP_COUNT;
----------------------------------------------------------------------------------
--테이블 삭제 DROP
DROP TABLE EMPS;
DROP TABLE DEPARTMENTS; --부서테이블은 직원 테이블과 제약조건이 연결되어 있어서, 삭제 불가
--DROP TABLE DEPARTMENTS CASCADE 제약조건명; -- 제약조건이라는 것을 삭제하면서 테이블을 지움

--테이블 자르기 TRUNCATE -데이터를 전부 지우고, 데이터의 저장공간 해제
TRUNCATE TABLE DEPTS;
SELECT * FROM DEPTS;

--테이블명 DEPT2
--DEPT_NO 숫자타입 3글자
--DEPT_NAME 가변형문자 15바이트
--LOCA_NUMBER 숫자타입 4글자
--DEPT_GENDER 고정문자 1글자
--REG_DATE 날짜타입
--DEPT_BONUS 실수 5자리까지
--테이블 1행 삽입

CREATE TABLE DEPT2(
    DEPT_NO NUMBER(3),
    DEPT_NAME VARCHAR2(15),
    LOCA_NUMBER NUMBER(4),
    DEPT_GENDER CHAR(1),
    REG_DATE DATE,
    DEPT_BOUNUS NUMBER(10,5)    
);
INSERT INTO DEPT2 VALUES(26,'JB',17,'M',SYSDATE,3.14152);
SELECT * FROM DEPT2;
















