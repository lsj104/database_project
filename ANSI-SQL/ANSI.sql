-- 개설 과정 정보: 개설 과정 정보 번호, 과정 기간, 시작일, 종료일, 교사 번호, 강의실 번호, 과정 설계 번호
-- 관리자는 개설 과정 정보에 대한 입출력, 수정, 삭제 기능을 사용할 수 있어야한다.

-- 1. 개설 과정 등록
-- 개설 과정 번호, 과정 기간, 시작일, 종료일, 교사 번호, 강의실 번호, 과정 설계 번호
--insert into tblOpenCourse values(개설 과정 정보 번호, 과정 기간, 시작일, 종료일, 교사 번호, 강의실 번호, 과정 설계 번호);


-- 2. 개설 과정 조회
-- 해당 과정을 수료한 수료생 정보 출력 (중도 탈락자 제외) > 150명
-- (1). 해당 과정을 수료한 수료생 정보 출력 (과정 명, 과정 기간, 과정 등록일, 과정 시작일, 과정 종료일, 교사 번호, 강의실 번호, 수강인원, 교육생 번호, 주민등록번호 뒷자리, 전화번호)
select
    t.courseName as "과정명",
    o.CoursePeriod || '개월' as "과정 기간",
    s.registerDate as "등록일",
    o.startDate as "과정 시작일",
    o.endDate as "과정 종료일",
    r.name as "교사 이름",
    o.r_seq || '강의실' as "강의실",
    t.studentNum as "수강인원",
    s.name as "교육생 이름",
    c.stu_seq as "교육생 번호",
    to_number(s.ssn) as "주민등록번호 뒷자리",
    s.tel as "전화번호"
from tblOpenCourse o
    right outer join tblCompleteStudent c
        on o.seq = c.c_seq
            left outer join tblStudent s
                on s.seq = c.stu_seq
                    left outer join tblCourse t
                        on t.seq = o.course_seq
                            left outer join tblTeacher r
                                on r.seq = o.t_seq
                                    where  t.courseName is not null;


-- (2). 개설 과정의 세부 정보 출력(설계 번호, 과정 이름, 수강 인원 수 )
select
    distinct c.seq as "등록된 과정 설계 번호",
    c.courseName as "과정 이름",
    c.studentNum || '명' as "수강 인원 수"
from tblOpenCourse o
    inner join tblCourse c
        on c.seq = o.course_seq;


-- (3). 개설 과정의 강의실 정보 (과정 명 ,강의실 번호, 정원 수)
select
    distinct c.seq,
    c.courseName as "과정명",
    r.seq || '강의실'as "강의실 번호",
    r.maxNum || '명' as "정원 인원"
from tblClassRoom r
    inner join tblOpenCourse o
        on r.seq = o.r_seq
            inner join tblCourse c
                on c.seq = o.course_seq;


-- (4). 해당 개설 과정의 공지사항 출력 (공지사항 번호, 제목, 내용, 작성날짜, 개설 과정 정보 번호)
select
    n.seq as "공지사항 번호",
    n.title as "공지사항 제목",
    n.content as "공지사항 내용",
    n.n_date as "작성 날짜"
from tblOpenCourse o
    inner join tblNotice n
        on o.seq = n.c_seq;


-- (5). 과정을 가르치는 담당 교사에 대한 정보 (과정 이름,교사 번호, 교사 이름, 주민번호 뒷자리, 전화번호, 수강 가능 여부)
select
    distinct c.courseName as "과정명",
    t.seq as "담당 교사 번호",
    t.name as "담당 교사 이름",
    t.ssn as "주민등록번호 뒷자리",
    t.tel as "담당 교사 전화번호",
    t.classStatus as "수강 가능 여부(y,n)"
from tblOpenCourse o
    inner join tblTeacher t
        on t.seq = o.t_seq
            inner join tblCourse c
                on c.seq = o.course_seq;


-- (6). 대기중인 교사에 대한 정보 (교사 번호, 교사 이름, 주민번호 뒷자리, 전화번호, 수강 가능 여부)
select
    t.seq as "대기중인 교사 번호",
    t.name as "대기중인 교사 이름",
    t.ssn as "주민등록번호 뒷자리",
    t.tel as "전화번호",
    t.classStatus as "수강 가능 여부(y,n)"
