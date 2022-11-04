create table tblAdmin(
    seq number primary key,
    name varchar2(30) not null,
    ssn varchar2(10) not null
);

select * from tblAdmin;

insert into tblAdmin values(1, '김영현', '1234567');
insert into tblAdmin values(2, '남태현', '1876543');
insert into tblAdmin values(3, '임수진', '2028491');
insert into tblAdmin values(4, '양하은', '2209182');
insert into tblAdmin values(5, '홍서진', '2048291');