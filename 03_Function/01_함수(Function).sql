/*
    <문자 관련 함수>
    
    1) LENGTH / LENGTHB
        LENGTH('문자값') : 글자 수 반환
        LENGTHB('문자값') : 글자의 바이트 수 반환
        
        한글 한 글자 -> 3BYTE
        영문자, 숫자, 특수문자 한 글자 -> 1BYTE
*/

SELECT LENGTH('오라클'), 
       LENGTHB('오라클')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),
       EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

/*
    2) INSTR
        INSTR('문자값', '문자값' [, POSITION, OCCURRENCE])
    
*/
SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL; -- 3 생략하면 기본 값 1로 실행
SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL; -- 3 POSITION이 1이면 맨 앞에서부터 찾음
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL; -- 10 POSITION이 -1 이면 맨 끝에서부터 찾음
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL; -- 9 POSITION이 1이면 맨 처음부터 시작해서 OCCURRENCE가 2이면 2번째 발생위치 반환. OCCURRENCE는 음수 사용 불가
SELECT INSTR('AABAACAABBAA', 'B', 1, -1) FROM DUAL; -- OCCURRENCE는 음수 사용 불가
SELECT INSTR('AABAACAABBAA', 'B', -1, 3) FROM DUAL; -- 3

SELECT EMAIL AS "이메일", INSTR(EMAIL, '@') AS "@위치"
FROM EMPLOYEE;

/*
    3) LPAD / RPAD
        LPAD / RPAD('문자값', 최종적으로 반환할 문자의 길이(바이트)[, 덧붙이고자 하는 문자])
*/

SELECT LPAD('Hello', 10, 'A') -- HELLO 앞에다가 'A'의 값을 덧붙여준다. 10칸까지. 덧붙이고자 하는 문자 생략 시, 공백으로 들어감
FROM DUAL;

SELECT RPAD('HELLO', 10, 'AB') -- LPAD와 반대. 첫 번째 문자 데이터에 세 번째 문자를 채워 넣는다 10이 될 때까지. 덧붙이고자 하는 문자 생략 시, 공백
FROM DUAL;

-- 20만큼의 길이 중 EMAIL 값은 오른쪽으로 정렬하고 공백을 왼쪽으로 채운다.
SELECT LPAD(EMAIL, 20) 
FROM EMPLOYEE;

SELECT LPAD(EMAIL, 10) 
FROM EMPLOYEE;

SELECT LPAD(EMAIL, 3) 
FROM EMPLOYEE;

-- 20만큼의 길이 중 EMAIL 값은 왼쪽으로 정렬하고 #을 오른쪽으로 채운다.
SELECT RPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

-- 220429-3****** 를 출력
SELECT RPAD('220429-3', 14, '*')
FROM DUAL;

/*
    4) LTRIM / RTRIM
        LTRIM / RTRIM('문자값'[, 제거하고자 하는 문자값])
*/
SELECT LTRIM('     KH') FROM DUAL;
SELECT LTRIM('000123456', '0') FROM DUAL;
SELECT LTRIM('123123KH', '123') FROM DUAL;
SELECT LTRIM('123123KH', '213') FROM DUAL;
SELECT LTRIM('123123KH123', '123') FROM DUAL;

SELECT RTRIM('KH   ') FROM DUAL;
SELECT RTRIM('KH   ', ' ') FROM DUAL;
SELECT RTRIM ('000123000456000', '0') FROM DUAL;

SELECT LTRIM(RTRIM ('000123000456000', '0'), '0') FROM DUAL; -- 양쪽이 다 지워진다.

/*
    5) TRIM
        TRIM([LEADING | TRAILING | BOTH] '제거하고자 하는 문자값' FROM] '문자값')
        
        문자값 앞/뒤/양쪽에 있는 지정한 문자를 제거한 나머지를 반환한다.
*/