from tblOpenCourse o
    right outer join tblTeacher t
        on t.seq = o.t_seq
            left outer join tblCourse c
                on c.seq = o.course_seq
                    where t.classStatus = 'y';


-- (7). 해당 과정 안의 과목들에 대한 정보 (개설 과목 정보 번호, 과목 시작일, 과목 종료일, 개설 과목 번호, 개설 과정 정보 번호)
select
    r.courseName as "개설 과정 이름",
    s.subjectName as "과목 이름",
    o.startDate as "과목 시작일",
    o.endDate as "과목 종료일"
from tblOpenCourse c
    inner join tblOpenCourseSubject o
        on c.seq = o.c_seq
            inner join tblSubject s
                on s.seq = o.s_seq
                    inner join tblCourse r
                        on r.seq = c.course_seq
                            where o.startDate < '2022-05-01'    --and <과정명>    과정명에는 관리자가 원하는 값 대입(원하는 과정에 대한 데이터만 sorting)      -- 수료생: 2021 ~ 2022.3월  / 교육생: 2022.05.23 ~ 2023.2월
                                order by o.startDate;


-- (8). 해당 과정의 교육생 수강 정보 (수강 정보 번호, 수료 날짜, 중도 탈락 날짜, 교육생 번호, 개설 과정 정보 번호)
select
    r.courseName as "개설 과정 이름",
    s.subjectName as "과목 이름",
    o.startDate as "과목 시작일",
    o.endDate as "과목 종료일"
from tblOpenCourse c
    inner join tblOpenCourseSubject o
        on c.seq = o.c_seq
            inner join tblSubject s
                on s.seq = o.s_seq
                    inner join tblCourse r
                        on r.seq = c.course_seq
                            where o.startDate > '2022-05-01'    --and <과정명>    과정명에는 관리자가 원하는 값 대입(원하는 과정에 대한 데이터만 sorting)      -- 수료생: 2021 ~ 2022.3월  / 교육생: 2022.05.23 ~ 2023.2월
                                order by o.startDate;


-- (9). 교사 평가 데이터 (교사 번호, 교사 평가 점수, 교육생 번호, 평가한 교육생 수)
select
    t.teacherNum as "교사 번호",
    round(avg(t.score),1) || '점' as "교사 평가 점수",
    count(*) || '명' as "평가한 인원 수"
from tblOpenCourse o
    inner join tblTeacherScore t
        on o.seq = t.c_seq
            inner join tblTeacher r
                on r.seq = t.teacherNum
                    group by t.teacherNum
                        having avg(t.score) > 1;

-- 3. 개설 과정 정보 수정
--update tblOpenCourse set <컬럼명> where <조건>;    -- <> 안의 컬럼명, 조건을 관리자가 원하는 데이터로 입력하여 출력가능하다.

--1. 개설 과목 정보 조회
--1.1 현재 진행중인 과목 정보 조회
select
    distinct
    s.seq as "과목 번호",
    s.subjectName as "과목명",
    b.bookName as "교재명"
from tblOpenCourseSubject o
    inner join tblSubject s
        on o.s_seq = s.seq
            inner join tblBook b
                on s.seq = b.s_seq;


--1.2 특정 개설 과정의 개설 과목 정보 조회
select
    oc.seq as "개설 과정 번호",
    c.courseName as "과정명",
    oc.startDate || ' ~ ' || oc.endDate as "과정기간",
    oc.r_seq || '강의실' as "강의실",
    s.subjectName as "과목명",
    ocs.startDate || ' ~ ' || ocs.endDate as "과목기간",
    b.bookName as "교재명",
    t.name as "교사명"
from tblCourse c
    inner join tblOpenCourse oc
        on c.seq = oc.course_seq
            inner join tblOpenCourseSubject ocs
                on oc.seq = ocs.c_seq
                    inner join tblSubject s
                        on ocs.s_seq = s.seq
                            inner join tblBook b
                                on s.seq = b.seq
                                    inner join tblTeacher t
                                        on oc.t_seq = t.seq
                                            where oc.seq = <개설 과정 정보 번호>

