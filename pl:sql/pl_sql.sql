-- 1. 계정으로 로그인한 관리자의 정보 출력
create or replace procedure procAdmin(
    pt_seq in number,
	pt_ssn in number,
    pName out varchar2
)
is
begin
	select name into pName from tblAdmin where seq = pt_seq and ssn = pt_ssn;
exception
	when others then
dbms_output.put_line('아이디 혹은 비밀번호가 틀렸습니다.');
end procAdmin;

-- 개설 설계 INSERT  (과정이름, 인원 수)
-- <> 칸에 관리자가 삽입할 데이터 입력
create or replace procedure procAddCourse(
    pcourseName varchar2,
    pstudentNum number,
    presult out number
)
is
    vseq number;
begin
    select nvl(max(seq) ,0) + 1 into vseq from tblCourse;
    insert into tblCourse values (vseq, pcourseName, pstudentNum);

    presult := 1;    -- 과정 삽입 성공 시  presult: 1

exception
    when others then
        presult := 0;    -- 과정 삽입 실패 시 presult : 0
end procAddCourse;


declare
    vresult number;
begin
    procAddCourse('<관리자 입력 칸: 과정 명> ', <관리자 입력 칸 : 인원 수>, vresult);
    dbms_output.put_line('삽입 성공여부(1: 성공 / 0: 실패): '||vresult);
end;




-- 개설 과정 정보 INSERT (개설 과정 기간, 시작일, 종료일, 교사 번호, 강의실 번호, 과정 설계 번호)
-- <> 칸에 관리자가 삽입할 데이터 입력
create or replace procedure procAddOpenCourse(
    pcoursePeriod number,
    pstartDate varchar2,
    pendDate varchar2,
    pt_seq number,
    pr_seq number,
    pcourse_seq number,
    presult out number
)
is
    vseq number;
begin
    select nvl(max(seq) ,0) + 1 into vseq from tblOpenCourse;
    insert into tblOpenCourse values(vseq, pcoursePeriod, pstartDate, pendDate, pt_seq, pr_seq, pcourse_seq);

    presult := 1;

exception
    when others then
        presult := 0;

end procAddOpenCourse;


declare
    vresult number;
begin
    procAddOpenCourse(<과정 기간>, '<과정 시작일>', '<과정 종료일>', <담당 교사 번호>, <강의실 번호>, <과정 설계 번호>, vresult);
    dbms_output.put_line('삽입 성공여부(1: 성공 / 0: 실패): '||vresult);
end;














-- 해당 과정을 수료한 수료생 정보 출력 (과정명, 과정 기간, 과정 등록일, 과정 시작일, 과정 종료일, 교사 번호, 강의실 번호, 수강인원, 교육생 번호, 주민등록번호 뒷자리, 전화번호)
-- <> 칸에 관리자가 검색할 수료생 번호 입력
create or replace procedure procCompleteStudent(

    pcourseName  out varchar2,
    pcoursePeriod out number,
    pregisterDate out varchar2,
    pstartDate out varchar2,
    pendDate out varchar2,
    ptName out varchar2,
    proom out number,   -- r_seq
    pstudentNum out number,
    pname out varchar2,
    pseq in number, -- stu_seq
    pssn out varchar2,
    ptel out varchar2
)
is
begin
    select
        t.courseName,
        o.CoursePeriod,
        s.registerDate,
        o.startDate,
        o.endDate,
        r.name,
        o.r_seq,
        t.studentNum,
        s.name,
        s.ssn,
        s.tel
    into pcourseName, pcoursePeriod, pregisterDate, pstartDate, pendDate, ptName, proom, pstudentNum, pname, pssn, ptel
from tblOpenCourse o
    right outer join tblCompleteStudent c
        on o.seq = c.c_seq
            left outer join tblStudent s
                on s.seq = c.stu_seq
                    left outer join tblCourse t
                        on t.seq = o.course_seq
                            left outer join tblTeacher r
                                on r.seq = o.t_seq
                                    where  t.courseName is not null and c.stu_seq = pseq;
end procCompleteStudent;


declare
    vcourseName tblCourse.courseName%type;
    vcoursePeriod tblOpenCourse.coursePeriod %type;
    vregisterDate tblStudent.registerDate%type;
    vstartDate tblOpenCourse.startDate%type;
    vendDate tblOpenCourse.endDate%type;
    vtName tblTeacher.name%type;
    vroom tblOpenCourse.r_seq%type;
    vstudentNum tblCourse.studentNum%type;
    vname tblStudent.name%type;
    vssn tblStudent.ssn%type;
    vtel tblStudent.tel%type;
begin
    procCompleteStudent(vcourseName, vcoursePeriod, vregisterDate, vstartDate, vendDate, vtName, vroom, vstudentNum, vname, <출력할 수료생 번호>, vssn, vtel);

    dbms_output.put_line('과정명: '||vcourseName);
    dbms_output.put_line('과정 기간: ' ||vcoursePeriod);
    dbms_output.put_line('과정 등록일: ' || vregisterDate);
    dbms_output.put_line('과정 시작일: ' ||vstartDate);
    dbms_output.put_line('과정 종료일: ' || vendDate);
    dbms_output.put_line('교사: '||vtName);
    dbms_output.put_line('강의실: ' ||vroom);
    dbms_output.put_line('인원 수: '||vstudentNum);
    dbms_output.put_line('이름: '||vname);
    dbms_output.put_line('교육생 주민등록번호 뒷자리' ||vssn);
    dbms_output.put_line('전화번호: '||vtel);
end;


-- 개설 과정의 세부 정보 출력(설계 번호, 과정 이름, 수강 인원 수)
-- <> 칸에 관리자가 세부정보를 검색할 개설 과정 번호 입력
create or replace procedure procOpenCourseInfo(
    pseq in number,
    pcourseName out varchar2,
    pstudentNum out number
)
is
begin
    select
        distinct
        c.courseName,
        c.studentNum
    into pcourseName, pstudentNum
    from tblOpenCourse o
        inner join tblCourse c
            on c.seq = o.course_seq
                where c.seq = pseq;
end procOpenCourseInfo;


declare
    vcourseName tblCourse.courseName%type;
    vstudentNum tblCourse.studentNum%type;
begin
    procOpenCourseInfo(<개설 과정 번호>, vcourseName, vstudentNum);
    dbms_output.put_line('과정명: '|| vcourseName);
    dbms_output.put_line('인원 수: ' || vstudentNum || '명');
end;



-- 개설 과정의 강의실 정보 (과정명 ,강의실 번호, 정원 수)
-- <> 칸에 관리자가 강의실 번호를 입력하여 원하는 강의실에 대한 정보 출력
create or replace procedure procCourseRoom(
    pseq in number,
    pcourseName out varchar2,
    pr_seq out number,
    pr_maxNum out number
)
is
begin
    select
        distinct
        c.courseName,
        r.seq,
        r.maxNum
    into pcourseName, pr_seq, pr_maxNum
    from tblClassRoom r
        inner join tblOpenCourse o
            on r.seq = o.r_seq
                inner join tblCourse c
                    on c.seq = o.course_seq
                        where c.seq = pseq;

end procCourseRoom;



declare
    vcourseName tblCourse.courseName%type;
    vr_seq tblClassRoom.seq%type;
    vr_maxNum tblClassRoom.maxNum%type;
begin
    procCourseRoom(<강의실 번호>, vcourseName, vr_seq, vr_maxNum);
    dbms_output.put_line('과정명: ' || vcoursename);
    dbms_output.put_line('강의실: '||vr_seq || '강의실');
    dbms_output.put_line('정원 인원: ' || vr_maxNum || '명');
end;

-- 해당 개설 과정의 공지사항 출력(제목, 내용, 작성날짜)
-- <> 칸에 관리자가 공지사항을 검색할 공지사항 번호 입력
create or replace procedure procCourseNotice(
    pseq in number,
    ptitle out varchar2,
    pcontent out varchar2,
    pn_date out varchar2
)
is
begin
    select
        n.title,
        n.content,
        n.n_date
    into ptitle, pcontent, pn_date
    from tblOpenCourse o
        inner join tblNotice n
            on o.seq = n.c_seq
                where n.seq = pseq;
end procCourseNotice;


declare
    vtitle tblNotice.title%type;
    vcontent tblNotice.content%type;
    vn_date tblNotice.n_date%type;
begin
    procCourseNotice(<공지사항 번호>, vtitle, vcontent, vn_date);
    dbms_output.put_line('공지사항 제목: '||vtitle);
    dbms_output.put_line('공지사항 내용: '||vcontent);
    dbms_output.put_line('공지사항 작성 날짜: '|| vn_date);
end;






