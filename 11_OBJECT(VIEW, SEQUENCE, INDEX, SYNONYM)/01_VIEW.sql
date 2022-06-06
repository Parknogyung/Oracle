/*
    <VIEW>
        SELECT 문을 저장할 수 있는 객체이다. (논리적인 가상 테이블)
        데이터를 저장하고 있지 않으며 테이블에 대한 SQL만 저장되어 있어 VIEW에 접근할 때 SQL을 수행하고 결과값을 가져온다.
*/
-- 한국에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명을 조회
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME 
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME = '한국';

-- 러시아에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명을 조회
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME 
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME = '러시아';

-- 일본에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명을 조회
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME 
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME = '일본';

-- 관리자 계정으로 CREATE VIEW 권한을 부여한다
GRANT CREATE VIEW TO KH;

CREATE VIEW V_EMPLOYEE
AS SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME 
   FROM EMPLOYEE E
   JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
   JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
   JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE);

SELECT * 
FROM V_EMPLOYEE; -- 가상 테이블로 실제 데이터가 담겨있는 것은 아니다. 쿼리문을 담고있다.

-- 접속한 계정이 가지고 있는 VIEW에 정보를 조회하는 데이터 딕셔너리이다.
SELECT * FROM USER_VIEWS;

-- 한국에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명을 조회
SELECT *
FROM V_EMPLOYEE
WHERE NATIONAL_NAME = '한국';

-- 일본에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명을 조회
SELECT *
FROM V_EMPLOYEE
WHERE NATIONAL_NAME = '일본';

-- 서브 쿼리의 SELECT 절에 함수나 산술연산이 기술되어 있는 경우 반드시 컬럼에 별칭을 지정해야 한다.
-- 직원들의 사번, 직원명, 성별, 근무년수 조회할 수 있는 뷰를 생성
SELECT EMP_ID, 
       EMP_NAME,
       DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'),
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE;

-- 1) 서브 쿼리에서 별칭을 부여하는 방법
CREATE VIEW V_EMP_01
AS SELECT EMP_ID, 
       EMP_NAME,
       DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS "성별",
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "근무년수"
    FROM EMPLOYEE;

-- 2) 뷰 생성 시 모든 컬럼에 별칭을 부여하는 방법
CREATE OR REPLACE VIEW V_EMP_01("사번", "직원명", "성별", "근무년수") -- 모든 컬럼에 별칭을 부여해야 한다.
AS SELECT EMP_ID, 
       EMP_NAME,
       DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'),
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
    FROM EMPLOYEE;    

SELECT * FROM V_EMP_01;

DROP VIEW V_EMPLOYEE;
DROP VIEW V_EMP_01;

/*
    <VIEW를 이용해서 DML 사용>
        뷰를 통해서 데이터를 변경하게 되면 실제 데이터가 담겨있는 테이블에도 적용된다.
*/
CREATE VIEW V_JOB
AS SELECT *
    FROM JOB;
    
-- VIEW에 SELECT 실행
SELECT JOB_CODE, JOB_NAME 
FROM V_JOB;

-- VIEW에 INSERT 실행
INSERT INTO V_JOB VALUES('J8', '알바');

SELECT * FROM V_JOB;
SELECT * FROM JOB;

-- VIEW에 UPDATE 실행
UPDATE V_JOB
SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J8';

-- VIEW에 DELETE 실행
DELETE FROM V_JOB
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

/*
    <DML 구문으로 VIEW 조작이 불가능한 경우>
    
    1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
*/
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_CODE
    FROM JOB;

-- 뷰에 정의되어 있지 않는 컬럼 JOB_NAME을 조작하는 DML 작성
-- INSERT
INSERT INTO V_JOB VALUES('J8');
INSERT INTO V_JOB VALUES('J8', '인턴');

SELECT * FROM JOB;
SELECT * FROM V_JOB;

-- UPDATE
UPDATE V_JOB
SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J8';  -- VIEW에는 JOB_NAME컬럼이 존재하지않아 에러남

