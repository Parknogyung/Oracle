/*
    <PL/SQL>
        오라클에 내장되어 있는 절차적 언어로 SQL 문장 내에서 변수를 정의, 조건 처리(IF), 반복 처리(LOOP, WHILE, FOR)등을 지원한다.
*/

-- 출력 기능 활성화
SET SERVEROUTPUT ON;

-- HELLO ORACLE 출력
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/

/*
    1. 선언부
        변수 및 상수를 선언하는 영역이다. (선언과 동시에 초기화도 가능)
        일반 타입, 레퍼런스 타입, ROW 타입 변수로 선언해서 사용할 수 있다.
        
    1) 일반 타입 변수 선언 및 초기화
*/
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(15) := '문인수';
    PI CONSTANT NUMBER := 3.14; -- 상수 선언. 선언시 바로 초기화 해줘야함 상수의 경우. 수정 불가
BEGIN
    EID := 300;
--    PI := 3.15; -- 에러 발생
    
    DBMS_OUTPUT.put_line('EID : ' || EID);
    DBMS_OUTPUT.put_line('ENAME : ' || ENAME);
    DBMS_OUTPUT.put_line('PI : ' || PI);
END;
/

-- 2) 레퍼런스 타입 변수 선언 및 초기화
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE; -- EID 변수에 들어갈 값의 타입을 EMPLOYEE 테이블에 EMP_ID타입으로 저장해줘
    ENAME EMPLOYEE.EMP_NAME%TYPE; -- ENAME 변수에 들어갈 값의 타입을 EMPLOYEE 테이블에 EMP_NAME 타입으로 저장해줘
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    -- 노옹철 사원의 사번, 직원명, 급여 정보를 EID, ENAME, SAL 변수에 대입 후 출력한다.
    SELECT EMP_ID, EMP_NAME, SALARY 
    INTO EID, ENAME, SAL -- SELECT 컬럼 순서대로 변수를 넣는다 INTO에
    FROM EMPLOYEE
    WHERE EMP_NAME = '&직원명'; -- 대체 변수 입력창에 입력하면 그 사원에 대한 결과가 반환된다.
    
    DBMS_OUTPUT.put_line('EID : ' || EID);
    DBMS_OUTPUT.put_line('ENAME : ' || ENAME);
    DBMS_OUTPUT.put_line('SAL : ' || SAL);
END;
/

-------------------------------실습 문제------------------------------------------
/*
    레퍼런스 타입 변수로 EID, ENAME, JCODE, DTITLE, SAL를 선언하고 
    각 변수의 자료형은 EMPLOYEE 테이블의 EMP_ID, EMP_NAME, JOB_CODE, SALARY 컬럼과 DEPARTMENT 테이블의
    DEPT_TITLE 컬럼의 자료형을 참조한다.
    사용자가 입력한 사번과 일치하는 사원을 조회(사번, 직원명, 직급 코드, 부서명, 급여)한 후 조회 결과를 각 변수에 대입하여 출력한다.
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_TITLE, SALARY
    INTO EID, ENAME, JCODE, DTITLE, SAL
    FROM EMPLOYEE E
    JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.put_line('사번 : ' || EID);
    DBMS_OUTPUT.put_line('이름 : ' || ENAME);
    DBMS_OUTPUT.put_line('직급 코드 : '||JCODE);
    DBMS_OUTPUT.put_line('부서 : ' || DTITLE);
    DBMS_OUTPUT.put_line('급여 : ' || SAL);

END;
/

-- 3. ROW 타입 변수 선언 및 초기화
DECLARE
    EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_NAME = '&직원명';

    DBMS_OUTPUT.put_line('사번 : ' || EMP.EMP_ID);
    DBMS_OUTPUT.put_line('이름 : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.put_line('주민번호 : ' || EMP.EMP_NO);
    DBMS_OUTPUT.put_line('이메일 : ' || EMP.EMAIL);
    DBMS_OUTPUT.put_line('전화번호 : ' || EMP.PHONE);
    DBMS_OUTPUT.put_line('부서코드 : ' || EMP.DEPT_CODE);
    DBMS_OUTPUT.put_line('직급코드 : ' || EMP.JOB_CODE);
    DBMS_OUTPUT.put_line('급여코드 : ' || EMP.SALARY);
    DBMS_OUTPUT.put_line('급여 : ' || TO_CHAR(EMP.SALARY, 'FML99,999,999'));
    DBMS_OUTPUT.put_line('입사일 : ' || TO_CHAR(EMP.HIRE_DATE, 'YYYY/MM/DD'));
    

END;
/

/*
    2. 실행부
        제어문, 반복문, 함수 정의 등 로직을 기술하는 영역이다.
    
    1) 선택문
        1-1) 단일 IF 문
*/
-- 사번을 입력받은 후 해당 사원의 사번, 이름, 급여, 보너스를 출력
-- 단, 보너스를 받지 않는 사원은 보너스 출력 전에 '보너스를 지급받지 않는 사원입니다.'라는 문구 출력한다.
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    INTO EID, ENAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    
    IF (BONUS IS NULL) THEN 
        DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || BONUS);
