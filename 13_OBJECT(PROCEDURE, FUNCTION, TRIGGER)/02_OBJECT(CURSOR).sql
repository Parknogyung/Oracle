/*
    <CURSOR>
        SQL 문의 처리 결과(처리 결과가 여러 행)를 담고있는 객체이다.
        커서 사용 시 여러 행으로 나타난 처리 결과에 순차적으로 접근이 가능하다.
        
    * 커서 종류
        묵시적/명시적 커서 두 종류가 존재한다.
       
    * 커서 속성 (묵시적 커서의 경우 커서명은 SQL로 사용된다.)
        커서명%FOUND       : 커서 영역에 남아있는 행의 수가 한 개 이상일 경우 TRUE, 아니면 FALSE
        커서명%NOTFOUND    : 커서 영역에 남아있는 행의 수가 없으면 TRUE, 아니면 FALSE
        커서명%ISOPEN      : 커서가 OPEN 상태인 경우 TRUE, 아니면 FALSE (묵시적커서는 항상 FALSE)
        커서명%ROWCOUNT    : SQL 처리 결과로 얻어온 행의 수
        
    1) 묵시적 커서
        오라클에서 자동으로 생성되어 사용하는 커서이다.
        PL/SQL 블록에서 실행하는 SQL 문 실행 시마다 자동으로 만들어져서 사용된다.
*/
SET SERVEROUTPUT ON;

-- 실습에 사용할 테이블 생성
CREATE TABLE EMP_COPY
AS SELECT * FROM EMPLOYEE;


SELECT * FROM EMP_COPY;

-- PL/SQL을 사용해서 EMP_COPY에 BONUS가 NULL인 사원의 BONUS를 0으로 수정
BEGIN
    UPDATE EMP_COPY
    SET BONUS = 0
    WHERE BONUS IS NULL;

    -- 묵시적 커서
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '행 수정됨'); -- 수정된 행의 갯수를 COUNT
END;
/

ROLLBACK;

/*
    2. 명시적 커서
        사용자가 직접 선언해서 사용할 수 있는 커서이다.
        
        [표현법]
            CURSOR 커서명 IS [SELECT 문];
            
            OPEN 커서명;
            FETCH 커서명 INTO 변수;
            ...
            
            CLOSE 커서명;
            
          - CURSOR : 커서 선언
          - OPEN   : 커서 오픈
          - FETCH  : 커서에서 데이터 추출 (한 행씩 데이터를 가져온다.)
          - CLOSE  : 커서 닫기
*/

-- 급여가 3000000 이상인 사원들의 사번, 이름, 급여를 출력 (PL/SQL)
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    
    CURSOR C1 IS -- 커서 선언 : 아래의 서브쿼리를 담아둔다.
        SELECT EMP_ID, EMP_NAME, SALARY
        FROM EMPLOYEE
        WHERE SALARY > 3000000;
BEGIN
    -- 커서 오픈 : 선언 시 작성했던 쿼리를 수행하고 결과를 담아둔다.
    OPEN C1; 
    
    LOOP
        -- 커서 패치 : 한 행씩 차례대로 데이터를 가져온다.
        FETCH C1 INTO EID, ENAME, SAL;
    
        -- 반복문 종료 조건
        EXIT WHEN C1%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(EID || ' ' || ENAME || ' ' || SAL);
    END LOOP;
    
    CLOSE C1;
END;
/

-- 전체 부서에 대해 부서 코드, 부서명, 지역 조회(PROCEDURE)
CREATE PROCEDURE CURSOR_DEPT
IS 
    DEPT DEPARTMENT%ROWTYPE;
    CURSOR C1 IS
        SELECT * FROM DEPARTMENT;
BEGIN
    -- OPEN을 해줘야 CURSOR에 값을 갖게 된다.
    OPEN C1;
    
    LOOP
        FETCH C1 INTO DEPT.DEPT_ID, DEPT.DEPT_TITLE, DEPT.LOCATION_ID;
        
        EXIT WHEN C1%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(DEPT.DEPT_ID || ' ' || DEPT.DEPT_TITLE || ' ' || DEPT.LOCATION_ID);
    END LOOP;
    
    CLOSE C1;
END;
/

EXEC CURSOR_DEPT;

-- FOR LOOP를 이용한 커서 사용
--  1) LOOP 시작 시 자동으로 커서를 OPEN 한다.
--  2) 반복할 때마다 FETCH도 자동으로 실행된다.
--  3) LOOP 종료 시 자동으로 커서를 CLOSE 한다.
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    DEPT DEPARTMENT%ROWTYPE;
--    CURSOR C1 IS
--        SELECT * FROM DEPARTMENT;
BEGIN
-- CURSOR를 별도로 선언하지 않고 사용하는 방법
--    FOR DEPT IN C1
    FOR DEPT IN (SELECT * FROM DEPARTMENT)
    LOOP
        DBMS_OUTPUT.PUT_LINE(DEPT.DEPT_ID || ' ' || DEPT.DEPT_TITLE || ' ' || DEPT.LOCATION_ID);
    END LOOP;
END;
/

EXEC CURSOR_DEPT;