--2. 개설 과목 입력
insert into tblOpenCourseSubject values(

    (select max(seq) + 1 from tblOpenCourseSubject),
    '<과목 시작일>’,
    '<과목 종료일>’,
    <과목번호>,
    <과정번호>

);
--3. 개설 과목 수정
update tblSubject set subjectName = '<과목명>' where seq = <수정할 과목번호>;


--4. 개설 과목 삭제
--4.1 과목 삭제
delete from tblSubject where seq = <삭제할 과목번호>;

--4.2 과정 내 과목 삭제
delete from tblOpenCourseSubject where seq = <개설 과목 정보번호>;

--1. 교육생 정보 등록
INSERT into tblStudent(seq, name, ssn, tel, registerdate) VALUES( <교육생 번호>,
<교육생이름>, <교육생주민번호뒷자리>, <교육생전화번호>,<교육 등록일>);

--2. 교육생 정보 출력
select
    S.name as "이름",
    S.ssn as "주민번호 뒷자리",
    S.tel as "전화번호",
    s.registerdate as "등록일",
    OC.startdate as "과정 시작일",
    C.coursename as "과정이름"
from tblStudent S
    inner join tblCourseInfo CI
        on S.seq = CI.s_seq
        left outer join tblOpenCourse OC
            on CI.c_seq = OC.seq
                right outer join tblCourse C
                    on C.seq = OC.course_seq;

--3. 특정 교육생 선택 시 교육생이 신청한 과정명, 과정기간, 강의실, 수료여부 및 날짜 출력


--3-1.수료생 선택 시 교육생이 신청한 과정명, 과정기간, 강의실, 수료여부 및 날짜 출력
select
    S.name as "이름",
    C.coursename as "과정명",
    OC.coursePeriod as "과정 기간",
    CR.seq as "강의실",
    case
    when CS.c_seq is null then '미수료'
    end as "수료여부"
from tblCompleteStudent CS
    right outer join tblStudent S on CS.stu_seq = S.seq
    inner join tblOpenCourse OC
        on CS.c_seq = OC.seq
            right outer join tblCourse C on OC.course_seq = C.seq
            right outer join tblClassRoom CR on OC.r_seq = CR.seq
                where S.seq = <수료생 일련번호>;

--3-2. 특정 교육생 선택 시 교육생이 신청한 과정명, 과정기간, 강의실, 수료여부 및 날짜 출력
select
    S.name as "이름",
    C.coursename as "과정명",
    OC.coursePeriod as "과정 기간",
    CR.seq as "강의실",
    case
    when CS.c_seq is null then '미수료'
    end as "수료여부"
from tblCompleteStudent CS
    right outer join tblStudent S on CS.stu_seq = S.seq
    inner join tblOpenCourse OC
        on CS.c_seq = OC.seq
            right outer join tblCourse C on OC.course_seq = C.seq
            right outer join tblClassRoom CR on OC.r_seq = CR.seq
                where S.seq = <교육생 일련번호>;
--4. 교육생 정보에 대한 입력, 출력, 수정, 삭제 기능을 사용할 수 있어야 한다.
UPDATE tblStudent SET name = <이름>, tel = <학생 전화번호>, registerdate = <등록일자>
WHERE seq =  = <수정할 교육생 일련번호>);

--5. 선택 과정 교육생 정보확인
select
    S.name as "이름",
    C.courseName as "과정명"
from tblStudent S
    inner join tblCourseInfo CI
        on S.seq = CI.s_seq
            inner join tblOpenCourse OC
                on CI.c_seq = OC.seq
                    inner join tblCourse C
                        on OC.course_seq = C.seq
                            where C.coursename = '<과정명>';



--1. 시험 성적 출력: 교육생 정보(학생번호, 이름, 등록일), 과목명, 점수
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
order by s.SEQ asc;

--2. 교육생 개인별 출력: where절에 원하는 학생 번호 입력
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


--1. 출결 현황을 기간별(yyyy-mm-dd)조회 기능
select
    S.name as "이름",
    a.a_date as "날짜",
    a.studentstatus as "상태"
from tblAttendance A
    inner join tblStudent S
        on A.s_seq = S.seq
            where a_date between <해당날짜> and <해당 날짜>;