-- 기본적으로 양쪽에 있는 공백 문자를 제거한다.
SELECT TRIM('    KH    ') FROM DUAL;
SELECT TRIM(' ' FROM '    KH    ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZKHZZZ') FROM DUAL;
SELECT TRIM(BOTH 'Z' FROM 'ZZZKHZZZ') FROM DUAL;
SELECT TRIM(LEADING 'Z' FROM 'ZZZKHZZZ') FROM DUAL;
SELECT TRIM(TRAILING 'Z' FROM 'ZZZKHZZZ') FROM DUAL;

/*
    6) SUBSTR
        SUBSTR('문자값', POSITION[, LENGTH])
*/

SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 7, 3) FROM DUAL;
SELECT SUBSTR('SHOEMETHEMONEY', -8, 3) FROM DUAL; -- 오른쪽에서 8번째에서부터 시작해서 3번재 길이
SELECT SUBSTR('쇼우 미 더 머니', 2, 5) FROM DUAL;

-- EMPLOYEE 테이블에서 주민 등록번호에 성별을 나타내는 부분만 잘라서 조회하기 (직원명, 성별 코드)
SELECT EMP_NAME AS "직원명",
       SUBSTR(EMP_NO,8,1) AS "성별 코드"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 여자 사원의 직원명, 성별 코드
SELECT EMP_NAME AS "직원명",
       SUBSTR(EMP_NO,8,1) AS "성별 코드"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) = '2';

-- EMPLOYEE 테이블에서 남자 사원의 직원명, 성별
SELECT EMP_NAME AS "직원명",
       '남자' AS "성별"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';

-- EMPLOYEE 테이블에서 주민등록번호 첫 번째 자리부터 성별까지 추출한 결과값에 오른쪽에 * 문자를 채워서 14 글자 출력
-- ex) 991212-1******
SELECT RPAD(SUBSTR('991212-1222222', 1, 8), 14, '*')
FROM DUAL;

SELECT EMP_NAME AS "직원명",
       RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') AS "주민등록번호"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 이메일, 아이디(이메일에서 @앞의 문자 값만 출력)를 조회
SELECT EMP_NAME AS "이름",
       EMAIL AS "이메일",
       SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) AS "아이디"
FROM EMPLOYEE;

/*
    7) LOWER / UPPER / INITCAP
        LOWER/UPPER/INITCAP('문자값')
*/

SELECT 'welcome to my world' from DUAL;
SELECT LOWER('WELCOME TO MY WORLD') FROM DUAL; -- 소문자로 변경
SELECT UPPER('Welcome To My World') FROM DUAL; -- 대문자로 변경
SELECT INITCAP('Welcome to My World') FROM DUAL; -- 단어 앞 글자마다 대문자로 변경

/*
    8) CONCAT
        CONCAT('문자값', '문자값')
*/

SELECT CONCAT('가나다라', 'ABCD') FROM DUAL;
SELECT '가나다라'||'ABCD' FROM DUAL; -- 연결 연산자와 동일한 결과를 출력한다.

--SELECT CONCAT('가나다라', 'ABCD', 'EFG') FROM DUAL; -- 에러 발생 (CONCAT은 두 개의 문자 값만 전달받을 수 있다.)
SELECT '가나다라' || 'ABCD' || 'EFG' FROM DUAL;

SELECT CONCAT(EMP_ID, EMP_NAME)
FROM EMPLOYEE;

SELECT EMP_ID || EMP_NAME || EMP_NO
FROM EMPLOYEE;

/*
    9) REPLACE
        REPLACE('문자값', '변경하려고 하는 문자값', '변경할 문자값')
*/
SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동') FROM DUAL;

-- EMPLOYEE 테이블에서 이메일의 kh.or.kr을 gmail.com 변경해서 조회
SELECT EMP_NAME,
       EMAIL,
       REPLACE(EMAIL, 'kh.or.kr', 'gmail.com')
FROM EMPLOYEE;

