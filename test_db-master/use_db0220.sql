use db0220; 
delimiter //
CREATE PROCEDURE InsertBook(
	IN myBookID INTEGER, 
    IN myBookName VARCHAR(40), 
    IN myPublisher VARCHAR(40), 
    IN myPrice INTEGER) 
BEGIN 
INSERT INTO Book(bookid, bookname, publisher, price)
 VALUES(myBookID, myBookName, myPublisher, myPrice);
END;
 // 
 delimiter ;

/* 프로시저 InsertBook을 테스트하는 부분 */ 
CALL InsertBook(13, '스포츠과학', '마당과학서적', 25000);
SELECT * FROM Book;

use db0220
delimiter // 
CREATE PROCEDURE BookInsertOrUpdate( 
	myBookID INTEGER, 
    myBookName VARCHAR(40), 
    myPublisher VARCHAR(40), 
    myPrice INT) 
BEGIN 
	DECLARE mycount INTEGER; 
    SELECT count(*) INTO mycount FROM Book 
     WHERE bookname LIKE myBookName; 
	IF mycount!=0 THEN SET SQL_SAFE_UPDATES=0; /* DELETE, UPDATE 연산에 필요한 설정 문 */ 
     UPDATE Book SET price = myPrice
      WHERE bookname LIKE myBookName;
 ELSE 
	INSERT INTO Book(bookid, bookname, publisher, price) 
    VALUES(myBookID, myBookName, myPublisher, myPrice); 
 END IF; 
END; 
// 
delimiter ;

delimiter // 
CREATE PROCEDURE AveragePrice(OUT AverageVal INTEGER)
BEGIN
SELECT AVG(price) INTO AverageVal
FROM Book WHERE price IS NOT NULL;
END; 
//
 delimiter 
 
 
 -- 실습
 /*
create procedure `새학과`(
 in p학과번호 char(2),
 in p학과명 char(20),
 in p전화번호 char(20))
 begin
 insert into 학과(전화번호, 학과명, 전화번호) values (p전화번호,p학과명,p전화번호);
 end;
 */
 /*
CREATE PROCEDURE `학과_입력_수정` (
 in p학과번호 char(2),
 in p학과명 char(20),
 in p전화번호 char(20))
BEGIN
 -- 입력시 학과가 있는 경우는 업데이트로 하고 없는 경우 입력이 되는 프로시저
	declare cnt int; -- 변수 선언 
	select count(*) into cnt from 학과 where 학과번호 = p학과번호;
-- count값을 조건문으로
	if (cnt = 0) then -- 0 = 없는 학과, 1 = 있는 학과
		insert into 학과 values(p학과번호,p학과명,p전화번호);
	else 
		update 학과 set 학과명=p학과명, 전화번호 = p전화번호 where 학과번호 = p학과번호;
	end if;
END;
-- call 학과_입력_수정()

CREATE DEFINER=`root`@`localhost` PROCEDURE `통계`(
out 학생수 int,
out 과목수 int)
BEGIN
	-- declare cnt int; -- 변수 선언 
	-- select count(*) into cnt from 수강신청 where 학생수=p학생수 and 교수수=p교수수 and 과목수=p과목수;
    -- select count(*) as 학생수=p학생수 from 수강신청;
    select count(학번) into 학생수 from 수강신청;
    select count(distinct(과목번호)) into 과목수 from 수강신청내역;
END;
*/

-- CALL 통계(@a, @b);
-- SELECT @a AS 학생수, @b AS 과목수;

/*
CREATE DEFINER=`root`@`localhost` PROCEDURE `과목수강자수`(
in p과목번호 char(6),
out 수강자수 int
)
BEGIN
	select count(*) into 수강자수 from 수강신청내역 where 과목번호 = p과목번호;
END
*/
call 과목수강자수('K20002',@Count);
select @count;

/*
CREATE DEFINER=`root`@`localhost` PROCEDURE `새수강신청`(
in p학번 char(7),
out p수강신청번호 int
)
BEGIN
select max(수강신청번호) from 수강신청;
set p수강신청번호=p수강신청번호 +1;
insert into 수강신청(수강신청번호,학번,날짜,연도,학기) values(p수강신청번호,p학번curdate(),'2023','1');
END
*/

call 새수강신청('1810003', @수강신청번호);
select @수강신청번호;

delimiter //
CREATE PROCEDURE Interest() 
BEGIN 
	DECLARE myInterest INTEGER DEFAULT 0.0; 
    DECLARE Price INTEGER; 
    DECLARE endOfRow BOOLEAN DEFAULT FALSE; /* 행의 끝 여부 */ 
    DECLARE InterestCursor CURSOR FOR /* 커서 선언*/
		SELECT saleprice FROM Orders; 
	DECLARE CONTINUE handler /* 행의 끝일 때 Handler 정의 */ 
		FOR NOT FOUND SET endOfRow=TRUE;
	OPEN InterestCursor; /* 커서 열기 */ 
    cursor_loop: LOOP
		FETCH InterestCursor INTO Price;
        IF endOfRow THEN LEAVE cursor_loop;
        END IF; 
        IF Price >= 30000 THEN 
			SET myInterest = myInterest + Price * 0.1;
		ELSE SET myInterest = myInterest + Price * 0.05; 
			END IF; 
		END LOOP cursor_loop; 
        CLOSE InterestCursor; 
        SELECT CONCAT(' 전체 이익 금액 = ', myInterest); 
	END;
    //
    delimiter ;
    
CALL Interest();


CREATE TABLE Book_log(
 bookid_l INTEGER, 
 bookname_l VARCHAR(40), 
 publisher_l VARCHAR(40), 
 price_l INTEGER
 );
 
 delimiter //
CREATE TRIGGER AfterInsertBook 
AFTER INSERT ON Book FOR EACH ROW 
BEGIN
DECLARE average INTEGER; 
INSERT INTO Book_log 
VALUES(new.bookid, new.bookname, new.publisher, new.price); 
END;
// 
delimiter ;

/* 삽입한 내용을 기록하는 트리거 확인 */
INSERT INTO Book VALUES(14, '스포츠 과학 1', '이상미디어', 25000);
SELECT * FROM Book WHERE BOOKID=14; 
SELECT * FROM Book_log WHERE BOOKID_L='14' ; -- 결과 확인        
