SELECT * FROM HR.EMPLOYEES;
--사용자 계정 확인
SELECT * FROM ALL_USERS;
--현재 사용자의 권한 확인
SELECT * FROM USER_SYS_PRIVS;
--사용자 계정을 생성 (관리자만 할 수 있음)
CREATE USER USER01 IDENTIFIED BY USER01;
--데이터베이스에 접속하려면 접속권한
--테이블생성을 하려면 테이블 생성권한
--뷰 생성을 하려면 뷰 생성권한
--시퀀스 생성을 하려면 시퀀스 생성권한
--프로시저 생성을 하려면 프로시져 생성권한
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE 
TO USER01;
--테이블스페이스 - 테이블에 데이터가 저장되는 물리적인 공간
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
--권한 회수 REVOKE ~ FROM
REVOKE CREATE SESSION FROM USER01;
--계정 삭제
DROP USER USER01; --CASCADE/*; --계정이 테이블과 데이터를 가지고 있으면, 테이블을 포함해서 삭제가 일어납니다.

---------------------------------------------------------------------------------
--롤을 이용한 권한부여
CREATE USER USER01 IDENTIFIED BY 123123;
GRANT RESOURCE, CONNECT TO USER01; --리소스롤 (테이블, 뷰, 시퀀스, 프로시저등의 권한의 그룹)
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
DROP USER USER01;
---------------------------------------------------------------------------------
--계정 생성과, 권한 부여를 마우스로
--보기탭 -> DBA클릭 -> 관리자접속 -> 테이블스페이스 생성






















