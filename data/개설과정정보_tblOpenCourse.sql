--tblOpenCourse
select * from tblOpenCourse;
--desc tblOpenCourse;

-- 교육생(개설과정번호, 과정기간, 시작일, 종료일, 교사번호, 강의실번호, )
insert into tblOpenCourse values(1, 7,   '2022-05-23', '2022-12-23', 1, 1, 1);
insert into tblOpenCourse values(2, 6,   '2022-06-20', '2022-12-16', 2, 2, 2);
insert into tblOpenCourse values(3, 7,   '2022-07-11', '2023-01-27', 3, 3, 3);
insert into tblOpenCourse values(4, 6,   '2022-07-28', '2023-01-25', 4, 4, 4);
insert into tblOpenCourse values(5, 5.5, '2022-08-08', '2023-01-20', 5, 5, 5);
insert into tblOpenCourse values(6, 5.5, '2022-09-19', '2023-02-27', 6, 6, 6);

-- 수료생
insert into tblOpenCourse values(7, 7,   '2021-05-24', '2021-12-24', 1, 1, 1);
insert into tblOpenCourse values(8, 6,   '2021-06-21', '2021-12-17', 2, 2, 2);
insert into tblOpenCourse values(9, 7,   '2021-07-12', '2022-01-28', 3, 3, 3);
insert into tblOpenCourse values(10, 6,  '2022-07-28', '2023-01-24', 4, 4, 4);
insert into tblOpenCourse values(11, 5.5, '2021-08-09', '2022-01-21', 5, 5, 5);
insert into tblOpenCourse values(12, 5.5, '2021-09-23', '2022-02-28', 6, 6, 6);