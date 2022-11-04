--A005. 관리자
--1. 시험 성적 출력: 교육생 정보(학생번호, 이름, 등록일), 과목명, 점수
Select distinct s.seq           as 학생번호,
       S.name          as 이름,
       s.REGISTERDATE  as 등록일,
       SUb.subjectname as 과목명,
       EI.score        as 점수


from tblExamInfo EI
         inner join tblStudent S
                          on EI.s_seq = S.seq
         inner join tblExam EX
                          on EI.ex_seq = EX.seq
         inner join tblopencoursesubject OpenCS
                          on EX.c_seq = OpenCS.seq
         inner join tblSubject Sub
                          on OpenCS.s_seq = Sub.seq
order by s.SEQ asc;

--2. 교육생 개인별 성적 출력: where절에 원하는 학생 번호 입력
Select s.seq           as 학생번호,
       S.name          as 이름,
       s.REGISTERDATE  as 등록일,
       SUb.subjectname as 과목명,
       EI.score        as 점수


from tblExamInfo EI
         right outer join tblStudent S
                          on EI.s_seq = S.seq
         right outer join tblExam EX
                          on EI.ex_seq = EX.seq
         right outer join tblopencoursesubject OpenCS
                          on EX.c_seq = OpenCS.seq
         right outer join tblSubject Sub
                          on OpenCS.s_seq = Sub.seq
where s.SEQ = 1;

--3. 전체 학생중 점수가 등록되지 않은 학생의 정보와 과목명 출력
Select s.seq           as 학생번호,
       S.name          as 이름,
       s.REGISTERDATE  as 등록일,
       SUb.subjectname as 과목명,
       EI.score        as 점수

from tblExamInfo EI
         right outer join tblStudent S
                          on EI.s_seq = S.seq
         right outer join tblExam EX
                          on EI.ex_seq = EX.seq
         right outer join tblopencoursesubject OpenCS
                          on EX.c_seq = OpenCS.seq
         right outer join tblSubject Sub
                          on OpenCS.s_seq = Sub.seq
where ei.SCORE is null;

select distinct s.NAME
from TBLSTUDENT s
         join TBLATTENDANCE at
              on s.SEQ = at.S_SEQ
where S_SEQ = 216
group by s.NAME, at.STUDENTSTATUS;

--B003. 교사
--2. 교사 권한으로 담당하는 반 학생들의 성적을 과목별로 출력
Select s.seq           as 학생번호,
       S.name          as 이름,
       s.REGISTERDATE  as 등록일,
       SUb.subjectname as 과목명,
       EI.score        as 점수


from tblExamInfo EI
         right outer join tblStudent S
                          on EI.s_seq = S.seq
         right outer join tblExam EX
                          on EI.ex_seq = EX.seq
         right outer join tblopencoursesubject OpenCS
                          on EX.c_seq = OpenCS.seq
         right outer join tblSubject Sub
                          on OpenCS.s_seq = Sub.seq
where s.SEQ between 1 and 30
  and sub.SUBJECTNAME = 'Java'
order by s.SEQ asc;

-- 3.시험 응시여부 출력: 응시함 O, 응시안함 X
Select s.seq           as 학생번호,
       S.name          as 이름,
       s.REGISTERDATE  as 등록일,
       SUb.subjectname as 과목명,
       case
           when ei.SCORE is null then 'X'
           else 'O'
           end         as 응시여부

from tblExamInfo EI
         right outer join tblStudent S
                          on EI.s_seq = S.seq
         right outer join tblExam EX
                          on EI.ex_seq = EX.seq
         right outer join tblopencoursesubject OpenCS
                          on EX.c_seq = OpenCS.seq
         right outer join tblSubject Sub
                          on OpenCS.s_seq = Sub.seq
where s.SEQ between 1 and 30
order by s.SEQ asc;

--C001. 교육생
--교육생 로그인 화면: 학생번호, 이름, 과정명, 과정기간(시작 년월일, 끝 년월일), 교사명, 강의실이 타이틀로 출력
select distinct st.SEQ                              as 학생번호,
                st.NAME                             as 이름,
                c.COURSENAME                        as 과정명,
                oc.STARTDATE || ' ~ ' || oc.ENDDATE as 과정기간,
                tc.NAME                             as 교사명,
                oc.R_SEQ                            as 강의실명

from TBLOPENCOURSE oc
         inner join TBLCOURSEINFO ci
                    on oc.SEQ = ci.C_SEQ
         inner join TBLSTUDENT st
                    on ci.S_SEQ = st.SEQ
         inner join TBLCOURSE c
                    on c.SEQ = oc.COURSE_SEQ
         inner join TBLTEACHER tc
                    on tc.SEQ = oc.T_SEQ
where st.SEQ = 300
order by st.SEQ asc;