UPDATE V_JOB
SET JOB_CODE = 'J0'
WHERE JOB_CODE = 'J8';

DELETE FROM V_JOB
WHERE JOB_NAME = '사원'; -- VIEW에는 JOB_NAME컬럼이 존재하지않아 에러남

DELETE FROM V_JOB
WHERE JOB_CODE = 'J0';

ROLLBACK;

-- 2. 뷰에 포함되지 않은 컬럼 중에 베이스가 되는 컬럼이 NOT NULL 제약조건이 지정된 경우
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_NAME
   FROM JOB;

-- INSERT
-- VIEW에는 없지만 기존 테이블에도 들어가기 때문에 JOB_CODE에 NULL이 들어가므로 PK제약조건에 의해 에러 발생
INSERT INTO V_JOB VALUES ('인턴'); 

-- UPDATE
-- 컬럼을 바꾸는 거기 때문에 이거는 UPDATE가 가능하다.
UPDATE V_JOB
SET JOB_NAME = '인턴'
WHERE JOB_NAME = '사원';

-- DELETE (FK 제약조건으로 인해 삭제되지 않는다.)
-- 행을 삭제할 때 JOB_CODE가 참조하고 있기 때문에 FK 제약조건 자체가 걸려있기 때문에 삭제가 안된다.
DELETE FROM V_JOB
WHERE JOB_NAME = '인턴';

ROLLBACK;

SELECT * FROM JOB;
SELECT * FROM V_JOB;

-- 3. 산술 표현식으로 정의된 경우
-- 사원들의 급여 정보를 조회하는 뷰
ALTER TABLE EMPLOYEE MODIFY JOB_CODE NULL;

CREATE OR REPLACE VIEW V_EMP_SAL
AS SELECT EMP_ID,
          EMP_NAME,
          EMP_NO,
          SALARY,
          SALARY * 12 AS "연봉"
    FROM EMPLOYEE;

-- INSERT
-- 산술연산 컬럼은 테이블에는 존재하지 않고 뷰에만 존재하는 컬럼이기에 에러가 표출된다.
-- 산술연산으로 정의된 컬럼은 삽입 불가능
INSERT INTO V_EMP_SAL VALUES('1000', '홍길동', '940321-1111111', 3000000, 36000000);

-- 산술연산과 무관한 컬럼은 삽입 가능
INSERT INTO V_EMP_SAL(EMP_ID, EMP_NAME, EMP_NO, SALARY) VALUES('100', '홍길동', '940321-1111111', 3000000);

-- UPDATE
-- 연봉의 컬럼은 VIEW 컬럼 즉, 가상의 컬럼이기 때문에 테이블에 적용되지 않으므로 에러남.
UPDATE V_EMP_SAL
SET "연봉" = 40000000
WHERE EMP_ID = 100;

-- 산술연산과 무관한 컬럼의 데이터 변경 가능
UPDATE V_EMP_SAL
SET SALARY = 500000
WHERE EMP_ID = 100;

-- DELETE
-- 산술연산으로 삭제하는 것은 행을 선택하는 행위이므로 삭제가 가능하다.
DELETE FROM V_EMP_SAL
WHERE "연봉" = 6000000;

SELECT * FROM EMPLOYEE;
SELECT * FROM V_EMP_SAL;

-- 4. 그룹 함수나 GROUP BY 절을 포함한 경우
-- 부서별 급여의 합계, 급여 평균을 조회하는 뷰 생성
SELECT DEPT_CODE, 
       SUM(SALARY), 
       FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

CREATE OR REPLACE VIEW V_EMP_SAL
AS SELECT DEPT_CODE, 
          SUM(SALARY) AS "합계", 
          FLOOR(AVG(NVL(SALARY, 0))) AS "평균"
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;


