/*
    <DML (Data Manipulation Language)>
        데이터 조작 언어로 테이블에 값을 삽입, 수정, 삭제하는 구문이다.
        
    <INSERT>
        테이블에 새로운 행을 추가하는 구문이다.
    
        1) INSERT INTO 테이블명 VALUES(값, 값, 값, ..., 값);
           테이블의 모든 컬럼에 대한 값을 INSERT하고자 할 때 사용한다.
           컬럼 순번을 지켜서 VALUES에 값을 나열해야 한다.
        2) INSERT INTO 테이블명(컬럼, 컬럼, ..., 컬럼) VALUES(값, 값, ..., 값);
           테이블에 내가 선택한 컬럼에만 값을 INSERT 하고자 할 때 사용한다.
           선택이 안된 컬럼들은 기본적으로 NULL값이 들어간다. (단, NOT NULL 제약조건이 걸려있는 컬럼은 반드시 선택해서 값을 INSERT 해야한다.)
           기본값(DEFAULT)이 지정되어 있으면 NULL이 아닌 기본값이 들어간다.
        3) INSERT INTO 테이블명 (서브 쿼리);
           VALUES를 대신해서 서브 쿼리로 조회한 결과값을 통채로 INSERT 한다.
           서브 쿼리의 결과값이 INSERT 문에 지정된 테이블 컬럼의 개수와 데이터 타입이 같아야 한다.
*/
-- 테스트에 사용할 테이블 생성
CREATE TABLE EMP_01 (
    EMP_ID NUMBER PRIMARY KEY,
    EMP_NAME VARCHAR2(30) NOT NULL,
    DEPT_TITLE VARCHAR2(30),
    HIRE_DATE DATE DEFAULT SYSDATE
);

-- 표현법 1) 사용
INSERT INTO EMP_01 
VALUES(100, '문인수', '서비스 개발팀', DEFAULT);

-- 모든 컬럼에 값을 지정하지 않아서 에러발생
INSERT INTO EMP_01 
VALUES(200, '홍길동', '개발 지원팀');

-- 에러는 발생하지 않지만 데이터가 잘못 저장된다.
INSERT INTO EMP_01 
VALUES(300, '유아지원팀',  '고길동', DEFAULT);

-- 컬럼 순서와 데이터 타입이 맞지 않아서 에러 발생
INSERT INTO EMP_01 
VALUES('유아지원팀', 300, '고길동', DEFAULT);

-- 표현법 2) 사용
INSERT INTO EMP_01(EMP_ID, EMP_NAME, DEPT_TITLE, HIRE_DATE) 
VALUES(400, '공유', '인사팀', NULL);

INSERT INTO EMP_01(EMP_NAME, EMP_ID, DEPT_TITLE, HIRE_DATE) 
VALUES('이몽룡', 500, '보안팀', SYSDATE);

INSERT INTO EMP_01(EMP_ID, EMP_NAME) 
VALUES(600, '성춘향');

-- EMP_NAME 컬럼에 NOT NULL 제약조건으로 인해서 에러 발생.
INSERT INTO EMP_01(EMP_ID, DEPT_TITLE) 
VALUES(700, '마케팅팀');

INSERT INTO EMP_01(EMP_ID, EMP_NAME, DEPT_TITLE) 
VALUES(700, '심청이', '마케팅팀');

-- 표현법 3) 사용

DELETE FROM EMP_01;

-- EMPLOYEE 테이블에서 직원의 사번, 이름, 부서명, 입사일을 조회해서 EMP_01 테이블에 INSERT
INSERT INTO EMP_01 (
    SELECT E.EMP_ID, 
           E.EMP_NAME, 
           D.DEPT_TITLE, 
           E.HIRE_DATE
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
);

-- 테이블 컬럼의 순서와 맞지 않아서 에러 발생
INSERT INTO EMP_01 (
    SELECT E.EMP_NAME, 
           E.EMP_ID, 
           D.DEPT_TITLE, 
           E.HIRE_DATE
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
);