--교육생 개인 성적 조회: 학생번호, 이름, 과목명, 과목기간(시작일(YYYY-MM-DD), 종료일(YYYY-MM-DD), 시험날짜, 성적
select distinct st.SEQ                                      as 학생번호,
                st.NAME                                     as 이름,
                SUb.subjectname                             as 과목명,
                OpenCS.STARTDATE || ' ~ ' || OpenCS.ENDDATE as 과목기간,
                ex.EXDATE                                   as 시험날짜,
                ei.SCORE                                    as 성적


from TBLOPENCOURSE oc
         inner join TBLCOURSEINFO ci
                    on oc.SEQ = ci.C_SEQ
         inner join TBLSTUDENT st
                    on ci.S_SEQ = st.SEQ
         inner join TBLCOURSE c
                    on c.SEQ = oc.COURSE_SEQ
         inner join TBLTEACHER tc
                    on tc.SEQ = oc.T_SEQ
         inner join TBLEXAMINFO ei
                    on st.SEQ = ei.S_SEQ
         inner join tblExam EX
                    on EI.ex_seq = EX.seq
         inner join tblopencoursesubject OpenCS
                    on EX.c_seq = OpenCS.seq
         inner join tblSubject Sub
                    on OpenCS.s_seq = Sub.SEQ

where st.SEQ = 1
order by st.SEQ asc;

--B002. 교사 (출석)
select st.NAME,
       20 +
       count(case
                 when TBLATTENDANCE.STUDENTSTATUS = '지각' then 1
                 when TBLATTENDANCE.STUDENTSTATUS = '외출' then 1
                 when TBLATTENDANCE.STUDENTSTATUS = '조퇴' then 1
                 when TBLATTENDANCE.STUDENTSTATUS = '결석' then 3
           end) * -1 as 출석점수
from TBLSTUDENT st
         inner join TBLATTENDANCE
                    on st.SEQ = TBLATTENDANCE.S_SEQ
where st.SEQ = 216
group by st.NAME;

-- 관리자 질문게시판: 전체 조회
select q.SEQ     as 번호,
       st.NAME   as 작성자,
       q.Q_DATE  as 작성일,
       q.TITLE   as 제목,
       q.CONTENT as 내용,
       r.REPLY   as 답변,
       tc.NAME   as 교사명
from TBLREPLY r
         inner join TBLQUESTION q on q.SEQ = r.Q_SEQ
         inner join TBLSTUDENT st
                    on q.S_SEQ = st.SEQ
         inner join TBLTEACHER tc
                    on r.T_SEQ = tc.SEQ;

-- 관리자 질문, 답변 삭제
delete
from TBLREPLY
where Q_SEQ = 1;
delete
from TBLQUESTION
where SEQ = 1;

-- 교사 질문게시판: 담당 학생이 작성한 글, 답변 조회
select q.SEQ     as 번호,
       st.NAME   as 작성자,
       q.Q_DATE  as 작성일,
       q.TITLE   as 제목,
       q.CONTENT as 내용,
       r.REPLY   as 답변,
       tc.NAME   as 교사명
from TBLREPLY r
         inner join TBLQUESTION q on q.SEQ = r.Q_SEQ
         inner join TBLSTUDENT st
                    on q.S_SEQ = st.SEQ
         inner join TBLTEACHER tc
                    on r.T_SEQ = tc.SEQ
where st.SEQ between 1 and 30;

--교사: 답글 삭제
delete
from TBLREPLY
where Q_SEQ = 1;

--교사: 답글 수정
update TBLREPLY
set REPLY = 'aaa'
where Q_SEQ = 1;

-- 답글 등록
-- insert into TBLREPLY (SEQ, REPLY, Q_SEQ, T_SEQ) VALUES (댓글번호, 답글내용, 질문번호, 교사번호)


-- 교육생 질문게시판: 본인이 작성한 글 조회
select q.SEQ     as 번호,
       st.NAME   as 작성자,
       q.Q_DATE  as 작성일,
       q.TITLE   as 제목,
       q.CONTENT as 내용,
       r.REPLY   as 답변,
       tc.NAME   as 교사명
from TBLREPLY r
         inner join TBLQUESTION q on q.SEQ = r.Q_SEQ
         inner join TBLSTUDENT st
                    on q.S_SEQ = st.SEQ
         inner join TBLTEACHER tc
                    on r.T_SEQ = tc.SEQ
where st.SEQ = 1;

-- 학생 질문게시판: 같은반 학생들이 작성한 질문 조회
select q.SEQ     as 번호,
       st.NAME   as 작성자,
       q.Q_DATE  as 작성일,
       q.TITLE   as 제목,
       q.CONTENT as 내용,
       r.REPLY   as 답변,
       tc.NAME   as 교사명
from TBLREPLY r
         inner join TBLQUESTION q on q.SEQ = r.Q_SEQ
         inner join TBLSTUDENT st
                    on q.S_SEQ = st.SEQ
         inner join TBLTEACHER tc
                    on r.T_SEQ = tc.SEQ
where st.SEQ between 143 and 168;

--학생: 질문 삭제
delete
from TBLQUESTION
where SEQ = 1;

--학생: 질문 수정
update TBLQUESTION
set CONTENT = 'aaa'
where SEQ = 1;


select
    q.SEQ as 번호,
        TBLSTUDENT.NAME as 작성자,
    TITLE as 제목,
    CONTENT as 내용,
    Q_DATE as 작성일

    from TBLQUESTION q
inner join TBLSTUDENT
on TBLSTUDENT.SEQ = q.S_SEQ;

select
        Q_SEQ as 질문번호,
    REPLY as 내용,
    NAME as 교사명

    from TBLREPLY r
inner join TBLTEACHER
on r.T_SEQ = TBLTEACHER.SEQ
order by Q_SEQ asc ;