--2. 특정 인원 출결 현황을 조회할 수 있어야 한다.
select
    S.name as "이름",
    a.a_date as "날짜",
    a.studentstatus as "상태"
from tblAttendance A
    inner join tblStudent S
        on A.s_seq = S.seq
            where S.seq = <학생번호>;

--3. 모든 출결 조회는 근태 상황을 구분할 수 있어야 한다.(정상, 지각, 조퇴, 외출, 병가, 기타)
select
    S.name as "이름",
    a.a_date as "날짜",
    a.studentstatus as "상태"
from tblAttendance A
    inner join tblStudent S
        on A.s_seq = S.seq
            where A.studentStatus = <근태 상황>;

-- 자신이 진행하고 있는 과정의 과정명, 시작일(YYYY-MM-DD), 종료일(YYYY-MM-DD), 강의실, 교육생 등록 인원을 출력
select
	rownum as "번호",
	c.courseName as "과정명",
	oc.startDate as "시작일",
	oc.endDate as "종료일",
	oc.r_seq as "강의실",
	(select count(*) from tblcourseInfo where c_seq = oc.seq) as "등록인원"
		from tblOpenCourse oc
			right outer join tblTeacher t
				on oc.t_seq = t.seq
					inner join tblCourse c
						on oc.course_seq = c.SEQ
							where t.seq = 1;
-- 현재 진행 중인 과정에 속한 과목명, 과목기간(시작일(YYYY-MM-DD), 종료일(YYYY-MM-DD)),교재명을 출력
select
	sub.subjectName as "과목명",
	sNum.startDate as "시작일",
	sNum.endDate as "종료일",
	b.bookName as "교재명"
	from (
	select * from tblOpenCourseSubject where c_seq = (
		select course_seq from tblOpenCourse oc
			inner join tblTeacher t
				on oc.t_seq = t.seq
					where t.seq = 1 and oc.endDate > sysdate))sNum
						inner join tblSubject sub
							on sub.seq = sNum.s_seq
								inner join tblBook b
									on b.s_seq = sNum.s_seq
										order by startDate;

--교육중인 과정에 등록된 교육생 정보출력
select
	s.name,
	s.tel,
	s.registerDate,
	case
		when completeDate is null then '수료X'
		else '수료완료'
	end as "수료현황",
	case
		when outDate is not null then '탈락'
		else '교육중'
	end as "탈락현황"
		from (
		(select * from tblCourseInfo where c_seq = (
			select seq from tblOpenCourse
				where t_seq = 1 and endDate > sysdate)) info)
					inner join tblStudent s
						on s.seq = s_seq;


--1. 담당하는 학생의 출석 점수 조회: 이름, 출석점수
-- where절에 학생 번호 입력
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

--1. 성적 등록
insert into TBLEXAMINFO (SEQ, SCORE, S_SEQ, EX_SEQ) VALUES (성적 번호, 성적, 교육생번호, 시험 번호)
--2. 담당하는 반 학생들의 성적을 과목별로 출력
-- where s.SEQ between 학생번호 범위 and sub.SUBJECTNAME = '과목명'
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
where s.SEQ between 1 and 30 and sub.SUBJECTNAME = 'Java'
order by s.SEQ asc;

--3.시험 응시여부 출력: 응시함 O, 응시안함 X
Select s.seq           as 학생번호,
       S.name          as 이름,
       s.REGISTERDATE  as 등록일,
       SUb.subjectname as 과목명,
       case
           when ei.SCORE is null then 'X'
           else 'O'
           end as 응시여부

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

--4. 시험 날짜 추가
insert into TBLEXAM (SEQ, EXDATE, C_SEQ) VALUES (시험번호, 시험날짜, 개설 과목 정보 번호);



--1. 출결 현황을 기간별(yyyy-mm-dd)조회 기능
select
    S.name as "이름",
    a.a_date as "날짜",
    a.studentstatus as "상태"
from tblAttendance A
    inner join tblStudent S
        on A.s_seq = S.seq
            where a_date between <해당날짜> and <해당 날짜>;