/*
    <숫자 처리 함수>
    
    1) ABS()
        ABS(NUMBER)
*/
SELECT ABS(10.9) FROM DUAL;
SELECT ABS(-10.9) FROM DUAL; -- 절댓값을 구하는 함수

/*
    2) MOD
        MOD(NUMBER, NUMBER)
*/
--SELECT 10 % 3 FROM DUAL; -- 연사자 제공 안함
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(-10, 3) FROM DUAL;
SELECT MOD(10, -3) FROM DUAL;
SELECT MOD(10.9, -3) FROM DUAL;

/*
    3) ROUND
        ROUND(NUMBER[, POSITION])
    
        POSITION : 기본적으로 0, 양수(소수점 기준으로 오른쪽)와 음수(소수점 기준으로 왼쪽)로 입력 가능
*/
SELECT ROUND(123.456) FROM DUAL; -- 반올림하는 함수
SELECT ROUND(123.456, 0) FROM DUAL; -- 반올림하는 함수
SELECT ROUND(-10.65) FROM DUAL;
SELECT ROUND(-10.65, 0) FROM DUAL;
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 2) FROM DUAL;
SELECT ROUND(123.456, 4) FROM DUAL;
SELECT ROUND(123.456, -1) FROM DUAL;
SELECT ROUND(123.456, -2) FROM DUAL;
SELECT ROUND(123.456, -3) FROM DUAL;
SELECT ROUND(723.456, -3) FROM DUAL;

/*
    4) CEIL
        CEIL(NUMBER)
*/
SELECT CEIL(123.456) FROM DUAL; 
--SELECT CEIL(123.456, 2) FROM DUAL;

/*
    5) FLOOR
        FLOOR(NUMBER)
*/
SELECT FLOOR(123.456) FROM DUAL;
SELECT FLOOR(456.789) FROM DUAL;

/*
    6) TRUNC
        TRUNC(NUMBER[, POSITION])
*/
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(456.789) FROM DUAL;
SELECT TRUNC(456.789, 0) FROM DUAL;
SELECT TRUNC(456.789, 1) FROM DUAL;

/*
    <날짜 처리 함수>
    
    1) SYSDATE
*/
SELECT SYSDATE FROM DUAL;

-- 날짜 포맷 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

/*
    2) MONTHS_BETWEEN(DATE, DATE)
*/
SELECT FLOOR(MONTHS_BETWEEN(SYSDATE,'20210525')) FROM DUAL;

-- EMPLOYEE 테이블에서 직원명, 입사일, 근무개월 수 조회
SELECT EMP_ID AS "직원명", HIRE_DATE AS "입사일", FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) AS "근무개월 수"
FROM EMPLOYEE;

/*
    3) ADD_MONTHS
        ADD_MONTHS(DATE, NUMBER)
*/
SELECT ADD_MONTHS(SYSDATE, 12) FROM DUAL;

-- EMPLOYEE 테이블에서 직원명, 입사일, 입사 후 6개월이 된 날짜를 조회
SELECT EMP_NAME AS "직원명", 
       HIRE_DATE AS "입사일", 
       ADD_MONTHS(HIRE_DATE, 6) AS "입사일 + 6개월"
FROM EMPLOYEE;

/*
    4) NEXT_DAY
        NEXT_DATE(DATE, 요일(문자, 숫자))
*/
-- 현재 날짜에서 제일 가까운 일요일 조회
SELECT SYSDATE, NEXT_DAY(SYSDATE, '일요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 1) FROM DUAL; -- 1: 일요일, 2: 월요일, ..., 7: 토요일
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'SUNDAY') FROM DUAL; -- 에러 발생 (현재 언어가 KOREAN이기 때문에)
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'SUN') FROM DUAL; -- 에러 발생. 

-- 언어 변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 'MONDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'MON') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 2) FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월') FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = KOREAN;

