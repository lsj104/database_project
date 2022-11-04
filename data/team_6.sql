--교육생 정보 테이블
create table tblStudent (

    seq number primary key, --교육생 번호
    name varchar2(30) not null, --이름
    ssn varchar2(30) not null, --주민번호 뒷자리
    tel varchar(30), --전화번호
    registerDate varchar(30) --ㅡ등록일

);

drop table tblStudent cascade constraints;

--문서 추천 테이블
create table tblRecommend (

    seq number primary key, --일련번호
    recommendDoc varchar2(100) not null, --추천 문서 이름
    content varchar2(1000) not null, --내용
    s_seq number references tblStudent(seq) not null --교육생 번호
);

alter table tblRecommend
    add constraint tblRecommend_fk foreign key(s_seq) references tblStudent(seq);

--질문 게시판 테이블
create table tblQuestion (

    seq number primary key, --질문 번호
    title varchar2(300) not null, --질문 제목
    content varchar2(4000) not null, -- 질문 내용
    Q_date varchar2(30) not null, -- 작성 날짜
    s_seq number references tblStudent(seq) not null --교육생 번호
);

alter table tblQuestion
    add constraint tblQuestion_fk foreign key(s_seq) references tblStudent(seq);

drop table tblQuestion cascade constraints;

--출결 테이블
create table tblAttendance (

    seq number primary key, --일련번호
    A_date varchar2(30), --날짜
    studentStatus varchar2(30), --출결 상태
    s_seq number references tblStudent(seq) not null -- 교육생 번호
);

alter table tblAttendance
    add constraint tblAttendance_fk foreign key(s_seq) references tblStudent(seq);
--교사평가
create table tblTeacherScore(

	seq number primary key,
	score number not null,
	studentNum number not null references tblStudent(seq),
	teacherNum number not null references tblTeacher(seq),
	c_seq number not null references tblOpenCourse(seq)

);

alter table tblTeacherScore
    add constraint tblTeacherScore_fk foreign key(c_seq) references tblOpenCourse(seq);


--교육생 수강 정보
create table tblCourseInfo(

	seq number primary key,
	completeDate varchar2(30) ,
	outDate varchar2(30),
	s_seq number not null references tblStudent(seq),
	c_seq number references tblOpenCourse(seq)

);

alter table tblCourseInfo
    add constraint tblCourseInfo_fk foreign key(c_seq) references tblOpenCourse(seq);

--교사 정보
create table tblTeacher(

	seq number primary key,
	name varchar2(20) not null,
	ssn varchar2(20) not null,
	tel varchar(20) not null,
	classStatus varchar2(10),  --강의가능 여부(y,n)
	subject_seq number references tblSubject(seq)

);

alter table tblTeacher
    add constraint tblTeacher_fk foreign key(subject_seq) references tblSubject(seq);

-- 개설 과목
create table tblSubject (
    seq number primary key,
    subjectName varchar2(60) not null
);
drop table tblSubject cascade constraints;

-- 개설 과목 정보(공통)
create table TBLOPENCOURSESUBJECT (
    seq number primary key,
    name varchar2(100) not null,
    startDate varchar2(20) not null,
    endDate varchar2(20) not null,
    s_seq number not null references tblSubject(seq),
    c_seq number not null references tblOpenCourse(seq)

);

alter table TBLOPENCOURSESUBJECT
    add constraint TBLOPENCOURSESUBJECT_fk foreign key(s_seq) references tblSubject(seq)
 add constraint TBL_OPENCOURSESUBJECT_fk foreign key(c_seq) references tblOpenCourse(seq);

-- 교재
create table tblBook (
    seq number primary key,
    bookName varchar2(80) not null,
    publish varchar2(60) not null,
    s_seq number not null references tblSubject(seq)
);
alter table tblBook modify bookName varchar2(80);

alter table tblBook
    add constraint tblBook_fk foreign key(s_seq) references tblSubject(seq);

-- 공지사항
create table tblNotice (
    seq number primary key,
    title varchar2(20) not null,
    content varchar2(20) not null,
    n_date varchar2(20) not null,
    c_seq number references tblOpenCourse(seq)
);

alter table tblNotice modify title varchar2(4000);
alter table tblNotice modify content varchar2(4000);

alter table tblNotice
    add constraint tblNotice_fk foreign key(c_seq) references tblOpenCourse(seq);

drop table tblNotice cascade constraints;

-- 기업
create table tblCompany(
    seq number primary key,
    name varchar2(20),
    address varchar2(255)
);

