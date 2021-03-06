S-- 한 줄 주석
/*
    여러 줄 주석
*/

-- 사용자 계정 생성하는 구문
-- [표현법] CREATE USER 계정명 IDENTIFIED BY 비밀번호;
CREATE USER KH IDENTIFIED BY KH;
CREATE USER STUDY IDENTIFIED BY STUDY;
CREATE USER BOOK IDENTIFIED BY BOOK;

SELECT * FROM DBA_USERS;

-- 생성한 사용자 계정에게 최소한의 권한(데이터관리, 접속) 부여
GRANT RESOURCE, CONNECT TO KH;
GRANT RESOURCE, CONNECT TO STUDY;
GRANT RESOURCE, CONNECT TO BOOK;

-- 관리자 계정으로 CREATE VIEW 권한을 부여한다
GRANT CREATE VIEW TO KH;