/*
    5) LAST_DAY
        LAST_DAY(DATE)
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;
SELECT LAST_DAY('21/08/10') FROM DUAL;

-- EMPLOYEE 테이블에서 직원명, 입사일, 입사월의 마지막 날짜 조회
SELECT EMP_NAME,
       HIRE_DATE,
       LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

/*
    6) EXTRACT(YEAR|MONTH|DAY FROM DATE)
*/
-- EMPLOYEE 테이블에서 직원명, 입사년도, 입사일 조회
SELECT EMP_NAME AS "직원명", 
--       HIRE_DATE, 
       EXTRACT(YEAR FROM HIRE_DATE) AS "입사년도", 
       EXTRACT(MONTH FROM HIRE_DATE) AS "입사월",
       EXTRACT(DAY FROM HIRE_DATE) AS "입사일" 
FROM EMPLOYEE
--ORDER BY EXTRACT(YEAR FROM HIRE_DATE);
--ORDER BY "입사년도", "입사월";
ORDER BY 2, 3, 4;

/*
    <형 변환 함수>
    
    1) TO_CHAR(날짜|숫자[, 포멧])
*/

-- 숫자 -> 문자
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '999999') FROM DUAL; -- 6칸의 공간을 확보, 오른쪽 정렬, 빈칸을 공백으로 채운다.
SELECT TO_CHAR(1234, '000000') FROM DUAL; -- 6칸의 공간을 확보, 오른쪽 정렬, 빈칸은 0으로 채운다.
SELECT TO_CHAR(1234, 'L999999') FROM DUAL; -- L은 현재 위치의 통화를 보여줌
SELECT TO_CHAR(1234, 'L999,999') FROM DUAL; -- 자리수 구분 

SELECT * FROM EMPLOYEE;
-- EMPLOYEE 테이블에서 직원명, 급여 조회
SELECT EMP_NAME,
       TO_CHAR(SALARY, 'L99,999,999')
FROM EMPLOYEE
ORDER BY 2;

-- 날짜 -> 문자
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE) FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'DAY') FROM DUAL; 
SELECT TO_CHAR(SYSDATE, 'DY') FROM DUAL; -- DAY 입력하면 요일 전체 DY입력하면 '월' 이런식으로
SELECT TO_CHAR(SYSDATE, 'MONTH') FROM DUAL; 
SELECT TO_CHAR(SYSDATE, 'MON') FROM DUAL; 
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD(DY)') FROM DUAL; 

-- EMPLOYEE 테이블에서 직원명, 입사일(2022-05-02)
SELECT EMP_NAME AS "직원명",
       TO_CHAR(HIRE_DATE, 'YYYY"년"MM"월"DD"일"(DY)') AS "입사일"
FROM EMPLOYEE;

-- 날짜 포맷 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

-- 연도 포맷 문자
-- YY는 무조건 현재 세기를 반영하고, RR는 50미만이면 현재 세기를 반영, 50 이상이면 이전 세기를 반영한다.
SELECT TO_CHAR(SYSDATE, 'YYYY'), 
       TO_CHAR(SYSDATE, 'RRRR'),
       TO_CHAR(SYSDATE, 'YY'),
       TO_CHAR(SYSDATE, 'RR'),
       TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;

-- 월에 대한 포맷
SELECT HIRE_DATE, 
       TO_CHAR(HIRE_DATE, 'MM'),
       TO_CHAR(HIRE_DATE, 'MON'),
       TO_CHAR(HIRE_DATE, 'MONTH'),
       TO_CHAR(HIRE_DATE, 'RM') -- 로마 기호
FROM EMPLOYEE;

-- 일에 대한 포맷
SELECT HIRE_DATE,
       TO_CHAR(HIRE_DATE, 'DY'),
       TO_CHAR(HIRE_DATE, 'D'), -- 1주를 기준으로 며칠째
       TO_CHAR(HIRE_DATE, 'DD'), -- 1달을 기준으로 며칠째
       TO_CHAR(HIRE_DATE, 'DDD') -- 1년을 기준으로 며칠째