-- 해당 개설 과정의 공지사항 출력(번호,제목, 내용)
-- <> 칸에 관리자가 공지사항을 검색할 공지사항 날짜 입력
create or replace procedure procCourseNotice_2(
    pseq out number,
    ptitle out varchar2,
    pcontent out varchar2,
    pn_date in varchar2
)
is
begin
    select
        n.seq,
        n.title,
        n.content
    into pseq, ptitle ,pcontent
    from tblOpenCourse o
        inner join tblNotice n
            on o.seq = n.c_seq
                where n.n_date = pn_date;
end procCourseNotice_2;


declare
    vseq tblNotice.seq%type;
    vtitle tblNotice.title%type;
    vcontent tblNotice.content%type;
begin
    procCourseNotice_2(vseq, vtitle, vcontent, ‘<날짜 입력(yyyy-mm-dd)>’);
    dbms_output.put_line('공지사항 번호: '||vseq);
    dbms_output.put_line('공지사항 제목: '|| vtitle);
    dbms_output.put_line('공지사항 내용: '||vcontent);

end;





-- 과정을 가르치는 담당 교사에 대한 정보 (과정 이름,교사 번호, 교사 이름, 주민번호 뒷자리, 전화번호, 수강 가능 여부)
-- <> 칸에 관리자가 정보를 가져올 교사 이름을 입력
create or replace procedure procCourse_Teacher(
    pcourseName out varchar2,
    pseq out number,
    ptName in varchar2,
    pssn out varchar2,
    ptel out varchar2,
    pclassStatus out varchar2
)
is
begin
    select
        distinct
        c.courseName,
        t.seq,
        t.ssn,
        t.tel,
        t.classStatus
    into pcourseName, pseq, pssn, ptel, pclassStatus
    from tblOpenCourse o
        inner join tblTeacher t
            on t.seq = o.t_seq
                inner join tblCourse c
                    on c.seq = o.course_seq
                        where t.name = ptName;
end procCourse_Teacher;



declare
    vcourseName tblCourse.coursename%type;
    vseq tblTeacher.seq%type;
    vssn tblTeacher.ssn%type;
    vtel tblTeacher.tel%type;
    vclassStatus tblTeacher.classStatus%type;
begin
    procCourse_Teacher(vcourseName, vseq, '<교사 이름>', vssn, vtel, vclassStatus);
    dbms_output.put_line('진행중인 과정명: '||vcoursename);
    dbms_output.put_line('교사 번호: '||vseq);
    dbms_output.put_line('주민등록번호 뒷자리: '||vssn);
    dbms_output.put_line('전화번호: '||vtel);
    dbms_output.put_line('수강 가능 여부 (y/n)'||vclassStatus);
end;



-- 해당 과정 안의 과목들에 대한 정보 (개설 과목 정보 번호, 과목 시작일, 과목 종료일, 개설 과목 번호, 개설 과정 정보 번호)
-- <> 칸에 관리자가 과정 안의 과목 정보를 확인하기 위한 과목 시작날짜 입력
create or replace procedure procSubInfo(
    pcourseName out varchar2,
    psubjectName out varchar2,
    pstartDate in varchar2,
    pendDate out varchar2
)
is
begin
    select
        r.courseName,
        s.subjectName,
        o.endDate
    into pcourseName, psubjectName, pendDate
    from tblOpenCourse c
        inner join tblOpenCourseSubject o
            on c.seq = o.c_seq
                inner join tblSubject s
                    on s.seq = o.s_seq
                        inner join tblCourse r
                            on r.seq = c.course_seq
                                where o.startDate = pstartDate;
end procSubInfo;





declare
    vcourseName tblCourse.courseName%type;
    vsubjectName tblSubject.subjectName%type;
    vendDate tblOpenCourseSubject.endDate%type;
begin
    procSubInfo(vcourseName, vsubjectName, ‘<yyyy-mm-dd>’, vendDate);
    dbms_output.put_line('진행중인 과정명: '||vcourseName);
    dbms_output.put_line('진행중인 과목명: '||vsubjectName);
    dbms_output.put_line('과목 종료일: '||vendƒDate);
end;









-- 해당 과정의 교육생 수강 정보 (수강 정보 번호, 수료 날짜, 중도 탈락 날짜, 교육생 번호, 개설 과정 정보 번호)
-- <> 칸에 관리자가 정보를 가져오고자 할 교육생 번호를 입력
create or replace procedure procStu_Info(
    pseq in number,
    pname out varchar2,
    pcompleteDate out varchar2,
    poutDate out varchar2,
    pcourseName out varchar2
)
is
begin
    select
        s.name,
        c.completeDate,
        c.outDate,
        u.courseName
    into pname, pcompleteDate, poutDate, pcourseName
    from tblOpenCourse o
        inner join tblCourseInfo c
            on o.seq = c.c_seq
                inner join tblStudent s
                    on s.seq = c.s_seq
                        inner join tblCourse u
                            on u.seq = o.course_seq
                                where c.seq = pseq;
end procStu_Info;




declare
    vname tblStudent.name%type;
    vcompleteDate tblCourseInfo.completeDate%type;
    voutDate tblCourseInfo.outDate%type;
    vcourseName tblCourse.courseName%type;
begin
    procStu_Info(<교육생 번호>, vname, vcompleteDate, voutDate, vcourseName);
    dbms_output.put_line('교육생: '||vname);
    dbms_output.put_line('수료일: '||vcompleteDate);
    dbms_output.put_line('중도탈락 날짜(없을 경우 표시x): '||voutDate);
    dbms_output.put_line('과정 명: '||vcourseName);
end;





-- 교사 평가 데이터 (교사 번호, 교사 평가 점수, 교육생 번호, 평가한 교육생 수)
-- <> 칸에 관리자가 교사 평가 점수를 확인하고자할 교사 번호 입력
create or replace procedure procTeacher_Score(
    pseq in number,
    pscore out number,
    pcount out number
)
is
begin
    select
        round(avg(t.score),1),
        count(*)
    into pscore, pcount
    from tblOpenCourse o
        inner join tblTeacherScore t
            on o.seq = t.c_seq
                inner join tblTeacher r
                    on r.seq = t.teacherNum
                        where t.teacherNum = pseq
                            group by t.teacherNum
                                having avg(t.score) > 1;
end procTeacher_Score;


declare
    vscore tblTeacherScore.score%type;
    vcount tblTeacherScore.studentNum%type;
begin
    procTeacher_Score(6, vscore, vcount);
    dbms_output.put_line('교사 평가 점수: '||vscore);
end;




--1. 개설 과목 정보 조회
--1.1 현재 진행중인 과목 정보 조회

-- 프로시저명 : procSubInfo
-- procSubInfo()으로 호출

create or replace procedure procSubInfo
is
    vseq number;
    vsubjectName tblSubject.subjectName%type;
    vbookName tblBook.bookName%type;

    cursor vcursor
    is
    select
        distinct
        s.seq,
        s.subjectName,
        b.bookName
    from tblOpenCourseSubject o
        inner join tblSubject s
            on o.s_seq = s.seq
                inner join tblBook b
                    on s.seq = b.s_seq
                        order by s.seq;

begin
    open vcursor;

        dbms_output.put_line('———————————————————————————————————————————————————————————————————————————');
        dbms_output.put_line('과목번호' || '    ' || '과목명' || '                ' || '교재명');
        dbms_output.put_line('———————————————————————————————————————————————————————————————————————————');

        loop
            fetch vcursor into vseq, vsubjectName, vbookName;
            exit when vcursor%notfound;

            dbms_output.put_line(lpad(vseq, 2, ' ') || '        ' || rpad(vsubjectName, 20, ' ') || '  ' || vbookName);

        end loop;
    close vcursor;
end;


--1.2 특정 개설 과정의 개설 과목 정보 조회

-- 프로시저명 : procCourseSubInfo
-- procCourseSubInfo(<과목 정보 번호>)으로 호출

create or replace procedure procCourseSubInfo (

    pseq in tblOpenCourse.seq%type
)
is

    vcourseName tblCourse.courseName%type;
    vcourStartDate tblOpenCourse.startDate%type;
    vcourEndDate tblOpenCourse.endDate%type;
    vclassRoom number;
    vsubjectName tblSubject.subjectName%type;
    vsubStartDate tblOpenCourseSubject.startDate%type;
    vsubEndDate tblOpenCourseSubject.endDate%type;
    vbookName tblBook.bookName%type;
    vteacherName tblTeacher.name%type;

    cursor vcursor
    is
    select
        c.courseName,
        oc.startDate,
        oc.endDate,
        oc.r_seq,
        s.subjectName,
        ocs.startDate,
        ocs.endDate,
        b.bookName,
        t.name
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
                                                where oc.seq = pseq;