END;
/

SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NULL;

/*
        1-2) IF ~ ELSE 구문
*/

-- 위의 PL/SQL 구문을 IF ~ ELSE 문으로 변경하여 작성
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    
--    IF (BONUS IS NULL) THEN 
    IF (BONUS = 0) THEN -- NVL을 써서 NULL을 0으로 변경 시....
        DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS * 100 || '%');
    END IF;
    
END;
/

-- 사번을 입력받아서 해당 사원의 사번, 이름, 부서명, 국가 코드를 조회한 후 출력한다.
-- 단, 국가 코드가 'KO'이면 국내팀 그 외는 해외팀으로 출력한다.
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
BEGIN
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE E
    JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || DTITLE);
    DBMS_OUTPUT.PUT_LINE('국가코드 : ' || NCODE);
    
    IF(NCODE = 'KO') THEN 
        DBMS_OUTPUT.PUT_LINE('소속 : 국내팀');
    ELSE
        DBMS_OUTPUT.PUT_LINE('소속 : 해외팀');
    END IF;
END;
/

/*
        1-3) IF ~ ELSIF ~ ELSE 구문
*/
-- 사용자에게 점수를 입력받아서 SCORE 변수에 저장한 후 학점은 입력된 점수에 따라 GRADE 변수에 저장한다.
-- 90점 이상은 'A' 학점
-- 80점 이상은 'B' 학점
-- 70점 이상은 'C' 학점
-- 60점 이상은 'D' 학점
-- 60점 미만은 'F' 학점
-- 출력은 '당신의 점수는 95점이고, 학점은 A학점입니다.'와 같이 출력한다.
DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE := '&점수';

    IF(SCORE <= 100 AND SCORE >= 0) THEN
        IF(SCORE >= 90) THEN
            GRADE := 'A';
        ELSIF(SCORE >= 80) THEN
            GRADE := 'B';
        ELSIF(SCORE >= 70) THEN
            GRADE := 'C';
        ELSIF(SCORE >= 60) THEN
            GRADE := 'D';
        ELSE
            GRADE := 'F';
        END IF;
            DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점이고, 학점은 ' || GRADE || '학점입니다.');
   
    ELSE
        DBMS_OUTPUT.PUT_LINE('점수를 잘못 입력하였습니다.');
    END IF;
END;
/

-- 사용자에게 입력받은 사번과 일치하는 사원의 급여 조회 후 출력한다,
-- 500만원 이상이면 '고급'
-- 300만원 이상이면 '중급'
-- 300만원 미만이면 '초급'
-- 출력은 '해당 사원의 급여 등급은 고급입니다.'와 같이 출력한다.
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(6);
BEGIN
    
    SELECT EMP_ID, SALARY
    INTO EID, SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    IF(SALARY >= 5000000) THEN
    GRADE := '고급';
    ELSIF(SALARY > 3000000) THEN
    GRADE := '중급';
    ELSE
    GRADE := '초급';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' || GRADE || '입니다');
END;
/

DECLARE
    SALARY EMPLOYEE.SALARY%TYPE;
    GRADE SAL_GRADE.SAL_LEVEL%TYPE;
BEGIN
    SELECT SALARY
    INTO SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    SELECT SAL_LEVEL
    INTO GRADE
    FROM SAL_GRADE
--    WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
    WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;
    
    DBMS_OUTPUT.PUT_LINE(SALARY);
    DBMS_OUTPUT.PUT_LINE(GRADE);
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' || GRADE || '입니다');
END;
/

--      1-4) CASE 구문
-- 사용자로부터 사번을 입력받은 후에 사원의 모든 컬럼에 데이터를 EMP에 대입하고 DEPT_CODE에 따라 알맞는 부서를 출력한다.
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DTITLE := CASE EMP.DEPT_CODE
                   WHEN 'D1' THEN '인사관리부'
                   WHEN 'D2' THEN '회계관리부'
                   WHEN 'D3' THEN '마케팅부'
                   WHEN 'D4' THEN '국내영업부'
                   WHEN 'D5' THEN '해외영업1부'
                   WHEN 'D6' THEN '해외영업2부'
                   WHEN 'D7' THEN '해외영업3부'
                   WHEN 'D8' THEN '기술지원부'
                   WHEN 'D9' THEN '총무부'
                   ELSE '부서없음'
                END;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서코드 : ' || EMP.DEPT_CODE);    
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || DTITLE);
END;
/