FROM EMPLOYEE;

-- 요일에 대한 포맷
SELECT HIRE_DATE,
       TO_CHAR(HIRE_DATE, 'DAY'),
       TO_CHAR(HIRE_DATE, 'DY')
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 입사일(2022-05-02(화)) 조회
SELECT EMP_NAME,
       TO_CHAR(HIRE_DATE, 'YYYY-MM-DD(DY)')
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 입사일(2022년 05월 02일(화요일)) 조회
SELECT EMP_NAME,
       TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"(DAY)')
FROM EMPLOYEE;

/*
    2) TO_DATE
        TO_DATE(숫자|문자[, 포맷])
*/

-- 숫자 -> 날짜
SELECT TO_DATE(20201212) FROM DUAL;
SELECT TO_DATE(20201212122530) FROM DUAL;

-- 문자 -> 날짜
SELECT TO_DATE('20201212') FROM DUAL;
SELECT TO_DATE('20201212 122530') FROM DUAL;
SELECT TO_DATE('20201212 222530', 'YYYYMMDD HH24MISS') FROM DUAL; -- 24시 기준으로 나오게 포맷 지정

-- YY와 RR 비교
-- YY는 무조건 현재 세기를 반영하고, RR는 50미만이면 현재 세기를 반영, 50 이상이면 이전 세기를 반영한다.
SELECT TO_DATE('220502', 'YYMMDD') FROM DUAL;
SELECT TO_DATE('980502', 'YYMMDD') FROM DUAL;

SELECT TO_DATE('220502', 'RRMMDD') FROM DUAL;
SELECT TO_DATE('980502', 'RRMMDD') FROM DUAL;

-- EMPLOYEE 테이블에서 1998년 1월 1일 이후에 입사한 사원의 사번, 직원명, 입사일 조회
SELECT  EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
--WHERE HIRE_DATE > TO_DATE('980101', 'RRMMDD');
--WHERE HIRE_DATE > TO_DATE('19980101', 'YYYYMMDD')
--WHERE HIRE_DATE > TO_DATE('19980101', 'RRRRMMDD')
WHERE HIRE_DATE > '19980101'
ORDER BY HIRE_DATE;

/*
    3) TO_NUMBER
        TO_NUMBER('문자값'[, 포맷])
*/
SELECT TO_NUMBER('012345678') FROM DUAL;

SELECT '123' + '456' FROM DUAL; -- 자동으로 숫자 타입으로 형 변환 뒤 연산처리를 한다.
SELECT '123' + '456A' FROM DUAL; -- ORACLE에서는 '+'는 무조건 산술 연산이라 에러남
SELECT '10,000,000' + '500,000' FROM DUAL; -- 에러 발생. ',' 가 포함되어 있어서

SELECT TO_NUMBER('10,000,000', '999,999,999') FROM DUAL;
SELECT TO_NUMBER('500,000', '9,999,999') FROM DUAL;

SELECT TO_NUMBER('10,000,000', '999,999,999') + TO_NUMBER('500,000', '9,999,999')
FROM DUAL;

SELECT *
FROM EMPLOYEE
WHERE EMP_ID >= 210;

-- 날짜 포맷 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

/*
    <NULL 처리 함수>
    
    1) NVL
        NVL(값1, 값2)
    
        - 값1이 NULL이 아니면 값1을 반환하고 값1이 NULL이면 값2를 반환한다.
    
    2) NVL2
        NVL2(값1, 값2, 값3)
    
        - 값1이 NULL이 아니면 값2를 반환하고 값이 NULL이면 값3을 반환한다.
    
    3) NULLIF
        NULLIF(값1, 값2)
        
        - 두 개의 값이 동일하면 NULL을 반환하고, 두 개의 값이 동일하지 않으면 값1을 반환한다.
*/

