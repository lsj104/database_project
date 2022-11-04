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