-- 서브 쿼리로 조회한 데이터의 컬럼의 개수가 테이블의 컬럼 개수보다 많아서 에러 발생
INSERT INTO EMP_01 (
    SELECT E.EMP_ID, 
           E.EMP_NAME, 
           D.DEPT_TITLE, 
           E.HIRE_DATE,
           E.DEPT_CODE
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
);

DELETE FROM EMP_01;

-- EMPLOYEE 테이블에서 직원들의 사번, 직원명을 조회해서 EMP_01 테이블에 INSERT 하시오
INSERT INTO EMP_01(EMP_ID, EMP_NAME) (
    SELECT EMP_ID, EMP_NAME
    FROM EMPLOYEE
);

SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.HIRE_DATE
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);

SELECT * FROM EMP_01;

DROP TABLE EMP_01;

/*
    <INSERT ALL>
    
        1) INSERT ALL
            INTO 테이블명1[(컬럼, 컬럼, ...)] VALUES(값, 값, ...)
            INTO 테이블명2[(컬럼, 컬럼, 컬럼, ...)] VALUES(값, 값, 값, ...)
            서브 쿼리;
            
        2) INSERT ALL
            WHEN 조건1 THEN 
                INTO 테이블명1[(컬럼, 컬럼, ...)] VALUES(값, 값, ...)
            WHEN 조건2 THEN     
                INTO 테이블명2[(컬럼, 컬럼, ...)] VALUES(값, 값, ...)
            서브 쿼리;
*/
-- 표현법 1)번을 테스트할 테이블 만들기
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE 1 = 0;

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    WHERE 1 = 0;

-- EMP_DEPT 테이블에는 EMPLOYEE 테이블의 부서 코드가 D1인 직원들의 사번, 이름, 직원명, 부서코드, 입사일 삽입하고
-- EMP_MANAGER 테이블에는 EMPLOYEE 테이블의 부서 코드가 D1인 직원들의 사번, 직원명, 관리자 사번을 조회하여 삽입한다.
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

INSERT ALL
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';

SELECT * FROM EMP_DEPT;
SELECT * FROM EMP_MANAGER;

DROP TABLE EMP_DEPT;
DROP TABLE EMP_MANAGER;

-- 표현법 2)번을 테스트할 테이블 만들기
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1 = 2;

CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1 = 2;

-- EMPLOYEE 테이블에서 입사일 기준으로 2000년 1월 1일 이전에 입사한 사원의 정보는 EMP_OLD 테이블에 삽입하고
-- 2000년 1월 1일 이후에 입사한 사원의 정보는 EMP_NEW 테이블에 삽입한다.

SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE;

INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
    INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01'THEN
    INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

DROP TABLE EMP_OLD;
DROP TABLE EMP_NEW;

/*
    <UPDATE>
        테이블에 기록된 데이터를 수정하는 구문이다.
*/
-- 테스트를 진행할 테이블 생성
CREATE TABLE DEPT_COPY
AS SELECT *
    FROM DEPARTMENT;

CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
    FROM EMPLOYEE;

-- DEPT_COPY 테이블에서 DEPT_ID가 'D9'인 부서명을 전략기획팀으로 수정
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

-- EMP_SALARY 테이블에서 노옹철 사원의 급여를 1000000원으로 변경
UPDATE EMP_SALARY
SET SALARY = 1000000
WHERE EMP_NAME = '노옹철';

-- EMP_SALARY 테이블에서 선동일 사장의 급여를 7000000원으로, 보너스를 0.2로 변경
UPDATE EMP_SALARY
SET SALARY = 7000000, BONUS = 0.2
WHERE EMP_NAME = '선동일';

-- 모든 사원의 급여를 기존 급여에서 10프로 인상한 금액으로 변경
UPDATE EMP_SALARY
SET SALARY = SALARY * 1.1;

ROLLBACK;

COMMIT;

