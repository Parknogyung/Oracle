CREATE TABLE TB_PUBLISHER(
    PUB_NO NUMBER,
    PUB_NAME VARCHAR2(20) NOT NULL,
    PHONE VARCHAR2(20),
    CONSTRAINT PUB_NO_PK PRIMARY KEY(PUB_NO)
);

COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사 번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사 전화번호';

INSERT INTO TB_PUBLISHER VALUES(1, '배움', '01093414077');
INSERT INTO TB_PUBLISHER VALUES(2, '미르', '01062712708');
INSERT INTO TB_PUBLISHER VALUES(3, '라리', '01033224455');

DROP TABLE TB_BOOK;

CREATE TABLE TB_BOOK(
    BK_NO NUMBER,
    BK_TITLE VARCHAR2(20) NOT NULL,
    BK_AUTHOR VARCHAR2(20) NOT NULL,
    BK_PRICE VARCHAR2(20),
    BK_PUB_NO NUMBER,
    CONSTRAINT BK_NO_PK PRIMARY KEY(BK_NO),
    CONSTRAINT BK_PUB_NO_FK FOREIGN KEY(BK_PUB_NO) REFERENCES TB_PUBLISHER ON DELETE CASCADE
);

COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사 번호';

INSERT INTO TB_BOOK VALUES (1, '노인과바다', '해밍웨이', '23000', 1);
INSERT INTO TB_BOOK VALUES (2, '인피니티', '몰라', '20000', 1);
INSERT INTO TB_BOOK VALUES (3, '인피니티워', '몰라용', '21000', 2);
INSERT INTO TB_BOOK VALUES (4, '인피니티워1', '몰라용2', '21000', 3);
INSERT INTO TB_BOOK VALUES (5, '인피니티워3', '몰라용3', '25000', 2);

DROP TABLE TB_MEMBER;

CREATE TABLE TB_MEMBER(
        MEMBER_NO NUMBER,
        MEMBER_ID VARCHAR2(20),
        MEMBER_PWD VARCHAR2(20) NOT NULL,
        MEMBER_NAME VARCHAR2(10) NOT NULL,
        GENDER VARCHAR2(3),
        ADDRESS VARCHAR(40),       
        PHONE VARCHAR2(12),       
        STATUS VARCHAR2(1) DEFAULT 'N',
        ENROLL_DATE DATE DEFAULT SYSDATE NOT NULL,
        CONSTRAINT MEMBER_NO_PK PRIMARY KEY (MEMBER_NO),
        CONSTRAINT MEMBER_ID_UN UNIQUE(MEMBER_ID),
        CONSTRAINT GENDER_CK CHECK(GENDER IN ('M', 'F')),
        CONSTRAINT STATUS_CH CHECK(STATUS IN ('N', 'Y'))
);

COMMENT ON COLUMN TB_MEMBER.MEMBER_NO IS '회원번호'; 
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID IS '아이디'; 
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '비밀번호'; 
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME IS '회원이름'; 
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별'; 
COMMENT ON COLUMN TB_MEMBER.ADDRESS IS '주소'; 
COMMENT ON COLUMN TB_MEMBER.PHONE IS '전화번호'; 
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴여부'; 
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일'; 

INSERT INTO TB_MEMBER VALUES (1, 'ASDF', '1234', '박노경', 'M', '서울시 중랑구', '01075354528', 'Y', DEFAULT);
INSERT INTO TB_MEMBER VALUES (2, 'ASDF1', '12345', '박정식', 'M', '서울시 중구', '01040354528', 'N', '20201102');
INSERT INTO TB_MEMBER VALUES (3, 'ASDF2', '12347', '박노순', 'F', '서울시 종로구', '01064352528', 'N', '20190822');

CREATE TABLE TB_RENT(
    RENT_NO NUMBER,
    RENT_MEM_NO NUMBER,
    RENT_BOOK_NO NUMBER,
    RENT_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT RENT_NO_PK PRIMARY KEY(RENT_NO),
    CONSTRAINT RENT_MEM_NO_FK FOREIGN KEY (RENT_MEM_NO) REFERENCES TB_MEMBER ON DELETE SET NULL,
    CONSTRAINT RENT_BOOK_NO_FK FOREIGN KEY (RENT_BOOK_NO) REFERENCES TB_BOOK ON DELETE SET NULL
);

COMMENT ON COLUMN TB_RENT.RENT_NO IS '대여번호';
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO IS '대여 회원번호';
COMMENT ON COLUMN TB_RENT.RENT_DATE IS '대여 회원번호';


INSERT INTO TB_RENT VALUES (1, 1, 1, DEFAULT);
INSERT INTO TB_RENT VALUES (2, 2, 2, '20201123');
INSERT INTO TB_RENT VALUES (3, 3, 3, DEFAULT);