/*
    2) 반복문
        2-1) BASIC LOOP
*/
-- 1 ~ 5까지 순서차적으로 1씩 증가하는 값을 출력
DECLARE
    NUM NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        
        NUM := NUM + 1;
        
--        IF NUM > 5 THEN
--            EXIT;
--        END IF;
        EXIT WHEN NUM > 10;
    END LOOP;
END;
/

/*
        2-2) WHILE LOOP
*/
-- 1 ~ 5까지 순서차적으로 1씩 증가하는 값을 출력
DECLARE
    NUM NUMBER := 1;
BEGIN
    WHILE NUM <= 5
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
    
        NUM := NUM + 1;
    END LOOP;
END;
/

-- 구구단 출력 (2 ~ 9단)
DECLARE
    DAN NUMBER := 2;
    SU NUMBER;
    RESULT NUMBER;
BEGIN
    WHILE DAN <= 9
    LOOP
        SU := 1;
        
        WHILE SU <= 9
        LOOP
            RESULT := DAN * SU;
            
            DBMS_OUTPUT.PUT_LINE(DAN || ' X ' || SU || ' = ' || RESULT);
            
            SU := SU + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        DAN := DAN + 1; 
    END LOOP;
END;
/

/*
        2-3) FOR LOOP
*/
-- 1 ~ 5까지 순서차적으로 1씩 증가하는 값을 출력
BEGIN
    FOR NUM IN 1..5
    LOOP 
        DBMS_OUTPUT.PUT_LINE(NUM);
    END LOOP;
END;
/

-- 역순으로 출력
BEGIN
    FOR NUM IN REVERSE 1..5
    LOOP 
        DBMS_OUTPUT.PUT_LINE(NUM);
    END LOOP;
END;
/

-- 구구단 출력 (2 ~ 9단) 출력 (단, 짝수단만 출력한다.)
BEGIN
    FOR DAN IN REVERSE 2..9
    LOOP
        -- 짝수단만 출력하고자 할 때 조건문
        IF MOD(DAN, 2) = 0 THEN
            FOR SU IN 1..9
            LOOP
                DBMS_OUTPUT.PUT_LINE(DAN || ' X ' || SU || ' = ' || DAN * SU);
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
    END LOOP;
END;
/

-- 반복문을 이용한 데이터 삽입
CREATE TABLE TEST(
    NUM NUMBER,
    CREATE_DATE DATE
);

SELECT * FROM TEST;
ROLLBACK;
TRUNCATE TABLE TEST;
-- TEST 테이블에 10개의 행을 INSERT 하는 PL/SQL 작성
BEGIN
    FOR NUM IN 1..10 
    LOOP
        INSERT INTO TEST VALUES(NUM, SYSDATE);
        
        IF MOD(NUM, 2) = 0 THEN
            COMMIT;
        ELSE 
            ROLLBACK;
        END IF;
    END LOOP;
END;
/

/*
    3. 예외처리부
        PL/SQL 문에서 발생한 예외를 처리하는 영역이다.
        
        * 오라클에서 미리 정의되어 있는 예외
            - NO_DATA_FOUND    : SELECT 문의 수행 결과가 한 행도 없을 경우에 발생한다.
            - TOO_MANY_ROWS    : 한 행이 리턴되어야 하는데 SELECT 문에서 여러 개의 행을 반환할 때 발생한다.
            - ZERO_DIVIDE      : 숫자를 0으로 나눌 때 발생한다.
            - DUP_VAL_ON_INDEX : UNIQUE 제약 조건을 가진 컬럼에 중복된 데이터가 INSERT 될 때 발생한다.
*/
-- 사용자가 입력한 수로 나눗셈 연산 결과를 출력
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10 / &숫자;
    
    DBMS_OUTPUT.PUT_LINE('결과 : ' || RESULT);
EXCEPTION
    WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('나누기 연산시 0으로 나눌 수 없습니다.');
END;
/

-- UNIQUE 제약조건 위배 시
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = 200
    WHERE EMP_NAME = '&이름';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다.');
END;
/

-- 너무 많은 행이 조회가 되었을 때
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    MID EMPLOYEE.MANAGER_ID%TYPE;
BEGIN
    SELECT EMP_ID, MANAGER_ID
    INTO EID, MID
    FROM EMPLOYEE
    WHERE MANAGER_ID = &사수번호;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('사수 사번 : ' || MID);

EXCEPTION
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 행이 조회되었습니다.');
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다.');
END;
/