begin

    dbms_output.put_line('————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————');
    dbms_output.put_line('  과정명		                             	        	강의실     과목명           과목기간                    교재명                 교사명');
    dbms_output.put_line('————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————');

    open vcursor;

        loop
            fetch vcursor into vcourseName, vcourStartDate, vcourEndDate, vclassRoom, vsubjectName, vsubStartDate, vsubEndDate, vbookName, vteacherName;
            exit when vcursor%notfound;



            dbms_output.put_line(vcourseName || '    ' || vclassRoom || '강의실' || '     ' || rpad(vsubjectName, 16, ' ') || ' ' ||rpad(vsubStartDate || ' ~ ' || vsubEndDate, 23, ' ') || '    ' ||  rpad(vbookName, 20, ' ') || '    ' || vteacherName);

        end loop;
    close vcursor;

end;




--2. 개설 과목 입력

-- 프로시저명 : procAddtSub
-- procAddtSub(‘<시작일>’, ‘<종료일>’, <과목번호>, <과정번호>)으로 호출

create or replace procedure procAddtSub
(
    pstartDate varchar2,
    pendDate varchar2,
    ps_seq number,
    pc_seq number
)
is

    vs_seq number;

begin

    insert into tblOpenCourseSubject values(
        (select max(seq) + 1 from tblOpenCourseSubject),
        pstartDate,
        pendDate,
        ps_seq,
        pc_seq
    );


exception
    when others then
        dbms_output.put_line('과목 추가에 실패하였습니다.');

end procAddtSub;




--3. 개설 과목 수정

-- 프로시저명 : procEditSubject
-- procEditSubject(‘<과목명>’, <수정할과목번호>)로 호출

create or replace procedure procEditSubject (

    pname in varchar2,
    pseq in number
)
is
    vrownum number;
begin

    update tblSubject set subjectName = pname
        where seq = pseq;


exception
    when others then
        dbms_output.put_line('과목 수정에 실패하였습니다.');

end procEditSubject;




--4. 과정 내 과목 삭제

-- 프로시저명 : procDeleteCourSubject
-- procDeleteCourSubject(<개설 과목 정보 번호>)으로 호출

create or replace procedure procDeleteCourSubject (

    pseq in number
)
is
begin

    delete from tblOpenCourseSubject where seq = pseq;

end;

--1. 교육생 정보 CRUD

--1-1. 교육생 정보 등록
create or replace procedure procAddStudent(
    pname varchar2,
    pssn number,
    ptel varchar2,
    pregisterDate varchar2,
    presult out number -- 1 or 0
)
is
    vseq number;
begin
    select nvl(max(seq) ,0) + 1 into vseq from tblStudent;
    insert into tblStudent (seq, name, ssn, tel, registerdate)
    VALUES (vseq, pname, pssn, ptel, pregisterdate);

    presult := 1;

exception
    when others then
        presult :=0;

end procAddStudent;


declare
    vresult number;