-- UPDATE 시 변경할 값은 해당 컬럼에 대한 제약조건에 위배되면 안된다.
-- EMP_SALARY 테이블에 사번이 200인 사원의 사번을 NULL로 변경
UPDATE EMP_SALARY
SET EMP_ID = NULL
WHERE EMP_ID = 200;

-- EMPLOYEE 테이블에 노옹철 사원의 부서코드 D0으로 변경
UPDATE EMPLOYEE
SET DEPT_CODE = 'D0'
WHERE EMP_NAME = '노옹철';

-- 방명수 사원의 급여와 보너스를 유재식 사원과 동일하게 변경
SELECT SALARY, BONUS
FROM EMP_SALARY
WHERE EMP_NAME = '유재식';

UPDATE EMP_SALARY
SET SALARY = 3740000, BONUS = 0.2
WHERE EMP_NAME = '방명수';

-- 1) 단일행 서브 쿼리를 사용하는 방법
UPDATE EMP_SALARY
SET SALARY = (
    SELECT SALARY
    FROM EMP_SALARY
    WHERE EMP_NAME = '유재식'
    ),
    BONUS = (
    SELECT BONUS
    FROM EMP_SALARY
    WHERE EMP_NAME = '유재식'
    )
WHERE EMP_NAME = '방명수';

ROLLBACK;

-- 2) 다중열 서브 쿼리를 사용해서 SALARY, BONUS 컬럼을 한 번에 변경
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (
    SELECT SALARY, BONUS
    FROM EMP_SALARY
    WHERE EMP_NAME = '유재식'
)
WHERE EMP_NAME = '방명수';

ROLLBACK;

-- EMP_SALARY 테이블에서 노옹철, 전형돈, 정중하, 하동운 사원들의 급여와 보너스를 유재식 사원과 동일하게 변경
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (
    SELECT SALARY, BONUS
    FROM EMP_SALARY
    WHERE EMP_NAME = '유재식'
)
WHERE EMP_NAME IN ('노옹철', '전형돈', '정중하', '하동운');

-- EMP_SALARY 테이블에서 아시아 지역에 근무하는 직원들의 보너스를 0.3으로 변경
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (
    SELECT EMP_ID
    FROM DEPT_COPY D
    JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    JOIN EMP_SALARY E ON (D.DEPT_ID = E.DEPT_CODE)
    WHERE LOCAL_NAME LIKE 'ASIA%'
);


SELECT * FROM DEPT_COPY;
SELECT * FROM EMP_SALARY;

/*
    <DELETE>
        테이블에 기록 된 데이터를 삭제하는 구문이다. (행 단위로 삭제한다.)
*/

SELECT * FROM DEPT_COPY;
SELECT * FROM EMP_SALARY;

-- EMP_SALARY 테이블에서 선동일 사장의 데이터를 지우기
-- SELECT *
DELETE 
FROM EMP_SALARY
WHERE EMP_ID = 200;

ROLLBACK;

DELETE 
FROM EMP_SALARY
WHERE EMP_ID = 222;

COMMIT;

-- EMP_SALARY 테이블에서 DEPT_CODE가 D5인 직원들을 삭제
--SELECT * 
DELETE
FROM EMP_SALARY
WHERE DEPT_CODE = 'D5';

SELECT * FROM DEPT_COPY;
SELECT * FROM EMP_SALARY;

/*
    <TRUNCATE>
        테이블의 전체 행을 삭제할 때 사용하는 구문이다.
        DELETE보다 수행 속도가 더 빠르다.
        별도의 조건을 제시할 수 없고 ROLLBACK이 불가능하다.
*/

DELETE FROM DEPT_COPY;
DELETE FROM EMP_SALARY;

ROLLBACK;

TRUNCATE TABLE DEPT_COPY;
TRUNCATE TABLE EMP_SALARY;

SELECT * FROM DEPT_COPY;
SELECT * FROM EMP_SALARY;

ROLLBACK; -- ROLLBACK 불가능

DROP TABLE DEPT_COPY;
DROP TABLE EMP_SALARY;