-- 과정설계
--  tblCourse
alter table tblCourse rename column c_seq to courseName;
alter table tblCourse modify courseName varchar2(200);

insert into tblCourse values(1, '(클라우드 운영 관리)클라우드 컴퓨팅 엔지니어 양성 과정', 30);
insert into tblCourse values(2, '(디지털컨버전스)공공데이터를 활용한 Springframework기반 웹 개발자 양성과정', 30);
insert into tblCourse values(3, '(디지털컨버전스)Springframework, 클라우드 융합 웹 개발자 양성과정', 30);
insert into tblCourse values(4, 'Python 활용 빅데이터 기반 금융 솔루션 UI 개발자 양성과정', 26);
insert into tblCourse values(5, '(디지털컨버전스)AWS 클라우드 활용 자바(Java) Full-Stack 개발자 양성 과정', 26);
insert into tblCourse values(6, '(디지털컨버젼스)AWS 클라우드 활용 자바(Java) Full-Stack 개발자 양성 과정', 26);


select * from tblCourse;