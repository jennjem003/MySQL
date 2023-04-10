-- 트렌젝션
commit;
rollback; -- 돌아간다.전부 정지시키고 다시 되돌아때 (뒤로가기 수동 기능 같은)/하나의 단위작업(트렌젝션)이 끝난다고 봄.

select @@autocommit; -- 자동커밋이 작동되서 쓰지 않았었음.

set autocommit=1;

create table book1 (select * from book);
create table book2 (select * from book);

delete from book1;
rollback;

start transaction;
delete from book1;
delete from book2;
rollback; 


-- -----------------------------------
start transaction;
savepoint A;
delete from book1;
savepoint B;
delete from book2;
rollback to savepoint B;
commit;