-- EMPLOYEE 테이블에서 직원명 보너스, 보너스가 포함된 연봉 조회
SELECT EMP_NAME, 
       NVL(BONUS, 0), 
       (SALARY + (SALARY * NVL(BONUS, 0))) * 12
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 부서 코드를 조회
SELECT EMP_NAME, NVL(DEPT_CODE, '부서없음')
FROM EMPLOYEE
ORDER BY DEPT_CODE DESC;

-- EMPLOYEE 테이블에서 보너스를 0.1로 동결하여 사원명, 보너스율, 동결된 보너스율, 보너스가 포함된 연봉 조회
SELECT EMP_NAME AS "직원명",
       NVL(BONUS, 0) AS "보너스율", 
       NVL2(BONUS, 0.1, 0) AS "동결된 보너스율", 
       (SALARY + (SALARY * NVL2(BONUS, 0.1, 0))) * 12 AS "연봉"
FROM EMPLOYEE;

SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '456') FROM DUAL;

SELECT NULLIF(123, 123) FROM DUAL;
SELECT NULLIF(123, 456) FROM DUAL;

/*
    <선택함수>
    
    1) DECODE
        DECODE(값, 조건 1, 결과값 1, 조건 2, 결과값 2, ..., 결과값 N)
*/

-- EMPLOYEE 테이블에서 사번, 직원명, 주민번호, 성별(남자, 여자)
SELECT EMP_ID AS "사번", 
       EMP_NAME AS "직원명", 
       EMP_NO AS "주민번호",
--       SUBSTR(EMP_NO, 8, 1)  
       DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남자', 2, '여자', '잘못된 주민번호입니다.') AS "성별"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 직급 코드, 기존 급여, 인상된 급여를 조회
-- 직급 코드가 J7인 직원은 급여를 10% 인상
-- 직급 코드가 J6인 직원은 급여를 15% 인상
-- 직급 코드가 J5인 직원은 급여를 20% 인상
-- 그 외의 직급의 직원은 급여를 5% 인상
SELECT EMP_NAME AS "직원명", 
       JOB_CODE AS "직급 코드", 
       SALARY AS "기존 급여",
       DECODE(JOB_CODE, 'J7', SALARY * 1.1, 'J6', SALARY * 1.15, 'J5', SALARY * 1.2, SALARY * 1.05) AS "인상된 급여"
FROM EMPLOYEE
ORDER BY JOB_CODE DESC;

/*
    2) CASE
        CASE WHEN 조건식 1 THEN 결과값 1
             WHEN 조건식 2 THEN 결과값 2
             ...
             ELSE 결과값
        END     
*/
-- EMPLOYEE 테이블에서 사번, 직원명, 주민번호, 성별(남자, 여자)
SELECT EMP_ID AS "사번",
       EMP_NAME AS "직원명",
       EMP_NO AS "주민번호",
       CASE WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남자'
            WHEN SUBSTR(EMP_NO, 8, 1) = '2' THEN '여자'
            ELSE '잘못된 주민번호 입니다.'
       END AS "성별"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 급여, 급여 등급(1 ~ 4 등급) 조회
-- SALARY 값이 500만원 초과일 경우 1 등급
-- SALARY 값이 500만원 이하 350만원 초과일 경우 2 등급
-- SALARY 값이 350만원 이하 200만원 초과일 경우 3 등급
-- 그 외의 경우 4 등급
SELECT EMP_NAME AS "직원명", 
       SALARY AS "급여",
       CASE WHEN SALARY > 5000000 THEN '1 등급'
            WHEN SALARY > 3500000  THEN '2 등급'
            WHEN SALARY > 2000000 THEN '3 등급'
            ELSE '4 등급'
       END AS "급여 등급"
FROM EMPLOYEE
ORDER BY SALARY DESC;

