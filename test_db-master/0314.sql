drop procedure if exists procedur_name;

-- 1. InsertBook() 프로시저를 수정하여 고객을 새로 등록하는 InsertCustomer() 프로시저를 작성하시오. 
use db0220; 
drop procedure if exists InsertCustomer;
delimiter // 
CREATE PROCEDURE InsertCustomer(  
IN myCustomerID INTEGER,   
IN myCustomerName VARCHAR(40),
IN myCustaddress VARCHAR(40),   
IN myCustphone INTEGER)
 BEGIN  
 INSERT INTO Customer(customerid, name, address, phone)    
 VALUES(myCustomerID, myCustomerName, myCustaddress, myCustphone);
 END; 
 // 
 delimiter ;
 /* 프로시저 InsertBook을 테스트하는 부분 */
 CALL InsertBook(13, '스포츠과학', '마당과학서적', 25000); 
 SELECT * FROM Book;
 
 -- 2. BookInsertOrUpdate() 프로시저를 수정하여 삽입 작업을 수행하는 프로시저를 작성하시오.
 --   삽입하려는 도서와 동일한 도서가 있으면 삽입하려는 도서의 가격이 높을 때만 새로운 값으로 변경한다.  
 use db0220;
 -- drop procedure if exists InsertCustomer;
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
 IF mycount!=0 THEN    
 SET SQL_SAFE_UPDATES=0; 
 /* DELETE, UPDATE 연산에 필요한 설정 문 */    
 UPDATE Book SET price = myPrice      
 WHERE bookname LIKE myBookName and price < myprice;  
 ELSE    
 INSERT INTO Book(bookid, bookname, publisher, price)      
 VALUES(myBookID, myBookName, myPublisher, myPrice);  
 END IF; 
 END; 
 //
 delimiter ;
 
 -- BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분 
 CALL BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 25000);
 SELECT * FROM Book; -- 15번 투플 삽입 결과 확인 
 -- BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분 
 CALL BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 20000); 
 SELECT * FROM Book; -- 15번 투플 가격 변경 확인
 
 
 -- 3. 출판사가 '이상미디어'인 도서의 이름과 가격을 보여주는 프로시저를 작성하시오
 
 /* 내가 푼건데 틀림
 drop procedure if exists db0220.show_books;
DELIMITER $$
CREATE PROCEDURE show_books()
BEGIN
    SELECT bookname, price
    FROM book
    WHERE publisher = '이상미디어';
END //
DELIMITER ;

CALL show_books();
*/

 drop procedure if exists db0220.show_books;
DELIMITER $$
CREATE PROCEDURE show_books()
BEGIN
	declare myname varchar(40);
    declare myprice int;
    declare endOfRow boolean default false;
    declare bookCusor cursor for select bookname, price 
    from book where publisher='이상미디어';
    declare continue handler for not found set endOfRow = True;
    open bookCusor;
    cusor_loop: loop
		fetch bookCusor into myname, myprice;
			if endOfRow then leave cusor_loop;
            end if;
            select myname, myprice;
		end loop cusor_loop;
	close bookCusor;
    end $$
DELIMITER ;

-- 확인
call show_books();

-- 쿼리문 버전
select bookname, price from Book where publisher='이상미디어';

select publisher, sum(saleprice) from Book,Orders where Book.bookid group by publisher;

select b1.bookname from Book b1
where b1.price> (select avg(b2.price) from Book b2 where b2.publisher = b1.publisher);
select custid, count(*) as 구매건수, sum(saleprice) from Orders group by custid;


-- 4. 출판사별로 출판사 이름과 도서의 판매 총액을 보이시오(판매 총액은 Orders 테이블에 있다)
 drop procedure if exists db0220.prices;
DELIMITER $$
CREATE PROCEDURE prices()
BEGIN
	SELECT Publisher, SUM(saleprice) AS TotalSales
    FROM Book
    JOIN Orders ON Book.bookid = Orders.bookid
    GROUP BY Publisher;
    end $$
DELIMITER ;
 call prices();
 
 
 -- 5. 출판사별로 도서의 평균가보다 비싼 도서의 이름을 보이시오.
 -- (예를 들어 A 출판사 도서의 평균가가 20,000원이 라면 A 출판사 도서 중 20,000원 이상인 도서를 보이면 된다).
select b1.bookname from Book b1
where b1.price> (select avg(b2.price) from Book b2 where b2.publisher = b1.publisher);

 DELIMITER //
CREATE PROCEDURE expence()
BEGIN
    SELECT b1.bookname
    FROM Book b1
    WHERE b1.publisher = publisherParam AND b1.price > (SELECT AVG(b2.price) FROM Book b2 WHERE b2.publisher = publisherParam);
END //
DELIMITER ;
 -- 6.고객별로 도서를 몇 권 구입했는지와 총 구매액을 보이시오.


-- 7.주문이 있는 고객의 이름과 주문 총액을 출력하고, 주문이 없는 고객은 이름만 출력하는 프로시저를 작성하시오.
drop procedure if exists  test_proc7;
delimiter //
CREATE PROCEDURE test_proc7
BEGIN
	declare done boolean default false;
    declare v_sum int;
    declare v_id int;
    declare v_name varchar(20);
    end;
-- 8. 고객의 주문 총액을 계산하여 20,000원 이상이면 '우수', 20,000원 미만이면 '보통'을 반환하는 함수 Grade()를 작성하시오. Grade()를 호출하여 고객의 이름과 등급을 보이는 SQL 문도 작성하시오.

delimiter // 
CREATE FUNCTION Grade( 
Price INTEGER) RETURNS INT 
BEGIN 
DECLARE myInterest INTEGER;
 -- 가격이 30,000원 이상이면 10%, 30,000원 미만이면 5% 
 IF Price >= 30000 THEN SET myInterest = Price * 0.1; 
 ELSE SET myInterest := Price * 0.05; 
 END IF; 
 RETURN myInterest; 
 END; // 
 delimiter ;
 -- ?
 drop procedure if exists Grade;
 delimiter // 
CREATE FUNCTION Grade(cid INTEGER) RETURNS varchar(10) 
BEGIN 
DECLARE total INT;
  SELECT SUM(saleprice) INTO total FROM orders WHERE custid = cid;
    IF total_amount >= 20000 THEN
        RETURN '우수';
    ELSE
        RETURN '보통';
    END IF;
END; // 
 delimiter ;
 
 select name, Grade(custid) as total from customer;
-- select custid,orderid,saleprice,func_Interast(saleprice) interest from price;

--  교수님 정답
select name, Grade(custid) as total from Customer;

