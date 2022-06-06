/*
    <TRIGGER>
        테이블이 DML(INSERT, UPDATE, DELETE) 구문에 의해 변경될 경우(테이블에 이벤트 발생 시)
        자동으로 실행될 내용을 정의해놓는 객체이다.
*/
-- EMPLOYEE 테이블에 새로운 행이 INSERT 될 때 '신입사원이 입사했습니다.' 메시지를 자동으로 출력하는 트리거를 생성
-- EMPLOYEE 테이블에 INSERT가 발생하면 그 이후에 트리거를 실행
CREATE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN 
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사했습니다.');
END;
/

-- EMPLOYEE 테이블에 새로운 사원을 INSERT 하기
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO) VALUES(SEQ_EMPID.NEXTVAL, '문인수', '030524-1122335');

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO) VALUES(SEQ_EMPID.NEXTVAL, '박노경', '050524-1234567');

/*
-- ROW TRIGGER
        트리거 생성 구문에 FOR EACH ROW 옵션을 기술해야 한다.
        > :OLD : 수정, 삭제 전 데이터에 접근가능
        > :NEW : 입력, 수정 후 데이터에 접근 가능
*/

-- EMPLOYEE 테이블에 UPDATE 수행 후 '업데이트 실행'메시지를 자동으로 출력
CREATE OR REPLACE TRIGGER TRG_02
AFTER UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('업데이트 실행');
    DBMS_OUTPUT.PUT_LINE('변경 전 : ' || :OLD.DEPT_CODE || '변경 후 : ' || :NEW.DEPT_CODE);
END;
/

-- EMPLOYEE 테이블에 부서 코드가 D9인 직원들의 부서 코드를 D3로 변경
-- TRIGGER에 FOR EACH가 실행이 되면 각 행마다 TRIGGER가 발생됨
UPDATE EMPLOYEE
SET DEPT_CODE = 'D3'
WHERE DEPT_CODE = 'D9';

ROLLBACK;

-- 상품 입/출고 관련 예시
-- 필요한 테이블 / 시퀀스 생성

-- 1. 상품에 대한 데이터를 보관할 테이블 (TB_PRODUCT)
CREATE TABLE TB_PRODUCT(
    PCODE NUMBER,           -- 상품코드
    PNAME VARCHAR2(150),    -- 상품명
    BRAND VARCHAR2(100),    -- 브랜드명
    PRICE NUMBER,           -- 가격
    STOCK NUMBER DEFAULT 0,  -- 재고
    CONSTRAINT TB_PRODUCT_PCODE_PK PRIMARY KEY(PCODE)
);

-- 상품코드(PK)가 중복되지 않게 새로운 번호를 발생하는 시퀀스 생성
CREATE SEQUENCE SEQ_PCODE;

INSERT INTO TB_PRODUCT VALUES (SEQ_PCODE.NEXTVAL, '갤럭시 S10', '삼성', 1000000, DEFAULT);
INSERT INTO TB_PRODUCT VALUES (SEQ_PCODE.NEXTVAL, '갤럭시 노트 20 울트라', '삼성', 1500000, DEFAULT);
INSERT INTO TB_PRODUCT VALUES (SEQ_PCODE.NEXTVAL, '아이폰 13 프로', '애플', 1350000, DEFAULT);

SELECT * FROM TB_PRODUCT;

-- 2. 상품 입/출고 상세 이력 테이블 생성 (TB_PRODETAIL)
CREATE TABLE TB_PRODETAIL (
    DCODE NUMBER,               -- 입출고 이력 코드
    PCODE NUMBER,               -- 상품 코드 (외래 키로 지정 TB_PRODUCT 테이블을 참조)
    AMOUNT NUMBER,              -- 수량
    STATUS VARCHAR2(10),        -- 상태(입고 / 출고)
    DDATE DATE DEFAULT SYSDATE, -- 상품 입/출고 일자
    CONSTRAINT TB_PRODETAIL_DCODE_PK PRIMARY KEY(DCODE),
    CONSTRAINT TB_PRODETAIL_PCODE_FK FOREIGN KEY(PCODE) REFERENCES TB_PRODUCT,
    CONSTRAINT TB_PRODETAIL_STATUS_CK CHECK(STATUS IN ('입고', '출고'))
);

-- 입출고 이력 코드(PK)가 중복되지 않게 새로운 번호를 발생하는 시퀀스 생성
CREATE SEQUENCE SEQ_DCODE;

-- 1번 상품이 어제 날짜로 10개 입고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 1, 10, '입고', '22/05/23');
-- 재고 수량도 변경해야 한다.
UPDATE TB_PRODUCT
SET STOCK = STOCK + 10
WHERE PCODE = 1;

-- 2번 상품이 오늘 날짜로 20개 입고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, 20, '입고', SYSDATE);
-- 재고 수량도 변경해야 한다.
UPDATE TB_PRODUCT
SET STOCK = STOCK + 20
WHERE PCODE = 2;

-- 3번 상품이 오늘 날짜로 5개 입고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, 5, '입고', DEFAULT);
-- 재고 수량도 변경해야 한다.
UPDATE TB_PRODUCT
SET STOCK = STOCK + 5
WHERE PCODE = 3;

-- 2번 상품이 오늘 날짜로 5개 출고
INSERT INTO TB_PRODETAIL(DCODE, PCODE, AMOUNT, STATUS) VALUES(SEQ_DCODE.NEXTVAL, 2, 5, '출고');
-- 재고 수량도 변경해야 한다.
UPDATE TB_PRODUCT
SET STOCK = STOCK - 5
WHERE PCODE = 2;


COMMIT;

-- TB_PRODETAIL 테이블에 데이터 삽입 시, TB_PRODUCT 테이블에 재고 수량이 자동으로 업데이트 되도록 트리거를 생성
-- TRIGGER 안에서는 TCL (COMMIT, ROLLBACK) 불가. 
CREATE OR REPLACE TRIGGER TRG_PRO_STOCK
AFTER INSERT ON TB_PRODETAIL
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE(:NEW.PCODE || ' ' || :NEW.STATUS || ' ' || :NEW.AMOUNT);
    
    -- 상품이 입고된 경우 (재고 증가)
    IF (:NEW.STATUS = '입고') THEN
        UPDATE TB_PRODUCT
        SET STOCK = STOCK + :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
    
    -- 상품이 출도된 경우 (재고 감소)
    IF (:NEW.STATUS = '출고') THEN
        UPDATE TB_PRODUCT
        SET STOCK = STOCK - :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
-- 트리거에서는 TCL 구문이 포함될 수 없다. 사용되는 테이블에서도 변화가 생기기 때문에 불가.
--    COMMIT;
--    ROLLBACK;
END;
/

-- 2번 상품이 오늘 날짜로 20개 입고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, 20, '입고', DEFAULT);

-- 2번 상품이 오늘 날짜로 28개 출고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, 28, '출고', DEFAULT);

SELECT * FROM TB_PRODUCT;
SELECT * FROM TB_PRODETAIL;

ROLLBACK;