-- tblCompany
alter table tblCompany modify name varchar2(100);

-- 수료생 게시판
create table tblCS_Review(
    seq number primary key,
    intReview varchar2(1000),
    EmpReview varchar2(1000),
    e_seq number references tblCompleteStudent(seq)
);


alter table tblCS_Review
    add constraint tblCS_Review_fk foreign key(e_seq) references tblCompleteStudent(seq);

-- 수료생
create table tblCompleteStudent(
    seq number primary key,
    cp_seq number references tblCompany(seq),
    c_seq number references tblOpenCourse(seq),
    stu_seq number not null references tblStudent(seq)
);

drop table tblCompleteStudent cascade constraints;

alter table tblCompleteStudent
    add constraint tblCS_Review_fk foreign key(stu_seq) references tblStudent(seq);

-- 개설 과정 정보
create table tblOpenCourse(
    seq number primary key,
    coursePeriod number,
    startDate varchar2(30),
    endDate varchar2(30),
    t_seq number references tblTeacher(seq),
    r_seq number references tblClassRoom(seq),
    course_seq number not null
);

drop table tblOpenCourse cascade constraints;

alter table tblOpenCourse
    add constraint tblOpenCourse_fk foreign key(r_seq) references tblClassRoom(seq);

-- 성적 입력및 조회 테이블
create table tblExamInfo (
    seq number not null primary key,
    score number null,
    s_seq number not null references tblStudent(seq),
    ex_seq not null references tblExam(seq)
);
alter table tblExamInfo
    add constraint tblExamInfo_fk foreign key(ex_seq) references tblExam(seq);

drop table tblExamInfo cascade constraints;


alter table tblExamInfo
    add constraint tbl_ExamInfo_fk foreign key(ex_seq) references tblExam(seq);

-- 시험 테이블
--drop table tblExam cascade constraints;
create table tblExam (
    seq number not null primary key,
    exDate varchar2(20) not null,
    c_seq number not null references TBLOPENCOURSESUBJECT(seq)
);

-- 댓글 테이블
create table tblReply (
    seq number not null primary key,
    reply varchar2(4000) not null,
    q_seq number not null references tblQuestion(seq),
    t_seq number not null references tblTeacher(seq)
);

alter table tblReply
    add constraint tbl_Reply_fk foreign key(t_seq) references tblTeacher(seq);

drop table tblReply cascade constraints;

-- 강의실 정보 테이블
create table tblClassRoom (
    seq number not null primary key,
    maxNum number not null
);

--과정 설계
create table tblCourse(
	seq number primary key,
	c_seq number not null,
	studentNum number not null
);

--개설과목정보 컬럼 수정
--alter table TBLSUBJECTINFO drop column name;


--개절 과목 정보 > (개설과정 > 과목정보), tblSubjectInfo > tblOpenCourseSubject 이름변경
--alter table tblSubjectInfo rename to tblOpenCourseSubject;


--과정 설계 + 과목
create table tblCourseSubject(
	seq number primary key,
	course_seq number not null,
	s_seq number not null,

	constraint courseSeq_fk foreign key(course_seq) references tblCourse(seq),
	constraint sSeq_fk foreign key(s_seq) references tblOpenCourseSubject(seq)
);

alter table tblCourseSubject
    add constraint tblCourseSubject_fk foreign key(s_seq) references tblOpenCourseSubject(seq);

create table tblAvailableSub(
	seq number primary key,
	t_seq number references tblTeacher(seq),
	su_seq number references tblSubject(seq)
);


alter table tblTeacher drop column subject_seq;

















select * from tblStudent;
select * from tblExamInfo where seq = 1;

-- select * from tblBonus b inner join tblInsa i on i.num = b.num;

Select
    *
from tblExamInfo EI
    right outer join tblStudent S
        on EI.s_seq = S.seq
            where S.seq = 1;

select distinct
    s.name as 이름, sub.subjectName as 과목, e.score as 점수, s.seq
from tblStudent s, tblExamInfo e, tblSubject sub, tblExam ex, tblOpenCourseSubject ocs
where s.seq = e.s_seq and e.ex_seq = ex.seq and ex.c_seq = sub.seq
order by s.seq;

select * from tblExam;
select * from tblExamInfo where s_seq=1;
select * from tblSubject;
select * from tblOpenCourseSubject;
select * from tblCourseInfo;
select * from tblCourse;
select * from tblTeacher;
select * from tblSubject;
select * from tblOpenCourse;

select * from tblCompleteStudent;


select * from tblAvailableSub;

select * from tblAttendance;


















































































