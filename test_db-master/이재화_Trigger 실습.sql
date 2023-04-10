-- [입고] 테이블에 상품이 입고되면 상품 테이블에 상품의 재고수량이 수정되는 트리거
-- -트리거명:afterinsert입고
delimiter //
CREATE TRIGGER afterinsert입고
after insert on 입고 for each row
begin
	update 상품
    set 재고수량 = 재고수량 + new.입고수량
    where 상품코드 = new.상품코드;
end;//
delimiter ;

-- INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES ('AAAAAA', '디카', '삼싱', 100000);
DROP TRIGGER afterinsert입고;

-- [입고] 테이블에 수량이 수정되면 [상품] 테이블에 상품의 재고수량이 수정되는 트리거
-- -트리거명:afterUpdate입고
delimiter //
create trigger afterUpdate입고
after update on 입고 for each row
begin
	update 상품
    set 재고수량 = 재고수량 - old.입고수량 + new.입고수량
    where 상품코드 = new.상품코드;
end;//
delimiter ;
    
update 입고 set 입고수량 = 30 where 입고번호 = 1;

-- [입고]테이블에서 삭제(취소)되면 [상품]테이블에서 재고수량을 수정하는 트리거
-- -트리거명:afterDelete입고

delimiter //
create trigger afterDelete입고
after update on 입고 for each row
begin
	update 상품
    set 재고수량 = 재고수량 - old.입고수량
    where 상품코드 = old.상품코드;
end;//
delimiter ;

-- [판매]테이블에 자료가 추가되면 [상품]테이블에 상품의 재고수량이 변경되는 트리거
-- -트리거명:beforeinsert판매
delimiter //
create trigger beforeinsert판매
before update on 판매 for each row
begin
	update 상품
    set 재고수량 = 재고수량 - new.판매수량
    where 상품코드 = new.상품코드;
end;//
delimiter ;

-- [판매]테이블에 자료가 변경되면 [상품]테이블에 상품의 재고수량이 변경되는 트리거
-- -트리거명:beforeUpdate판매
delimiter //
create trigger beforeUpdate판매
before update on 판매 for each row
begin
	update 상품
    set 재고수량 = 재고수량 + old.판매수량-new.판매수량
    where 상품코드 = new.상품코드;
end;//
delimiter ;