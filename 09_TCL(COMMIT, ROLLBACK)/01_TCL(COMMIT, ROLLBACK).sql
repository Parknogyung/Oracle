/*
    <TCL(Transaction Control Language)>
        트랜잭션을 제어하는 언어이다.
        데이터베이스는 데이터의 변경 사항들(INSERT, UPDATE, DELETE)을 묶어서 하나의 트랜잭션에 담아서 처리한다.

        * 트랜잭션
            하나의 논리적인 작업 단위를 트랜잭션이라고 한다.
                EX) ATM에서 현금 출금
                    1. 카드 삽입
                    2. 메뉴 선택
                    3. 금액 확인 및 인증
                    4. 실제 계좌에서 금액만큼 인출
                    5. 현금 인출
                    6. 완료
            각각의 업무들을 묶어서 하나의 작업 단위로 만드는 것을 트랜잭션이라고 한다.
            
    <COMMIT>
        모든 작업들이 정상적으로 처리하겠다고 확정하는 구문이다.
        
    <ROLLBACK>
        모든 작업들을 취소 처리하겠다고 확정하는 구문이다. (마지막 COMMIT 시점으로 돌아간다.)
        
    <SAVEPOINT>
        저장점을 지정하고 ROLLBACK 진행 시 전체 작업을 ROLLBACK 하는게 아닌 SAVEPOINT 까지의 일부만 롤백한다.
          SAVEPOINT 포인트명;
          
          ...
          ROLLBACK TO 포인트명; -- 해당 포인트 지점까지의 트랜잭션만 롤백한다.
*/
-- 테스트용 테이블 생성
CREATE TABLE EMP_TEST
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE
    FROM EMPLOYEE;

-- EMP_TEST 테이블에서 EMP_ID가 213, 218인 사원 삭제    
--SELECT*
DELETE
FROM EMP_TEST
WHERE EMP_ID IN (213, 218);

-- 두 개의 행이 삭제된 시점에 SAVEPOINT 지정
SAVEPOINT SP1;

-- EMP_TEST 테이블에서 EMP_ID가 200인 사원 삭제
--SELECT *
DELETE
FROM EMP_TEST
WHERE EMP_ID = 200;

ROLLBACK TO SP1;

ROLLBACK;

SELECT * FROM EMP_TEST;

-- EMP_TEST 테이블에서 EMP_ID가 216인 사원 삭제
DELETE
FROM EMP_TEST
WHERE EMP_ID = 216;

-- DDL 구문 실행 시 변경사항들은 무조건 DB에 반영된다. (COMMIT 된다.)
CREATE TABLE TEST(
    TID NUMBER
); 

ROLLBACK;

SELECT * FROM EMP_TEST;