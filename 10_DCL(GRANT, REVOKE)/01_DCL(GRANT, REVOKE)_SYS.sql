/*
    <DCL(Data Control Language)>
        데이터를 제어하는 구문으로 계정에게 시스템 권한 또는 객체에 대한 접근 권한을
        부여(GRANT)하거나 회수(REVOKE)하는 구문이다.
        
    <시스템 권한>
        데이터베이스에 접근하는 권한, 오라클에서 제공하는 객체를 생성할 수 있는 권한
            - CREATE SESSION : 데이터베이스에 접속할 수 있는 권한
            - CREATE TABLE : 테이블을 생성할 수 있는 권한
            - CREATE VIEW : 뷰를 생성할 수 있는 권한
            - CREATE USER : 계정을 생성할 수 있는 권한
            - DROP USER : 계정을 삭제할 수 있는 권한
            ...
            
        [표현법]
            GRANT 권한 1, 권한 2, ... TO 사용자계정;
            REVOKE 권한 1, 권한 2, ... FROM 사용자계정;
*/

-- 1. SAMPLE 계정 생성
CREATE USER SAMPLE IDENTIFIED BY SAMPLE;

-- 2. 계정에 접속하기 위해서 CREATE SESSION 권한을 부여
GRANT CREATE SESSION TO SAMPLE;

-- 3. 계정에서 테이블을 생성할 수 있는 CREATE TABLE 권한을 부여
GRANT CREATE TABLE TO SAMPLE;

-- 4. 테이블 스페이스 할당
ALTER USER SAMPLE QUOTA 2M ON SYSTEM;

/*
    <객체 권한>
        특정 객체를 조작할 수 있는 권한
         - SELECT
         - INSERT
         - UPDATE
         - DELETE
         - ALTER
         ...
        
        [표현법]
            GRANT 권한 ON 객체 TO 사용자계정;
            REVOKE 권한 ON 객체 FROM 사용자계정;
*/
-- 5. KH.EMPLOYEE 테이블을 SAMPLE 계정에서 조회할 수 있는 권한을 부여
GRANT SELECT ON KH.EMPLOYEE TO SAMPLE;

-- 6. KH.DEPARTMENT 테이블을 SAMPLE 계정에서 조회할 수 있는 권한을 부여
GRANT SELECT ON KH.DEPARTMENT TO SAMPLE;

-- 7. KH.DEPARTMENT 테이블을 SAMPLE 계정에서 데이터를 삽입할 수 있는 권한을 부여
GRANT INSERT ON KH.DEPARTMENT TO SAMPLE;

-- 8. KH.DEPARTMENT 테이블을 SAMPLE 계정에서 데이터를 삽입할 수 있는 권한을 회수
REVOKE INSERT ON KH.DEPARTMENT FROM SAMPLE;

-- 9. 모든 테이블에 대한 조회 권한을 설정
GRANT SELECT ANY TABLE TO SAMPLE;

-- 10. 모든 테이블에 대한 조회 권한을 회수
REVOKE SELECT ANY TABLE FROM SAMPLE;

/*
    <ROLE>
        특정 권한들을 하나로 묶어놓은 것을 ROLE이라 한다.
*/

SELECT *
FROM ROLE_SYS_PRIVS
--WHERE ROLE = 'CONNECT';
--WHERE ROLE = 'DBA';
WHERE ROLE = 'RESOURCE';





















