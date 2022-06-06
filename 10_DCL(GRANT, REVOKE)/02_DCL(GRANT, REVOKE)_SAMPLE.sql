-- CREATE TABLE 권한이 없기 때문에 오류가 발생
-- 테이블 스페이스를 할당 받지 않았기 때문에 오류가 발생한다.
CREATE TABLE TEST (
    TID NUMBER
);

-- 계정이 소유하고 있는 테이블들은 바로 조작이 가능하다.
SELECT * FROM TEST;
INSERT INTO TEST VALUES(1);
DROP TABLE TEST;

-- 다른 계정의 테이블에 접근할 수 있는 권한이 없기 때문에 오류가 발생한다.
SELECT * FROM KH.EMPLOYEE;

SELECT * FROM KH.DEPARTMENT;

INSERT INTO KH.DEPARTMENT 
VALUES ('D0', '비서실', 'L1');

ROLLBACK;

SELECT * FROM KH.LOCATION;
SELECT * FROM STUDY.TB_CLASS;

-- 계정 권한 조회
SELECT * FROM USER_SYS_PRIVS;