/*
    <그룹 함수>
        대량의 데이터들로 집계나 통계 같은 작업을 처리해야 하는 경우 사용되는 함수들이다.
        모든 그룹 함수는 NULL 값을 자동으로 제외하고 값이 있는 것들만 계산을 한다.
    
    1) SUM 
        SUM(NUMBER 타입의 컬럼)
        제시된 컬럼 값들의 합계를 반환한다.
*/

-- EMPLOYEE 테이블에서 전사원의 총 급여의 합계를 조회
SELECT TO_CHAR(SUM(SALARY), 'FML999,999,999') AS "급여 합계"-- FM 공백 제거
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 남자 사원의 총 급여의 합계를 조회
SELECT TO_CHAR(SUM(SALARY), 'FML99,999,999') 
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';

-- EMPLOYEE 테이블에서 여자 사원의 총 급여의 합계를 조회
SELECT TO_CHAR(SUM(SALARY), 'FML99,999,999')
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2';

-- EMPLOYEE 테이블에서 전 사원의 총 연봉의 합계를 조회
SELECT TO_CHAR(SUM(SALARY * 12), 'FML999,999,999') 
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 부서 코드가 D5인 사원들의 총 연봉의 합계를 조회
SELECT TO_CHAR(SUM(SALARY * 12), 'FML999,999,999') 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

/*
    2) AVG
        AVG(NUMBER 타입의 컬럼)
        제시된 컬럼 값들의 푱균값를 반환한다.
        모든 그룹 함수는 NULL 값을 자동으로 제외하기 때문에 AVG 함수를 사용할 때는 NVL 함수와 함께 사용하는 것을 권장한다.
*/

-- EMPLOYEE 테이블에서 전 사원의 급여의 평균을 조회
SELECT TO_CHAR(FLOOR(AVG(NVL(SALARY, 0))), 'FML99,999,999')
FROM EMPLOYEE;

/*
    3)MIN / MAX
        MIN/MAX(모든 타입의 컬럼)
        
        MIN : 제시된 컬럼 값들 중에 가장 작은 값을 반환한다.
        MAX : 제시된 컬럼 값들 중에 가장 큰 값을 반환한다.
*/
SELECT EMP_NAME,
       EMAIL,
       SALARY,
       HIRE_DATE
FROM EMPLOYEE;

-- 컬럼 별로 가장 작은 값을 반환
SELECT MIN(EMP_NAME), 
       MIN(EMAIL), 
       MIN(SALARY), 
       MIN(HIRE_DATE)
FROM EMPLOYEE;

-- 컬럼 별로 가장 큰 값을 반환
SELECT MAX(EMP_NAME), 
       MAX(EMAIL), 
       MAX(SALARY), 
       MAX(HIRE_DATE)
FROM EMPLOYEE;

/*
    4) COUNT 함수
        COUNT(*|[DISTINCT] 컬럼명)
        
        COUNT(*) : 조회 결과에서 모든 행의 개수를 반환한다.
        COUNT(컬럼명) : 제시된 컬럼 값이 NULL이 아닌 행의 개수를 반환한다.
        COUNT(DISTINCT 컬럼명) : 제시된 컬럼 값의 중복을 제거한 행의 개수를 반환한다.
*/
-- EMPLOYEE 테이블에서 전체 사원의 수를 조회
SELECT COUNT(*) 
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 남자 사원의 수를 조회
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';

-- EMPLOYEE 테이블에서 보너스를 받는 직원의 수를 조회
-- NULL 값을 알아서 빼고 COUNT
SELECT COUNT(BONUS)
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

-- EMPLOYEE 테이블에서 퇴사한 직원의 수를 조회
SELECT COUNT(*) 
FROM EMPLOYEE
WHERE ENT_DATE IS NOT NULL;

SELECT COUNT(ENT_DATE)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 부서가 배치 된 사원의 수를 조회
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;

SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 현재 사원들이 속해있는 부서의 수를 조회
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 현재 사원들이 분포되어 있는 직급의 수를 조회
SELECT COUNT(DISTINCT JOB_CODE)
FROM EMPLOYEE;


