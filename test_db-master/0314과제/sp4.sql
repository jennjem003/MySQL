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