-- INSERT
INSERT INTO V_EMP_SAL VALUES('D0', 8000000, 4000000);
INSERT INTO V_EMP_SAL(DEPT_CODE) VALUES('D0'); -- NOT NULL 조건 제외하고도 DEPARTMENT 테이블에 있는 컬럼값만 갖고올 수 있기 때문에 불가

-- UPDATE
UPDATE V_EMP_SAL
SET "합계" = 8000000
WHERE DEPT_CODE = 'D1'; -- D1의 값을 그룹핑해서 값을 바꿔주기 때문에 안되고 가상테이블이라 불가하기도 한다.

UPDATE V_EMP_SAL
SET DEPT_CODE = 'D0'
WHERE DEPT_CODE = 'D1'; -- 얘도 똑같이 그룹핑해서 값을 바꿔주기 때문에 안된다.

-- DELETE
DELETE FROM V_EMP_SAL
WHERE DEPT_CODE = 'D1'; -- 얘도 똑같이 그룹핑해서 값을 삭제해주기 때문에 안된다.

SELECT * FROM V_EMP_SAL;
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = 'D1';

-- 5. DISTINCT를 포함한 경우
CREATE VIEW V_EMP_JOB
AS SELECT DISTINCT JOB_CODE
    FROM EMPLOYEE;

-- DISTINCT 가 추가된 경우에는 아래 INSERT, UPDATE, DELETE 전부 에러남
-- INSERT
INSERT INTO V_EMP_JOB VALUES('J8'); -- GROUP BY랑 같은 이유

-- UPDATE
UPDATE V_EMP_JOB
SET JOB_CODE = 'J6'
WHERE JOB_CODE = 'J7';

-- DELETE
DELETE FROM V_EMP_JOB
WHERE JOB_CODE = 'J7';
    
SELECT * FROM V_EMP_JOB;
SELECT * FROM EMPLOYEE WHERE JOB_CODE = 'J7';

-- 6. JOIN을 이용해 여러 테이블을 연결한 경우
-- 직원들의 사번, 직원명, 부서명을 조회하는 뷰를 생성
CREATE OR REPLACE VIEW V_EMP
AS SELECT E.EMP_ID, 
          E.EMP_NAME, 
          E.EMP_NO,
          D.DEPT_TITLE
   FROM EMPLOYEE E
   INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);


-- INSERT
-- JOIN TABLE인 DEPARTMENT 테이블에 있는 값을 INSERT 해주면 에러남
INSERT INTO V_EMP VALUES('100', '임영웅', '990101-1111111', '마케팅부');
INSERT INTO V_EMP(EMP_ID, EMP_NAME, EMP_NO) VALUES('100', '임영웅', '990101-1111111');

-- UPDATE 
-- JOIN TABLE에 있는 값을 바꾸는건 안된다.
UPDATE V_EMP
SET DEPT_TITLE = '마케팅부'
WHERE EMP_ID = '200';  

-- 기존 테이블에 있는 값을 바꾸는건 된다.
UPDATE V_EMP
SET EMP_NAME = '서동일'
WHERE EMP_ID = '200';

-- DELETE
DELETE FROM V_EMP
WHERE EMP_ID = '200';

-- 서브 쿼리에 FROM절에 테이블에만 영양을 끼친다. WHERE 절에 있는 조건에 만족하는 행을 기준 테이블에서 같이 삭제함
DELETE FROM V_EMP
WHERE DEPT_TITLE = '총무부';

SELECT * FROM V_EMP;
SELECT * FROM EMPLOYEE;

ROLLBACK;

/*
    <VIEW 옵션>
    
    1. OR REPLACE 
        기존에 동일한 뷰가 있을 경우 덮어쓰고, 존재하지 않으면 뷰를 새로 생성한다.
*/
CREATE OR REPLACE VIEW V_EMP_01
AS SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
    FROM EMPLOYEE;
-- OR REPLACE 없이 EMP_ID를 추가해서 실행할 경우 이미 존재하는 VIEW이기 때문에 에러가 난다.
-- 그래서 OR REPLACE를 넣어주고 추가해주면 된다.

