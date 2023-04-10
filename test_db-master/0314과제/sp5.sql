-- 5. 출판사별로 도서의 평균가보다 비싼 도서의 이름을 보이시오.
 -- (예를 들어 A 출판사 도서의 평균가가 20,000원이 라면 A 출판사 도서 중 20,000원 이상인 도서를 보이면 된다).
 /* 참고
select b1.bookname from Book b1
where b1.price> (select avg(b2.price) from Book b2 where b2.publisher = b1.publisher);
*/
 drop procedure if exists db0220.expence;
DELIMITER &&
CREATE PROCEDURE expence()
BEGIN
    SELECT b1.bookname
    FROM Book b1
    WHERE b1.price  > (SELECT AVG(b2.price) FROM Book b2 WHERE b2.publisher = b1.publisher);
END &&
DELIMITER ;

-- 확인
call expence;