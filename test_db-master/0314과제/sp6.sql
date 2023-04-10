 -- 6.고객별로 도서를 몇 권 구입했는지와 총 구매액을 보이시오.
DROP PROCEDURE IF EXISTS `CustomerInfo`;

DELIMITER $$
CREATE PROCEDURE `CustomerInfo`()
BEGIN
    SELECT c.name, COUNT(o.bookid) AS '구입 권수', SUM(o.saleprice) AS '총 구매액'
    FROM Customer c
    LEFT JOIN Orders o ON c.custid = o.custid
    GROUP BY c.name;
END$$
DELIMITER ;

-- 확인
CALL CustomerInfo();