SELECT * FROM V_EMP_01;
SELECT * FROM USER_VIEWS; -- VIEW에 대한 내용을 보여줌

/*
    2. NOFORCE / FORCE 
    
    1) NOFORCE
        서브 쿼리에 기술된 테이블이 존재해야만 뷰가 생성된다. (기본값)
*/
-- 테이블이 존재해야 생성됨
CREATE /* NOFORCE */ VIEW V_EMP_02
AS SELECT *
   FROM TEST_TABLE;

/*    
    2) FORCE
        서브 쿼리에 기술된 테이블이 존재하지 않아도 뷰가 생성된다.  
*/
CREATE FORCE VIEW V_EMP_02
AS SELECT *
   FROM TEST_TABLE;

SELECT * FROM USER_VIEWS;
SELECT * FROM V_EMP_02; -- TEST_TABLE이 존재하지 않아 에러남

CREATE TABLE TEST_TABLE(
    TCODE NUMBER,
    TNAME VARCHAR2(20)
);

-- TEST_TABLE 테이블을 생성하면 이후부터는 VIEW 조회 가능
SELECT * FROM V_EMP_02;

/*
    3. WITH CHECK OPTION
        서브 쿼리에 기술된 조건에 부합하지 않는 값으로 수정하는 경우 오류를 발생시킨다.
*/
CREATE VIEW V_EMP_03
AS SELECT *
   FROM EMPLOYEE
   WHERE SALARY >= 3000000;

-- 선동일 사장님의 급여를 200만원으로 변경 --> 서브 쿼리의 조건에 부합하지 않아도 변경이 가능하다.
UPDATE V_EMP_03
SET SALARY = 2000000
WHERE EMP_ID = '200';
-- 200만원으로 변경하는 것은 VIEW의 서브쿼리 조건과 부합하지 않지만 실행이된다.

ROLLBACK;

CREATE OR REPLACE VIEW V_EMP_03
AS SELECT *
   FROM EMPLOYEE
   WHERE SALARY >= 3000000
WITH CHECK OPTION;

-- 선동일 사장님의 급여를 200만원으로 변경 --> 서브 쿼리의 조건에 부합하지 않기 때문에 변경이 불가능하다.
UPDATE V_EMP_03
SET SALARY = 2000000
WHERE EMP_ID = '200';
-- 200만원으로 변경하는 것은 VIEW의 서브쿼리 조건과 부합하지 않아서 에러 발생

-- 선동일 사장님의 급여를 400만원으로 변경 --> 서브 쿼리의 조건에 부합하기 때문에 변경이 가능하다.
UPDATE V_EMP_03
SET SALARY = 4000000
WHERE EMP_ID = '200';

SELECT * FROM V_EMP_03;
SELECT * FROM EMPLOYEE;
SELECT * FROM USER_VIEWS;

/*
    4. WITH READ ONLY
        뷰에 대해 조회만 가능하다. (DML 수행 불가)
*/
CREATE OR REPLACE VIEW V_DEPT
AS SELECT *
   FROM DEPARTMENT
WITH READ ONLY;

-- INSERT -> 읽기 전용이므로 불가
INSERT INTO V_DEPT VALUES('D0', '해외영업5부', 'L2');

-- UPDATE -> 읽기 전용이므로 불가
UPDATE V_DEPT
SET LOCATION_ID = 'L2'
WHERE DEPT_ID = 'D9';

-- DELETE -> 읽기 전용이므로 불가
DELETE FROM V_DEPT;

SELECT * FROM V_DEPT;

/*
    <VIEW 삭제>
*/
DROP VIEW V_DEPT;
DROP VIEW V_EMP;
DROP VIEW V_EMP_01;
DROP VIEW V_EMP_02;
DROP VIEW V_EMP_03;
DROP VIEW V_EMP_JOB;
DROP VIEW V_EMP_SAL;
DROP VIEW V_JOB;

SELECT * FROM USER_VIEWS;