begin
    procAddStudent(<학생명>, <주민번호뒷자리>, <전화번호>, <등록날짜>, vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
end;


--1-2. 교육생 정보 수정
create or replace  procedure procUpdateStudent(
    pseq number
)
is
begin
    update tblStudent set
        tel = '<전화번호>',
        registerdate = '<등록날짜>'
    where SEQ = pseq;
end procUpdateStudent;

declare
begin
    procUpdateStudent(<학생번호>);
end;


--1-3. 교육생 정보 삭제
create or replace procedure procDeleteStudent(
    pseq number
)
is
begin
    delete from TBLQUESTION where SEQ = pseq;
end procDeleteStudent;

declare
begin
    procDeleteStudent(<학생 번호>);
end;

--2. 특정 교육생 선택 시 교육생이 신청한 과정명, 과정기간, 강의실, 수료여부 및 날짜 출력
create or replace procedure procStudentInfo(
    pt_seq in number,
    prownum out number,
    pName out varchar2,
	pCourseName out varchar2,
	pCoursePeriod out number,
	pClassRoom out number,
    pEndDate out varchar2
)
is
begin
	select
		rownum,
        S.name,
		c.courseName,
		oc.CoursePeriod,
		oc.r_seq,
        oc.EndDate
		into prowNum, pName, pCourseName, pCoursePeriod, pClassRoom, pEndDate
			from tblStudent s
            inner join tblCourseInfo ci
                on S.seq = ci.s_Seq
                    right outer join tblOpenCourse oc
                    on ci.c_seq = oc.seq
                    right outer join tblTeacher t
                        on oc.t_seq = t.seq
                            inner join tblCourse c
                                on oc.course_seq = c.SEQ
                                    where s.seq = pt_seq;
end procStudentInfo;

declare
	vrownum number;
    vname tblStudent.name%type;
	vcourseName tblCourse.coursename%type;
	vcoursePeriod tblOpenCourse.courseperiod%type;
	vclassRoom tblOpenCourse.r_seq%type;
    vEndDate tblOpenCourse.enddate%type;
begin
	procStudentInfo(<학생 번호>, vrownum, vname, vcourseName, vcoursePeriod, vclassRoom, vendDate);
	dbms_output.put_line(vrownum);
    dbms_output.put_line(vname);
	dbms_output.put_line(vcourseName);
	dbms_output.put_line(vcoursePeriod);
	dbms_output.put_line(vclassRoom);
    dbms_output.put_line(vendDate);
end;


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

--1.출결 상태 CRUD
--1-1.출결 상태 작성
create or replace procedure procAddAttendance(
    pDate varchar2,
    pStudentStatus varchar2,
    pStudentNumber number,
    presult out number -- 1 or 0
)
is
    vseq number;
begin
    select nvl(max(seq) ,0) + 1 into vseq from tblAttendance;
    insert into tblAttendance (seq, a_date, studentStatus, s_seq)
    VALUES (vseq, pDate, pStudentStatus, pStudentNumber);

    presult := 1;

exception
    when others then
        presult :=0;

end procAddAttendance;


declare
    vresult number;
begin
    procAddAttendance(<날짜>,<출결 상태>,<학생 번호>, vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
end;

--1-2.출결 상태 수정
create or replace  procedure procUpdateAttendance(
    pseq number
)
is
begin
    update tblAttendance set
        a_date = '<날짜>',
        studentStatus = '<출결 상태>'
    where s_seq = pseq;
end procUpdateAttendance;

declare
begin
    procUpdateAttendance(<학생 번호>);
end;

--1-3.출결 상태 삭제
create or replace procedure procDeleteAttendance(
    pseq number,
    pdate varchar2
)
is
begin
    delete from TBLAttendance
    where (s_SEQ = pseq) and  (a_date = pdate);
end procDeleteAttendance;

declare
begin
    procDeleteAttendance(<학생번호>,'<날짜>');
end;

--2.특정 인원 출결 조회

create or replace procedure procAttendance(
    pt_seq in number,
    prownum out number,
    pName out varchar2,
	pDate out varchar2,
    pStatus out varchar2
)
is
begin
	select
		rownum,
        S.name,
		a.a_date,
        a.studentstatus
		into prowNum, pName,pDate,pStatus
			from tblStudent s
            inner join tblAttendance a
                on s.seq = a.s_seq
                    where s.seq = pt_seq;
end procAttendance;

drop procedure procAttendance;

declare
	vrownum number;
    vname tblStudent.name%type;
	vdate tblAttendance.a_date%type;
    vstatus tblAttendance.studentstatus%type;
begin
	procAttendance(<학생 번호>, vrownum, vname, vdate, vstatus);
	dbms_output.put_line(vrownum);
    dbms_output.put_line(vname);
    dbms_output.put_line(vdate);
    dbms_output.put_line(vstatus);

end;


-- 현재 진행하고 있는 모든 과정의 과정명, 시작일(YYYY-MM-DD), 종료일(YYYY-MM-DD), 강의실, 교육생 등록 인원을 출력
--뷰생성
create or replace view vwTeacherCourseInfo
as
select
	case
		when oc.endDate < sysdate then '[교육종료]'
		when oc.endDate > sysdate and oc.startDate < sysdate then '[교육중]'
		else '교육예정'
	end as courseState,
	t.name as name,
	c.courseName as courseName,
	oc.startDate as startDate,
	oc.endDate as endDate,
	oc.r_seq as classNum,
	(select count(*) from tblcourseInfo where c_seq = oc.seq) as studentNum
		from tblOpenCourse oc
			right outer join tblTeacher t
				on oc.t_seq = t.seq
					inner join tblCourse c
						on oc.course_seq = c.SEQ;

-- 프로시저 생성
create or replace procedure procTeacherCourseInfo(
	pt_seq in number,
	presult out sys_refcursor
)
is
begin
	open presult
	for
	select
		case
		when oc.endDate < sysdate then '[교육종료]'
		when oc.endDate > sysdate and oc.startDate < sysdate then '[교육중]'
		else '교육예정'
		end as courseState,
		t.name,
		c.courseName,
		oc.startDate,
		oc.endDate,
		oc.r_seq,
		(select count(*) from tblcourseInfo where c_seq = oc.seq)
			from tblOpenCourse oc
				right outer join tblTeacher t
					on oc.t_seq = t.seq
						inner join tblCourse c
							on oc.course_seq = c.SEQ
								where t.seq = pt_seq;
end procTeacherCourseInfo;

-- 출력
declare
	vresult sys_refcursor;
	vrow vwTeacherCourseInfo%rowtype;
begin
	procTeacherCourseInfo(1, vresult);
	dbms_output.put_line('');
	dbms_output.put_line('[해당 교사 과정 정보]');
	dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
	dbms_output.put_line('	교육상황		이름			과정이름												시작일		종료일		강의실	수강인원');
	dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
	loop
		fetch vresult into vrow;
		exit when vresult%notfound;

		dbms_output.put_line('	' || vrow.courseState || '		' || vrow.name || '		' || vrow.courseName || '		 ' || vrow.startDate || '	 ' ||
								vrow.endDate || '		  ' || vrow.classNum || '		  ' || vrow.studentNum);
	end loop;
end;

-- 현재 진행 중인 과정에 속한 과목명, 과목기간(시작일(YYYY-MM-DD), 종료일(YYYY-MM-DD)),교재명을 출력
-- 뷰생성
create or replace view vwTeacherSubjectInfo
as
select
	case
		when sNum.startDate < sysdate and sNum.endDate > sysdate then '[교육중]'
		when sNum.startDate > sysdate then '[교육예정]'
		else '[교육종료]'
	end as subjectState,
	sub.subjectName as subjectName,
	sNum.startDate as startDate,
	sNum.endDate as endDate,
	b.bookName as bookName
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


-- 프로시저 생성
create or replace procedure procTeacherSubjectInfo(
	pt_seq in number,
	presult out sys_refcursor
)
is
begin
	open presult
	for
	select
	case
		when sNum.startDate < sysdate and sNum.endDate > sysdate then '[교육중]'
		when sNum.startDate > sysdate then '[교육예정]'
		else '[교육종료]'
	end as subjectState,
	sub.subjectName as subjectName,
	sNum.startDate as startDate,
	sNum.endDate as endDate,
	b.bookName as bookName
	from (
	select * from tblOpenCourseSubject where c_seq = (
		select course_seq from tblOpenCourse oc
			inner join tblTeacher t
				on oc.t_seq = t.seq
					where t.seq = pt_seq and oc.endDate > sysdate))sNum
						inner join tblSubject sub
							on sub.seq = sNum.s_seq
								inner join tblBook b
									on b.s_seq = sNum.s_seq
										order by startDate;
end procTeacherSubjectInfo;

-- 출력
declare
	vresult sys_refcursor;
	vrow vwTeacherSubjectInfo%rowtype;
begin
	procTeacherSubjectInfo(1, vresult);
	dbms_output.put_line('');
	dbms_output.put_line('[해당 교사 과목 정보]');
	loop
		fetch vresult into vrow;
		exit when vresult%notfound;
		dbms_output.put_line('-------------------------------------------------------');
		dbms_output.put_line(vrow.subjectState || '	' || vrow.subjectName);
		dbms_output.put_line('	* 시작일 : ' || vrow.startDate);
		dbms_output.put_line('	* 종료일 : ' || vrow.endDate);
		dbms_output.put_line('	* 교재 이름 : ' || vrow.bookName);
	end loop;
		dbms_output.put_line('-------------------------------------------------------');
end;


-- [교사] 자신이 현재 진행 중인 과정의 과정명, 시작일(YYYY-MM-DD), 종료일(YYYY-MM-DD), 강의실, 교육생 등록 인원을 출력
-- 프로시저 생성
create or replace procedure procTeacherCourseProcess(
	pt_seq number,
	pteacherName out varchar2,
	pcourseName out varchar2,
	pstartDate out varchar2,
	pendDate out varchar2,
	pclassNum out number,
	pstudentNum out number
)
is
begin
	select
		t.name,
		c.courseName,
		oc.startDate,
		oc.endDate,
		oc.r_seq,
		(select count(*) from tblcourseInfo where c_seq = oc.seq)
		into
		pteacherName, pcourseName, pstartDate, pendDate, pclassNum, pstudentNum
			from tblOpenCourse oc
				right outer join tblTeacher t
					on oc.t_seq = t.seq
						inner join tblCourse c
							on oc.course_seq = c.SEQ
								where t.seq = pt_seq and oc.endDate >= sysdate;
end procTeacherCourseProcess;

-- 출력
declare
	vteacherName tblTeacher.name%type;
	vcourseName tblCourse.courseName%type;
	vstartDate tblOpenCourse.startDate%type;
	vendDate tblOpenCourse.endDate%type;
	vclassNum number;
	vstudentNum number;
begin
	procTeacherCourseProcess(3, vteacherName, vcourseName, vstartDate, vendDate, vclassNum, vstudentNum);
	dbms_output.put_line('');
	dbms_output.put_line('-------------------------------------------------------------------------');
	dbms_output.put_line('[' || vteacherName || ' | 현재 진행 중인 과정 정보]');
	dbms_output.put_line('	* 과정이름 : ' || vcourseName);
	dbms_output.put_line('	* 시작일 : ' || vstartDate);
	dbms_output.put_line('	* 종료일 : ' || vendDate);
	dbms_output.put_line('	* 강의실 : ' || vclassNum);
	dbms_output.put_line('	* 수강인원 : ' || vstudentNum);
	dbms_output.put_line('--------------------------------------------------------------------------');
end;






-- [교사] 교육중인 과정에 등록된 교육생 정보출력
-- 프로시저 생성
create or replace procedure procTeacherStudentInfo(
	pt_seq number
)
is
	name tblStudent.name%type;
	tel tblStudent.tel%type;
	registerDate tblStudent.registerDate%type;
	completeDate varchar2(20);
	outDate varchar2(20);
	courseName tblCourse.courseName%type;
	cursor vcursor is
		select
			s.name as name,
			s.tel as tel,
			s.registerDate as registerDate,
			case
				when completeDate is null then '수료X'
				else '수료완료'
			end as completeDate,
			case
				when outDate is not null then '탈락'
				else '교육중'
			end as outDate,
			(select courseName from tblCourse c where info.c_seq = c.seq) as courseName
				from (
				(select * from tblCourseInfo where c_seq = (
					select seq from tblOpenCourse
						where t_seq = pt_seq and endDate > sysdate)) info)
							inner join tblStudent s
								on s.seq = s_seq;
begin
	open vcursor;
			dbms_output.put_line('');
			dbms_output.put_line('[해당 교사가 진행하는 과정의 학생 정보]');
	 loop
	 	fetch vcursor into name, tel, registerDate, completeDate, outDate, courseName;
	 	exit when vcursor%notfound;
	 		dbms_output.put_line('----------------------------------------------------------------------');
			dbms_output.put_line('	[' || name || ']');
			dbms_output.put_line('	* 과정 이름 : ' || courseName);
			dbms_output.put_line('	* 전화번호 : ' || tel);
			dbms_output.put_line('	* 등록날짜 : ' || registerDate);
			dbms_output.put_line('	* 수료날짜 : ' || completeDate);
			dbms_output.put_line('	* 중도탈락날짜 : ' || outDate);
	 end loop;
	 		dbms_output.put_line('----------------------------------------------------------------------');
end procTeacherStudentInfo;

-- 출력
begin
	procTeacherStudentInfo(1);
end;

-- 교육과정에 대한 모든 교사 평가 정보 출력
-- 프로시저 생성
create or replace procedure procTeacherScore
is
	name tblTeacher.name%type;
	courseName tblCourse.courseName%type;
	startDate tblOpenCourse.startDate%type;
	endDate tblOpenCourse.endDate%type;
	t_avg number;
	cursor vcursor is
	select
		t.name as name,
		c.courseName as courseName,
		oc.startDate as startDate,
		oc.endDate as endDate,
		round(avg(score),1) as score
		from tblOpenCourse oc
			inner join tblTeacher t
				on t.seq = t_seq
					inner join tblCourse c
						on c.seq = oc.course_seq
							inner join tblTeacherScore ts
									on oc.seq = ts.c_seq
										group by t.name, c.COURSENAME, oc.STARTDATE, oc.ENDDATE
											order by score desc;
begin
	open vcursor;
		loop
			fetch vcursor into name, courseName, startDate, endDate, t_avg;
			exit when vcursor%notfound;
			dbms_output.put_line('--------------------------------------------------------------');
			dbms_output.put_line(courseName);
			dbms_output.put_line('	* 교사 이름 : ' || name);
			dbms_output.put_line('	* 점수 : ' || t_avg || '점');
			dbms_output.put_line('	* 시작일 : ' || startDate);
			dbms_output.put_line('	* 종료일 : ' || endDate);
		end loop;
			dbms_output.put_line('--------------------------------------------------------------');
end procTeacherScore;


--출력
begin
	procTeacherScore;
end;

-- [교사] 자신에 대한 평가 정보 출력
-- 프로시저 생성
create or replace procedure procTeacherMyScore(
	pt_seq number,
	pteacherName out varchar2,
	pcourseName out varchar2,
	pstartDate out varchar2,
	pendDate out varchar2,
	pavg out number
)
is
begin
	select
	t.name,
	c.courseName,
	oc.startDate,
	oc.endDate,
	round(avg(score),1)
	into
	pteacherName, pcourseName, pstartDate, pendDate, pavg
	from tblOpenCourse oc
		inner join tblTeacher t
			on t.seq = t_seq
				inner join tblCourse c
					on c.seq = oc.course_seq
						inner join tblTeacherScore ts
								on oc.seq = ts.c_seq
									where t.seq = pt_seq
										group by t.name, c.COURSENAME, oc.STARTDATE, oc.ENDDATE;
end procTeacherMyScore;

-- 출력
declare
	vteacherName tblTeacher.name%type;
	vcourseName tblCourse.courseName%type;
	vstartDate tblOpenCourse.startDate%type;
	vendDate tblOpenCourse.endDate%type;
	vavg number;
begin
		procTeacherMyScore(3, vteacherName, vcourseName, vstartDate, vendDate, vavg);
		dbms_output.put_line('--------------------------------------------------------------');
		dbms_output.put_line(vcourseName);
		dbms_output.put_line('	* 교사 이름 : ' || vteacherName);
		dbms_output.put_line('	* 점수 : ' || vavg || '점');
		dbms_output.put_line('	* 시작일 : ' || vstartDate);
		dbms_output.put_line('	* 종료일 : ' || vendDate);
		dbms_output.put_line('--------------------------------------------------------------');
end;

-- [교육생] 교육과정이 끝났을 때 행해지는 교사 평가
-- 프로시저 생성
create or replace procedure procTeacherScoreAdd(
	ps_seq number,
	pscore number
)
is
begin
	insert into tblTeacherScore (seq, score, studentNum, teacherNum, c_seq)
	values((select nvl(max(seq),0) + 1 from tblTeacherScore),
			pscore,
			ps_seq,
			(select t_seq from tblOpenCourse where seq = (select c_seq from tblCourseInfo where s_seq = ps_seq)),
			(select c_seq from tblCourseInfo where s_seq = ps_seq));
end procTeacherScoreAdd;

-- 출력
begin
	procTeacherScoreAdd(3, 4);
	dbms_output.put_line('교사평가를 완료하였습니다.');
exception
	when others then
	dbms_output.put_line('교사평가를 실패하였습니다.');
end;


--1. 공지사항 조회
-- 프로시저명 : procTeacherNoticeInfo
-- procTeacherNoticeInfo(‘<교사명>’)으로 호출

create or replace procedure procTeacherNoticeInfo (

    pname in tblTeacher.name%type
)
is

    vseq number;
    vtitle tblNotice.title%type;
    vcontent tblNotice.content%type;
    vn_date tblNotice.n_date%type;
    vcourse_seq number;
    vname tblTeacher.name%type;

    cursor vcursor
    is
    select
        n.seq,
        n.title,
        n.content,
        n.n_date,
        o.course_seq,
        t.name
    from tblNotice n
        inner join tblOpenCourse o
            on n.c_seq = o.seq
                inner join tblTeacher t
                    on o.t_seq = t.seq
                        where t.name like pname
                            order by n.seq;

begin

    dbms_output.put_line('————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————');
    dbms_output.put_line('  공지사항번호  	 제목                                   내용                                        작성일       과정번호    교사명');
    dbms_output.put_line('————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————');

    open vcursor;
        loop
            fetch vcursor into vseq, vtitle, vcontent, vn_date, vcourse_seq, vname;
            exit when vcursor%notfound;


            dbms_output.put_line('   ' || vseq || '           ' || rpad(vtitle, 40, ' ') || rpad(substr(vcontent, 1, 20)|| '...', 40, ' ') || '     ' || vn_date || '       ' || vcourse_seq || '      ' || vname);

        end loop;
    close vcursor;

end procTeacherNoticeInfo;


--2. 공지사항 등록
-- 프로시저명 : procTeacherAddNotice
-- procTeacherAddNotice(‘<제목>’, ‘<내용>’, ‘<교사명>’)으로 호출
create or replace procedure procTeacherAddNotice (

    ptitle varchar2,
    pcontent varchar2,
    pname varchar2
)
is

    vs_seq number;

begin

    insert into tblNotice values (
        (select max(seq) + 1 from tblNotice),
        ptitle,
        pcontent,
        to_char(sysdate, 'YYYY-MM-DD'),
        (select
            o.seq
        from tblTeacher t
            inner join tblOpenCourse o
                on t.seq = o.t_seq
                    where to_date(o.endDate) > sysdate and t.name = pname));


exception
    when others then
        dbms_output.put_line('공지사항 등록에 실패하였습니다.');

end;

--3. 공지사항 수정
-- 프로시저명 :
-- procTeacherEditNotice(<수정할 공지사항 번호>, ‘<제목>’, ‘<내용>’)으로 호출

create or replace procedure procTeacherEditNotice (

    pseq number,
    ptitle varchar2,
    pcontent varchar2
)
is
begin
    update tblNotice set title = ptitle, content = pcontent
        where seq = pseq;


exception
    when others then
        dbms_output.put_line('공지사항 수정에 실패하였습니다.');

end;

--1. 공지사항 조회
-- 프로시저명 : procStudentNoticeInfo
-- procStudentNoticeInfo(‘<교육생명>’)으로 호출

create or replace procedure procStudentNoticeInfo (

    pname in tblStudent.name%type
)
is

    vseq number;
    vtitle tblNotice.title%type;
    vcontent tblNotice.content%type;
    vn_date tblNotice.n_date%type;

    cursor vcursor
    is
    select
        n.seq,
        n.title,
        n.content,
        n.n_date
    from tblNotice n
        inner join tblOpenCourse o
            on n.c_seq = o.seq
                inner join tblCourseInfo c
                    on o.seq = c.c_seq
                        inner join tblStudent s
                            on c.s_seq = s.seq
                                where s.name like pname
                                    order by n.seq;

begin

    dbms_output.put_line('————————————————————————————————————————————————————————————————————————————————————————————————————————————');
    dbms_output.put_line('  공지사항번호  	 제목                                   내용                                        작성일');
    dbms_output.put_line('————————————————————————————————————————————————————————————————————————————————————————————————————————————');

    open vcursor;
        loop
            fetch vcursor into vseq, vtitle, vcontent, vn_date;
            exit when vcursor%notfound;


            dbms_output.put_line('   ' || vseq || '           ' || rpad(vtitle, 40, ' ') || rpad(substr(vcontent, 1, 20)|| '...', 40, ' ') || '     ' ||vn_date);

        end loop;
    close vcursor;

end procStudentNoticeInfo;


--1. 공지사항 조회
-- 프로시저명 : procAdminNoticeInfo
-- procAdminNoticeInfo(‘<관리자 주민번호 뒷자리>’)로 호출

create or replace procedure procAdminNoticeInfo (

    pssn in tblAdmin.ssn%type
)
is

    vnoticeSeq number;
    vtitle tblNotice.title%type;
    vcontent tblNotice.content%type;
    vn_date tblNotice.n_date%type;
    vcourseSeq number;
    vname tblTeacher.name%type;

    cursor vcursor1
    is
    select
        n.seq,
        n.title,
        n.content,
        n.n_date,
        o.seq,
        t.name
    from tblNotice n
        inner join tblOpenCourse o
            on n.c_seq = o.seq
                inner join tblTeacher t
                    on o.t_seq = t.seq
                        order by n.seq;

    vssn tblAdmin.ssn%type;

    cursor vcursor2
    is
    select ssn from tblAdmin;

begin

    dbms_output.put_line('————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————');
    dbms_output.put_line('  공지사항번호  	 제목                                   내용                                        작성일       과정명    교사명');
    dbms_output.put_line('————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————');

    open vcursor2;
        loop
            fetch vcursor2 into vssn;
            exit when vcursor2%notfound;

            if vssn = pssn then

                open vcursor1;
                    loop
                        fetch vcursor1 into vnoticeSeq, vtitle, vcontent, vn_date, vcourseSeq, vname;
                        exit when vcursor1%notfound;

                            dbms_output.put_line('   ' || vnoticeSeq || '           ' || rpad(vtitle, 40, ' ') || ' ' || rpad(substr(vcontent, 1, 20)|| '...', 40, ' ') || '     ' || vn_date || '       ' || vcourseSeq || '      ' || vname);

                    end loop;
                close vcursor1;
            end if;
        end loop;
    close vcursor2;

end;


--2. 공지사항 삭제
-- 프로시저명 : procAdminNoticeDelete
-- procAdminNoticeDelete(<삭제할 공지사항 번호>, ‘<관리자 주민번호 뒷자리>’)
create or replace procedure procAdminNoticeDelete (
    pseq in number,
    pssn in number
)
is
    vssn tblAdmin.ssn%type;

    cursor vcursor
    is
    select ssn from tblAdmin;

begin

     open vcursor;
        loop
            fetch vcursor into vssn;
            exit when vcursor%notfound;

            if vssn = pssn then
                delete from tblNotice where seq = pseq;
            else

                dbms_output.put_line('비밀번호를 다시 입력하세요.');

            end if;
        end loop;
    close vcursor;
end;


--1.추천 문서 조회

create or replace procedure procRecommend(
    pt_seq in number,
    prownum out number,
    pDoc out varchar2,
	pContent out varchar2,
    pStudentNumber out number
)
is
begin
	select
		rownum,
        r.recommenddoc,
        r.content,
        r.s_seq
		into prowNum, pDoc,pContent,pStudentNumber
			from tblRecommend r
                    where r.seq = pt_seq;
end procRecommend;

drop procedure procRecommend;

declare
	vrownum number;
    vDOc tblRecommend.recommenddoc%type;
	vContent tblRecommend.content%type;
    vStudentNumber tblRecommend.s_seq%type;
begin
	procRecommend(<추천문서 번호>, vrownum, vDoc,vContent,vStudentNumber);
	dbms_output.put_line(vrownum);
    dbms_output.put_line(vDoc);
    dbms_output.put_line(vContent);
    dbms_output.put_line(vStudentNumber);

end;


--1.교육생 추천 문서 CRUD
--1-1.교육생 추천 문서 작성

create or replace procedure procAddRecommend(
    pDoc varchar2,
    pContent varchar2,
    pStudentNumber number,
    presult out number -- 1 or 0
)
is
    vseq number;
begin
    select nvl(max(seq) ,0) + 1 into vseq from tblRecommend;
    insert into tblRecommend (seq, recommendDoc, content, s_seq)
    VALUES (vseq, pDoc, pContent, pStudentNumber);

    presult := 1;

exception
    when others then
        presult :=0;

end procAddRecommend;


declare
    vresult number;
begin
    procAddRecommend(<문서 이름>,<추천 내용>,<학생번호>, vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
end;
--1-2.교육생 추천 문서 수정
create or replace  procedure procUpdateRecommend(
    pseq number
)
is
begin
    update tblRecommend set
        recommendDoc = '<추천 문서>',
        content = '<추천 내용>'
    where seq = pseq;
end procUpdateRecommend;

declare
begin
    procUpdateRecommend(<글 번호>);
end;

--1-3.교육생 추천 문서 삭제
create or replace procedure procDeleteRecommend(
    pseq number
)
is
begin
    delete from TBLRecommend
    where SEQ = pseq;
end procDeleteRecommend;

declare
begin
    procDeleteRecommend(<글 번호>);
end;


-- 수료생 게시판 조회
-- 1. 관리자 > 게시판 번호 / 면접 후기 / 취업 후기 / 수료생 번호 / 수료생 이름 / 취업한기업 이름 / 개설 과정 이름
-- <> 칸에 관리자가 수료생이 작성한 게시판을 확인하기 위해 수료생 번호입력
create or replace procedure procCS_Review(
     pseq in number,
     pintReview out varchar2,
     pempReview out varchar2,
     pname out varchar2,
     pcpName out varchar2,
     pcourseName out varchar2
)
is
begin
    select
        r.intReview,
        r.empReview,
        s.name,
        p.name,
        e.courseName
    into pintReview, pempReview, pname, pcpName, pcourseName
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
                                            on p.seq = c.cp_seq
                                                where r.seq = pseq;

end procCS_Review;




declare
    vintReview tblCS_Review.intReview%type;
    vempReview tblCS_Review.empReview%type;
    vname tblStudent.name%type;
    vcpName tblCompany.name%type;
    vcourseName tblCourse.courseName%type;
begin
    procCS_Review(<수료생 번호>, vintReview, vempReview, vname, vcpName, vcourseName);
    dbms_output.put_line('면접 후기: '||vintReview);
    dbms_output.put_line('취업 후기: '||vempReview);
    dbms_output.put_line('수료생 이름: '||vname);
    dbms_output.put_line('취업한 기업 이름: '||vcpName);
    dbms_output.put_line('수료한 과정이름: '||vcourseName);
end;

-- 2. 교사 > 게시판 번호 / 면접 후기 / 취업 후기 / 취업한 기업 이름 / 개설 과정 이름
-- <> 칸에 교사가 수료생이 작성한 게시판을 확인하기 위해 수료생 번호입력
create or replace procedure procCS_Review_T(
    pseq in number,
    pintReview out varchar2,
    pempReview out varchar2,
    pname out varchar2,
    pcourseName out varchar2
)
is
begin
    select
        r.intReview,
        r.empReview,
        p.name,
        e.courseName
    into pintReview, pempReview, pname, pcourseName
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
                                            on p.seq = c.cp_seq
                                                where r.seq = pseq;
end procCS_Review_T;



declare
    vintReview tblCS_Review.intReview%type;
    vempReview tblCS_Review.empReview%type;
    vname tblCompany.name%type;
    vcourseName tblCourse.courseName%type;
begin
    procCS_Review_T(1, vintReview, vempReview, vname, vcourseName);
    dbms_output.put_line('면접 후기: '||vintReview);
    dbms_output.put_line('취업 후기: '||vempReview);
    dbms_output.put_line('취업한 기업 이름: '||vname);
    dbms_output.put_line('수료한 과정이름: '||vcourseName);
end;

-- 3. 수료생 >  게시판 번호 / 면접후기 / 취업후기 / 취업한 기업 이름
-- <> 칸에 작성한 게시판을 확인하기 위해 수료생 번호입력
create or replace procedure procCS_Review_C(
    pseq in number,
    pintReview out varchar2,
    pempReview out varchar2,
    pname out varchar2
)
is
begin
    select
        r.intReview,
        r.empReview,
        p.name
    into pintReview, pempReview, pname
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
                                            on p.seq = c.cp_seq
                                                where r.seq = pseq;
end procCS_Review_C;



declare
    vintReview tblCS_Review.intReview%type;
    vempReview tblCS_Review.empReview%type;
    vname tblCompany.name%type;
begin
    procCS_Review_C(<번호>, vintReview, vempReview, vname);
    dbms_output.put_line('면접 후기: '||vintReview);
    dbms_output.put_line('취업 후기: '||vempReview);
    dbms_output.put_line('취업한 기업 이름: '||vname);
end;




-- 수료생 > 수료생 게시판 입력 insert
-- <> 칸에 수료생이 작성할 면접후기, 취업 후기를 작성할 수 있다.
create or replace procedure procCS_Review_Ins(
    pintReview varchar2,
    pempReview varchar2,
    pe_seq number,
    presult out number
)
is
    vseq number;
begin
    select nvl(max(seq) ,0) + 1 into vseq from tblCS_Review;
    insert into tblCS_Review values (vseq, pintReview, pempReview, pe_seq);

    presult := 1;

exception
    when others then
        presult := 0;
end procCS_Review_Ins;


declare
    vresult number;
begin
    procCS_Review_Ins('<면접후기> ', '<취업후기>', 1, vresult);
    dbms_output.put_line('삽입 성공 여부(1: 성공 / 0: 실패): ' || vresult );
end;


-- 4. 교육생 >  게시판 번호 / 면접후기 / 취업후기 / 취업한 기업 이름
-- <> 칸에 작성한 게시판을 확인하기 위해 수료생 번호입력
create or replace procedure procCS_Review_C(
    pseq in number,
    pintReview out varchar2,
    pempReview out varchar2,
    pname out varchar2
)
is
begin
    select
        r.intReview,
        r.empReview,
        p.name
    into pintReview, pempReview, pname
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
                                            on p.seq = c.cp_seq
                                                where r.seq = pseq;
end procCS_Review_C;



declare
    vintReview tblCS_Review.intReview%type;
    vempReview tblCS_Review.empReview%type;
    vname tblCompany.name%type;
begin
    procCS_Review_C(<번호>, vintReview, vempReview, vname);
    dbms_output.put_line('면접 후기: '||vintReview);
    dbms_output.put_line('취업 후기: '||vempReview);
    dbms_output.put_line('취업한 기업 이름: '||vname);
end;

-- 교육생 로그인 화면
declare
    vseq number;
    vname varchar2(100);
    vcoursename varchar2(300);
    vstartdate varchar2(100);
    venddate varchar2(100);
    vteachername varchar2(100);
    vrseq number;
begin
    select st.SEQ, st.NAME, c.COURSENAME, oc.STARTDATE, oc.ENDDATE, tc.NAME, oc.R_SEQ
    into vseq, vname, vcoursename, vstartdate, venddate, vteachername, vrseq
    from
    TBLOPENCOURSE oc
         inner join TBLCOURSEINFO ci
                    on oc.SEQ = ci.C_SEQ
         inner join TBLSTUDENT st
                    on ci.S_SEQ = st.SEQ
         inner join TBLCOURSE c
                    on c.SEQ = oc.COURSE_SEQ
         inner join TBLTEACHER tc
                    on tc.SEQ = oc.T_SEQ
where st.SEQ = 1;
    DBMS_OUTPUT.PUT_LINE('학생번호: ' || vseq);
    DBMS_OUTPUT.PUT_LINE('이름: ' || vname);
    DBMS_OUTPUT.PUT_LINE('과정명: ' || vcoursename);
    DBMS_OUTPUT.PUT_LINE('과정기간: ' || vstartdate || ' ~ ' || venddate);
    DBMS_OUTPUT.PUT_LINE('교사명: ' || vteachername);
    DBMS_OUTPUT.PUT_LINE('강의실명: ' || vrseq);
end;

-- 학생: 본인이 작성한 질문 검색
declare
    vseq number;
    vname varchar2(100);
    vdate varchar2(300);
    vtitle varchar2(1000);
    vquestion varchar2(4000);
    vreply varchar2(4000);
    vtcname varchar2(100);
begin
    select q.SEQ, st.NAME, q.Q_DATE, q.TITLE, q.CONTENT, r.REPLY, tc.NAME
    into vseq, vname, vdate, vtitle, vquestion, vreply, vtcname
    from TBLREPLY r
         inner join TBLQUESTION q on q.SEQ = r.Q_SEQ
         inner join TBLSTUDENT st
                    on q.S_SEQ = st.SEQ
         inner join TBLTEACHER tc
                    on r.T_SEQ = tc.SEQ
where st.SEQ = 1;
    DBMS_OUTPUT.PUT_LINE('번호: ' || vseq);
    DBMS_OUTPUT.PUT_LINE('작성자: ' || vname);
    DBMS_OUTPUT.PUT_LINE('작성일: ' || vdate);
    DBMS_OUTPUT.PUT_LINE('제목: ' ||vtitle);
    DBMS_OUTPUT.PUT_LINE('내용: ' || vquestion);
    DBMS_OUTPUT.PUT_LINE('답변: ' || vreply);
    DBMS_OUTPUT.PUT_LINE('교사명: ' || vtcname);
end;

--교사: 출석점수
declare
    vname varchar2(100);
    vattendance number;
begin
    select st.NAME,
       20 +
       count(case
                 when TBLATTENDANCE.STUDENTSTATUS = '지각' then 1
                 when TBLATTENDANCE.STUDENTSTATUS = '외출' then 1
                 when TBLATTENDANCE.STUDENTSTATUS = '조퇴' then 1
                 when TBLATTENDANCE.STUDENTSTATUS = '결석' then 3
           end) * -1
        into vname, vattendance
        from TBLSTUDENT st
         inner join TBLATTENDANCE
                    on st.SEQ = TBLATTENDANCE.S_SEQ
where st.SEQ = 216
    group by st.NAME;
    DBMS_OUTPUT.PUT_LINE('이름: ' || vname);
    DBMS_OUTPUT.PUT_LINE('출석점수: ' || vattendance);
end;

-- 관리자: 교육생 개인별 성적 출력
declare
    cursor vcursor is
    Select s.seq,
       S.name,
       s.REGISTERDATE,
       SUb.subjectname,
       EI.score
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
    vseq TBLSTUDENT.SEQ%type;
    vname TBLSTUDENT.NAME%type;
    vregisterdate TBLSTUDENT.REGISTERDATE%type;
    vsubjectname TBLSUBJECT.SUBJECTNAME%type;
    vscore TBLEXAMINFO.SCORE%type;
begin
    DBMS_OUTPUT.PUT_LINE('번호   이름       등록일      점수        과목명');
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
    open vcursor;
    loop
        fetch vcursor into vseq, vname, vregisterdate, vsubjectname, vscore;

        DBMS_OUTPUT.PUT_LINE(vseq || '    '|| vname || '    ' || vregisterdate || '    ' || vscore || '     ' || vsubjectname);

        exit when vcursor%notfound;
    end loop;
end;

-- 관리자: 모든 학생 성적 출력
declare
    cursor vcursor is
    Select
       s.seq,
       S.name,
       s.REGISTERDATE,
       SUb.subjectname,
       EI.score
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
    vseq TBLSTUDENT.SEQ%type;
    vname TBLSTUDENT.NAME%type;
    vregisterdate TBLSTUDENT.REGISTERDATE%type;
    vsubjectname TBLSUBJECT.SUBJECTNAME%type;
    vscore TBLEXAMINFO.SCORE%type;
begin


    DBMS_OUTPUT.PUT_LINE('번호   이름       등록일      점수        과목명');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    open vcursor;
    loop

        fetch vcursor into vseq, vname, vregisterdate, vsubjectname, vscore;
        DBMS_OUTPUT.PUT_LINE(vseq || '    '|| vname || '    ' || vregisterdate || '    ' || vscore || '     ' || vsubjectname);
        exit when vcursor%notfound;

    end loop;

end;

--관리자: 전체 학생중 점수가 등록되지 않은 학생의 정보와 과목명 출력
declare
    cursor vcursor is
    Select
       s.seq,
       S.name,
       s.REGISTERDATE,
       SUb.subjectname,
       EI.score
from tblExamInfo EI
         inner join tblStudent S
                          on EI.s_seq = S.seq
         inner join tblExam EX
                          on EI.ex_seq = EX.seq
         inner join tblopencoursesubject OpenCS
                          on EX.c_seq = OpenCS.seq
         inner join tblSubject Sub
                          on OpenCS.s_seq = Sub.seq
where ei.SCORE is null;
    vseq TBLSTUDENT.SEQ%type;
    vname TBLSTUDENT.NAME%type;
    vregisterdate TBLSTUDENT.REGISTERDATE%type;
    vsubjectname TBLSUBJECT.SUBJECTNAME%type;
    vscore TBLEXAMINFO.SCORE%type;
begin

    DBMS_OUTPUT.PUT_LINE('번호   이름       등록일      점수        과목명');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    open vcursor;
    loop

        fetch vcursor into vseq, vname, vregisterdate, vsubjectname, vscore;
        DBMS_OUTPUT.PUT_LINE(vseq || '    '|| vname || '    ' || vregisterdate || '    ' || vscore || '     ' || vsubjectname);
        exit when vcursor%notfound;

    end loop;

end;

--교사: 담당하는 반 학생들의 성적을 과목별로 출력
declare
    cursor vcursor is
    Select
       s.seq,
       S.name,
       s.REGISTERDATE,
       SUb.subjectname,
       EI.score
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

    vseq TBLSTUDENT.SEQ%type;
    vname TBLSTUDENT.NAME%type;
    vregisterdate TBLSTUDENT.REGISTERDATE%type;
    vsubjectname TBLSUBJECT.SUBJECTNAME%type;
    vscore TBLEXAMINFO.SCORE%type;
begin

    DBMS_OUTPUT.PUT_LINE('번호   이름       등록일      점수        과목명');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    open vcursor;
    loop

        fetch vcursor into vseq, vname, vregisterdate, vsubjectname, vscore;
        exit when vcursor%notfound;
        DBMS_OUTPUT.PUT_LINE(vseq || '    '|| vname || '    ' || vregisterdate || '    ' || vscore || '     ' || vsubjectname);

    end loop;

end;

-- 시험 응시여부 출력: 응시함 O, 응시안함 X
declare
    cursor vcursor is
    Select
       s.seq,
       S.name,
       s.REGISTERDATE,
       SUb.subjectname,
       EI.score
from tblExamInfo EI
         right outer join tblStudent S
                          on EI.s_seq = S.seq
         right outer join tblExam EX
                          on EI.ex_seq = EX.seq
         right outer join tblopencoursesubject OpenCS
                          on EX.c_seq = OpenCS.seq
         right outer join tblSubject Sub
                          on OpenCS.s_seq = Sub.seq
where s.SEQ = 26 and SUBJECTNAME = '리눅스'
order by s.SEQ asc;

    vseq TBLSTUDENT.SEQ%type;
    vname TBLSTUDENT.NAME%type;
    vregisterdate TBLSTUDENT.REGISTERDATE%type;
    vsubjectname TBLSUBJECT.SUBJECTNAME%type;
    vscore TBLEXAMINFO.SCORE%type;
    vcheck varchar2(10);
begin

    DBMS_OUTPUT.PUT_LINE('번호   이름       등록일      응시여부    과목명');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    open vcursor;

    loop


        fetch vcursor into vseq, vname, vregisterdate, vsubjectname, vscore;
        exit when vcursor%notfound;

        if vscore is not null then vcheck := 'O';
        elsif vscore is null  then vcheck := 'X';
        end if;

        DBMS_OUTPUT.PUT_LINE(vseq || '    '|| vname || '    ' || vregisterdate ||  '     ' || vcheck || '     '|| vsubjectname);


    end loop;

end;

-- 교육생 개인 성적 조회
declare
    cursor vcursor is
    Select st.seq,
       St.name,
       SUb.subjectname,
       OpenCS.STARTDATE,
       OpenCS.ENDDATE,
       ex.EXDATE,
       EI.score
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

    vseq TBLSTUDENT.SEQ%type;
    vname TBLSTUDENT.NAME%type;
    vsubjectname TBLSUBJECT.SUBJECTNAME%type;
    vstartdate TBLOPENCOURSESUBJECT.STARTDATE%type;
    venddate TBLOPENCOURSESUBJECT.ENDDATE%type;
    vexdate TBLEXAM.EXDATE%type;
    vscore TBLEXAMINFO.SCORE%type;
begin
    DBMS_OUTPUT.PUT_LINE('번호   이름               과목기간              시험날짜      점수      과목명');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------');
    open vcursor;
    loop
        fetch vcursor into vseq, vname, vsubjectname, vstartdate, venddate, vexdate, vscore;
        exit when vcursor%notfound;
        DBMS_OUTPUT.PUT_LINE(vseq || '    '|| vname || '    ' || vstartdate || ' ~ ' || venddate || '     ' || vexdate || '    ' || vscore || '    ' || vsubjectname);


    end loop;
end;

-- 관리자 질문게시판: 전체 조회
declare
    cursor vcursor is
select q.SEQ ,
       st.NAME ,
       q.Q_DATE,
       q.TITLE,
       q.CONTENT,
       r.REPLY,
       tc.NAME
from TBLREPLY r
         inner join TBLQUESTION q on q.SEQ = r.Q_SEQ
         inner join TBLSTUDENT st
                    on q.S_SEQ = st.SEQ
         inner join TBLTEACHER tc
                    on r.T_SEQ = tc.SEQ;
    vseq TBLSTUDENT.SEQ%type;
    vname TBLSTUDENT.NAME%type;
    vqdate TBLQUESTION.Q_DATE%type;
    vtitle TBLQUESTION.TITLE%type;
    vcontent TBLQUESTION.CONTENT%type;
    vreply TBLREPLY.REPLY%type;
    vtcname TBLTEACHER.NAME%type;
begin


    DBMS_OUTPUT.PUT_LINE('번호   작성자   교사명        작성일        제목                                   내용                                                                          답변');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
    open vcursor;
    loop

        fetch vcursor into vseq, vname, vqdate, vtitle, vcontent, vreply, vtcname;
        exit when vcursor%notfound;
        DBMS_OUTPUT.PUT_LINE(vseq || '    '|| vname || '    ' || vtcname || '    ' || vqdate || '     ' ||  vtitle || '     ' || '🙋 ' || vcontent || '     ' || '🔑 ' || vreply);

    end loop;

end;

-- 학생 질문게시판: 같은반 학생이 작성한 글 조회
declare
    cursor vcursor is
select q.SEQ ,
       st.NAME ,
       q.Q_DATE,
       q.TITLE,
       q.CONTENT,
       r.REPLY,
       tc.NAME
from TBLREPLY r
         inner join TBLQUESTION q on q.SEQ = r.Q_SEQ
         inner join TBLSTUDENT st
                    on q.S_SEQ = st.SEQ
         inner join TBLTEACHER tc
                    on r.T_SEQ = tc.SEQ
where st.SEQ between 143 and 168;
    vseq TBLSTUDENT.SEQ%type;
    vname TBLSTUDENT.NAME%type;
    vqdate TBLQUESTION.Q_DATE%type;
    vtitle TBLQUESTION.TITLE%type;
    vcontent TBLQUESTION.CONTENT%type;
    vreply TBLREPLY.REPLY%type;
    vtcname TBLTEACHER.NAME%type;
begin


    DBMS_OUTPUT.PUT_LINE('번호    작성자   교사명        작성일        제목                                   내용                                                                          답변');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
    open vcursor;
    loop

        fetch vcursor into vseq, vname, vqdate, vtitle, vcontent, vreply, vtcname;
        exit when vcursor%notfound;
        DBMS_OUTPUT.PUT_LINE(vseq || '    '|| vname || '    ' || vtcname || '    ' || vqdate || '     ' ||  vtitle || '     ' || '🙋 ' || vcontent || '     ' || '🔑 ' || vreply);

    end loop;

end;

-- 담당학생이 작성한 글 조회 - 7강의실 선생님
declare
    cursor vcursor is
select q.SEQ ,
       st.NAME ,
       q.Q_DATE,
       q.TITLE,
       q.CONTENT,
       r.REPLY,
       tc.NAME
from TBLREPLY r
         inner join TBLQUESTION q on q.SEQ = r.Q_SEQ
         inner join TBLSTUDENT st
                    on q.S_SEQ = st.SEQ
         inner join TBLTEACHER tc
                    on r.T_SEQ = tc.SEQ
where st.SEQ between 1 and 30;
    vseq TBLSTUDENT.SEQ%type;
    vname TBLSTUDENT.NAME%type;
    vqdate TBLQUESTION.Q_DATE%type;
    vtitle TBLQUESTION.TITLE%type;
    vcontent TBLQUESTION.CONTENT%type;
    vreply TBLREPLY.REPLY%type;
    vtcname TBLTEACHER.NAME%type;
begin


    DBMS_OUTPUT.PUT_LINE('번호    작성자   교사명        작성일        제목                                   내용                                                                          답변');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
    open vcursor;
    loop

        fetch vcursor into vseq, vname, vqdate, vtitle, vcontent, vreply, vtcname;
        exit when vcursor%notfound;
        DBMS_OUTPUT.PUT_LINE(vseq || '    '|| vname || '    ' || vtcname || '    ' || vqdate || '     ' ||  vtitle || '     ' || '🙋 ' || vcontent || '     ' || '🔑 ' || vreply);

    end loop;

end;

--insert into TBLEXAMINFO (SEQ, SCORE, S_SEQ, EX_SEQ) VALUES (성적 번호, 성적, 교육생번호, 시험 번호)

-- 교사: 성적 등록
create or replace procedure procInsertScore(
    pseq number,
    pscore number,
    ps_seq number,
    pex_seq number
)

is
begin

    insert into TBLEXAMINFO (SEQ, SCORE, S_SEQ, EX_SEQ)
    VALUES(pseq, pscore, ps_seq, pex_seq);


end procInsertScore;

declare
begin
    procInsertScore(2033, 90, 336, 72);
end;

select * from TBLEXAMINFO where SEQ = 2033;

-- 교사: 성적 수정
create or replace  procedure procScoreUpdate(
    pseq number
)
is
begin
    update TBLEXAMINFO set SCORE = 88
    where SEQ = pseq;
end procScoreUpdate;

declare
begin
    procScoreUpdate(2033);
end;

select * from TBLEXAMINFO where SEQ = 2033;

-- 교사 성적 삭제
create or replace procedure procScoreDelete(
    pseq number
)
is
begin
    delete from TBLEXAMINFO where SEQ = pseq;
end procScoreDelete;

declare
begin
    procScoreDelete(2033);
end;

select * from TBLEXAMINFO;

-- 학생 질문 등록
create or replace procedure procInsertQuestion(
    pseq number,
    ptitle varchar2,
    pcontent varchar2,
    pq_date varchar2,
    ps_seq number
)

is
begin

    insert into TBLQUESTION (SEQ, TITLE, CONTENT, Q_DATE, S_SEQ)
    VALUES(pseq, ptitle, pcontent, pq_date, ps_seq);


end procInsertQuestion;

declare
begin
    procInsertQuestion(61, '제목', '질문내용', '2022-11-02', 300);
end;


select * from TBLQUESTION where SEQ = 61;

-- 학생 질문 수정
create or replace  procedure procQuestionUpdate(
    pseq number
)
is
begin
    update TBLQUESTION set CONTENT = '질문질문12345'
    where SEQ = pseq;
end procQuestionUpdate;

declare
begin
    procQuestionUpdate(61);
end;

select * from TBLQUESTION where SEQ = 61;

-- 학생 질문 삭제
create or replace procedure procQuestionDelete(
    pseq number
)
is
begin
    delete from TBLQUESTION where SEQ = pseq;
end procQuestionDelete;

declare
begin
    procQuestionDelete(61);
end;

select * from TBLQUESTION;

-- 교사 답변 수정
insert into TBLREPLY (SEQ, REPLY, Q_SEQ, T_SEQ) VALUES (61, '답변', 61, 1);

create or replace  procedure procReplyUpdate(
    pseq number
)
is
begin
    update TBLREPLY set REPLY = '답변12345'
    where SEQ = pseq;
end procReplyUpdate;

declare
begin
    procReplyUpdate(61);
end;

select * from TBLREPLY where SEQ = 61;

-- 교사 답변 삭제
create or replace procedure procReplyDelete(
    pseq number
)
is
begin
    delete from TBLREPLY where SEQ = pseq;
end procReplyDelete;

declare
begin
    procReplyDelete(61);
end;

select * from TBLREPLY;