--2. 특정 인원 출결 현황을 조회할 수 있어야 한다.
select
    S.name as "이름",
    a.a_date as "날짜",
    a.studentstatus as "상태"
from tblAttendance A
    inner join tblStudent S
        on A.s_seq = S.seq
            where S.seq = <학생번호>;

--3. 모든 출결 조회는 근태 상황을 구분할 수 있어야 한다.(정상, 지각, 조퇴, 외출, 병가, 기타)
select
    S.name as "이름",
    a.a_date as "날짜",
    a.studentstatus as "상태"
from tblAttendance A
    inner join tblStudent S
        on A.s_seq = S.seq
            where A.studentStatus = <근태 상황>;


--1. 교육생 로그인 화면: 학생번호, 이름, 과정명, 과정기간(시작 년월일, 끝 년월일), 교사명, 강의실이 타이틀로 출력
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

--2. 교육생 개인 성적 조회: 학생번호, 이름, 과목명, 과목기간(시작일(YYYY-MM-DD), 종료일(YYYY-MM-DD), 시험날짜, 성적
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

where st.SEQ = 300
order by st.SEQ asc;


--1.  매일의 출결 상태를 기록할 수 있어야 한다.
update tblAttendance set StudentStatus = <출결 상태> where s_seq = <학생번호>;

--2. 본인의 출결 현황을 기간별(전체, 월, 일) 조회할 수 있어야 한다.
select
    S.name as "이름",
    a.a_date as "날짜",
    a.studentstatus as "상태"
from tblAttendance A
    inner join tblStudent S
        on A.s_seq = S.seq
            where a_date between <해당날짜> and <해당 날짜>
                and S.seq = <학생 번호>;
--3. 모든 출결 조회는 근태 상황을 구분할 수 있어야 한다.(정상, 지각, 조퇴, 외출, 병가, 기타)
select
    S.name as "이름",
    a.a_date as "날짜",
    a.studentstatus as "상태"
from tblAttendance A
    inner join tblStudent S
        on A.s_seq = S.seq
            where A.studentStatus = <근태 상황>;

--교육과정에 대한 모든 교사 평가 정보 출력
select
	t.name as "이름",
	c.courseName as "과정이름",
	oc.startDate as "시작일",
	oc.endDate as "종료일",
	round(avg(score),1) as "평균점수"
	from tblOpenCourse oc
		inner join tblTeacher t
			on t.seq = t_seq
				inner join tblCourse c
					on c.seq = oc.course_seq
						inner join tblTeacherScore ts
								on oc.seq = ts.c_seq
									group by t.name, c.COURSENAME, oc.STARTDATE, oc.ENDDATE
										order by "평균점수" desc;


-- 교육과정에 대한 자기 자신의 평가 정보 출력
select
	t.name as "이름",
	c.courseName as "과정이름",
	oc.startDate as "시작일",
	oc.endDate as "종료일",
	round(avg(score),1) as "평균점수"
	from tblOpenCourse oc
		inner join tblTeacher t
			on t.seq = t_seq
				inner join tblCourse c
					on c.seq = oc.course_seq
						inner join tblTeacherScore ts
								on oc.seq = ts.c_seq
									where t.seq = 1
										group by t.name, c.COURSENAME, oc.STARTDATE, oc.ENDDATE
											order by "평균점수" desc;


--교육과정이 끝났을 때 행해지는 교사 평가
insert into tblTeacherScore (seq, score, studentNum, teacherNum, c_seq)
	values((select nvl(max(seq),0) + 1 from tblTeacherScore),
			5,
			1,
			(select t_seq from tblOpenCourse where seq = (select c_seq from tblCourseInfo where s_seq = 1)),
			(select c_seq from tblCourseInfo where s_seq = 1));


--1. 공지사항 조회
select
    n.seq as "공지사항 번호",
    n.title as "제목",
    n.content as "내용",
    n.n_date as "작성날짜",
    o.course_seq as "과정번호",
    t.name as "교사명"
from tblNotice n
    inner join tblOpenCourse o
        on n.c_seq = o.seq
            inner join tblTeacher t
                on o.t_seq = t.seq
                    where t.name like '<교사명>';


--2. 공지사항 등록
insert into tblNotice (

    seq,
    title,
    content,
    n_date,
    c_seq

) values (

    (select max(seq) + 1 from tblNotice),
    '<공지사항 제목>',
    '<공지사항 내용>'
    to_char(sysdate, 'YYYY-MM-DD'),
    (select
        o.seq
    from tblTeacher t
        inner join tblOpenCourse o
            on t.seq = o.t_seq
                where to_date(o.endDate) > sysdate and t.name = '<교사명>')
);


--3. 공지사항 수정
update tblNotice set
    title = '<공지사항 제목>'
    content = '<공지사항 내용>',
    n_date = to_char(sysdate, 'YYYY-MM-DD')
where seq = <수정할 공지사항 번호>;


--4. 공지사항 삭제
delete from tblNotice where seq = <삭제할 공지사항 번호>;

1. 공지사항 조회
select
    n.seq as "공지사항 번호",
    n.title as "제목",
    n.content as "내용",
    n.n_date as "작성날짜",
    o.course_seq as "과정번호"
from tblNotice n
    inner join tblOpenCourse o
        on n.c_seq = o.seq
            inner join tblCourseInfo c
                on o.seq = c.c_seq
                    inner join tblStudent s
                        on c.s_seq = s.seq
                            where s.name = '<교육생 이름>';


--1. 교사 질문게시판: 담당 학생이 작성한 글, 답변 조회
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

--2.  답글 삭제
delete from TBLREPLY where Q_SEQ = 삭제할 답글 번호;

--3.  답글 수정
update TBLREPLY set REPLY = 'aaa' where Q_SEQ = 수정할 답글 번호;

--4. 답글 등록
insert into TBLREPLY (SEQ, REPLY, Q_SEQ, T_SEQ) VALUES (댓글번호, 답글내용, 질문번호, 교사번호)

--1. 본인이 작성한 글 조회
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

--2.  같은반 학생들이 작성한 질문 조회
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

--3. 질문 삭제
delete from TBLQUESTION where SEQ = 삭제할 질문 번호;

--4. 질문 수정
update TBLQUESTION set CONTENT = 'aaa' where SEQ = 수정할 질문번호;

--5. 질문등록
insert into TBLQUESTION (SEQ, TITLE, CONTENT, Q_DATE, S_SEQ) VALUES (질문번호, 제목, 내용, 날짜, 교육생번호)


--1. 질문게시판 전체 조회
select q.SEQ     as 번호,
       st.NAME   as 작성자,
       q.Q_DATE  as 작성일,
       q.TITLE   as 제목,
       q.CONTENT as 내용,
       r.REPLY   as 답변,
       tc.NAME   as 교사명d
from TBLREPLY r
         inner join TBLQUESTION q on q.SEQ = r.Q_SEQ
         inner join TBLSTUDENT st
                    on q.S_SEQ = st.SEQ
         inner join TBLTEACHER tc
                    on r.T_SEQ = tc.SEQ;

--2. 답변 삭제
delete from TBLREPLY where Q_SEQ = 삭제할 답변 번호;

--3. 질문 삭제
delete from TBLQUESTION where SEQ = 삭제할 답변 번호;

--1.  수강생들이 과정 중 이용하는 문서 외의 사용해본 문서를 추천하는 기능이다.
insert into tblRecommend values (3, <문서 이름>,<추천 내용>, <학생 번호>);

--2. 교육생 작성 전용이고, 조회는 제한을 두지 않는다.
select
    seq as "글번호",
        s_seq as "학생번호",
    recommenddoc as "문서 이름",
    content as "추천 내용"
from tblRecommend;

--1.  수강생들이 과정 중 이용하는 문서 외의 사용해본 문서를 추천하는 기능이다.
insert into tblRecommend values (3, <문서 이름>,<추천 내용>, <학생 번호>);

--2. 교육생 작성 전용이고, 조회는 제한을 두지 않는다.
select
    seq as "글번호",
        s_seq as "학생번호",
    recommenddoc as "문서 이름",
    content as "추천 내용"
from tblRecommend;

--1.  수강생들이 과정 중 이용하는 문서 외의 사용해본 문서를 추천하는 기능이다.
insert into tblRecommend values (3, <문서 이름>,<추천 내용>, <학생 번호>);

--2. 교육생 작성 전용이고, 조회는 제한을 두지 않는다.
select
    seq as "글번호",
        s_seq as "학생번호",
    recommenddoc as "문서 이름",
    content as "추천 내용"
from tblRecommend;

-- 관리자
-- 수료한 학생들이 작성한 수료생 게시판의 정보(게시판 번호, 면접후기, 취업후기, 수료생 번호, 수료생 이름, 취업한 기업이름, 개설 과정 이름)를 조회한다.
-- 관리자는 후기 수정이 가능하다.
-- 면접 후기 null: 미취업자 / 취업후기: null 허용(수료생들이 선택적으로 작성)
select
    r.seq as "게시판 번호",
    r.intReview as "면접 후기",
    r.empReview as "취업 후기",
    r.seq as "수료생 번호",
    s.name as "수료생 이름",
    p.name as "취업한 기업",
    e.courseName as "수료한 과정"
from tblCS_Review r
    inner join tblCompleteStudent c
        on c.seq = r.e_seq
            inner join tblOpenCourse o
                on o.seq = c.c_seq
                    inner join tblCourse e
                        on e.seq = o.course_seq
                            inner join tblStudent s
                                on s.seq = c.stu_seq
                                    inner join tblCompany p
                                        on p.seq = c.cp_seq;

-- 면접후기 수정
update tblCS_Review set intReview = ‘<데이터 입력>’ where seq = <데이터 입력>;   -- 괄호 안에 관리자가 원하는 데이터를 입력하여 해당 수료생 번호에 면접 후기를 수정할 수 있다.


-- 교사
-- 수료한 학생들이 수료생 게시판에 작성한 정보 중 일부 정보(게시판 번호, 면접후기, 취업후기, 개설 과정 이름)를 조회한다.
-- 교사는 모든 학생이 작성한 후기를 조회할 수 있다.
-- 교사는 수료생이 작성한 후기들을 수정, 삭제가 불가능하다.

select
    r.seq as "게시판 번호",
    r.intReview as "면접 후기",
    r.empReview as "취업 후기",
    p.name as "취업한 기업"

from tblCS_Review r
    inner join tblCompleteStudent c
        on c.seq = r.e_seq
            inner join tblOpenCourse o
                on o.seq = c.c_seq
                    inner join tblCourse e
                        on e.seq = o.course_seq
                            inner join tblStudent s
                                on s.seq = c.stu_seq
                                    inner join tblCompany p
                                        on p.seq = c.cp_seq;

-- 수료생
-- 수료생들이 학원을 수료 후 면접을 본 회사의 면접후기, 취업후기, 취업한 기업이름을 자유롭게 공유하여 작성, 조회할 수 있다.
-- 수료생은 게시판 작성이 가능하다. (면접 후기, 취업 후기,  취업한 기업 이름)
select
    r.seq as "게시판 번호",
    r.intReview as "면접 후기",
    r.empReview as "취업 후기",
    p.name as "취업한 기업"

from tblCS_Review r
    inner join tblCompleteStudent c
        on c.seq = r.e_seq
            inner join tblOpenCourse o
                on o.seq = c.c_seq
                    inner join tblCourse e
                        on e.seq = o.course_seq
                            inner join tblStudent s
                                on s.seq = c.stu_seq
                                    inner join tblCompany p
                                        on p.seq = c.cp_seq;

-- 교육생
-- 수료한 교육생들이 작성한 기업 면접 후기, 취업 후기, 취업 기업이름을 조회할 수 있다.
-- 모든 교육생이 작성한 후기를 조회할 수 있다.
select
    r.seq as "게시판 번호",
    r.intReview as "면접 후기",
    r.empReview as "취업 후기",
    p.name as "취업한 기업"

from tblCS_Review r
    inner join tblCompleteStudent c
        on c.seq = r.e_seq
            inner join tblOpenCourse o
                on o.seq = c.c_seq
                    inner join tblCourse e
                        on e.seq = o.course_seq
                            inner join tblStudent s
                                on s.seq = c.stu_seq
                                    inner join tblCompany p
                                        on p.seq = c.cp_seq;










