-- 1~30: 수료생, 31~60: 교육생

select * from TBLQUESTION;
select * from TBLREPLY;


--질문 1. JDK
insert into tblQuestion values (1, 'jdk', 'jdk에 따라 java 버전이 달라지는건가요? jdk에 따라 java 버전이 종속적인건가요? ', '2021-05-25', 1);

insert into tblReply values (1, 'JDK는 소스코드를 class file로 전환(컴파일) 시켜주는 javac 와, class file을 실행하는 JRE로 구성되어 있습니다.  또한 JDK는 javac 와 jre를 포함하기에, 싸이즈가 큽니다.   그렇기때문에 개발머쉰에는 JDK를 설치하고,  개발된 프로그램을 실행하는 머쉰에는 javac가 필요없으므로, JRE만 설치해서 씁니다. JDK 8으로 생성된 class file은 Java 8으로 물론 실행되며, 상위버전 Java 9, 10, 11으로 호환됩니다. 이걸 backward compatible 이라합니다.  하지만 하위 버전으로는 실행이 안됩니다.', 1, 1);

--질문 2. Java
insert into tblQuestion values (2, 'Java', 'Java(jdk)버젼을 확인하고 싶습니다! 어떤 방법이 있을까요?', '2021-05-26', 2);

insert into tblReply values (2, 'java -version 명령어로 (현재 시스템의 PATH에 설정된) 자바 버전을 알 수 있습니다. 두 번째로는 javac 버젼으로 javac도 java와 동일하게 -version 옵션으로 확인 할 수 있습니다. javac는 Java 코드를 바이트 코드로 변환할 때 사용됩니다. 즉, Java 코드가 있는 .java 파일을 바이트 코드가 저장되는 .class 파일로 변환합니다. java는 Java의 바이트 코드 읽고 실행하는데 사용됩니다.', 2, 1);

--질문 3. 이클립스
insert into tblQuestion values (3, 'Java', '이클립스 실행 시 Version 1.8.~ of the JVM is not suitable for this product. Version: 11 or greater is required.라는 내용의 오류가 발생합니다.', '2021-05-30', 5);

insert into tblReply values (3, '이클립스를 기본설정대로 설치했으면 C:\Users\사용자이름\eclipse\jee-2020-09\eclipse 폴더의 eclipse.ini 파일을 메모장으로 열어 margs 위에 vm 자신의 jdk 설치 경로를 적어주고 저장후 다시 이클립스를 실행해보세요.',
3, 1);

--질문 4. 오라클
insert into tblQuestion values (4, '오라클', 'SQL Developer로 Docker Oracle 서버에 접속하는데 무한로딩이 걸려서 응답없음이 표시됩니다..', '2021-06-14', 10);

insert into tblReply values (4, 'Preferences > Code Editor > Completion Insight 환경설정 > 코드편집기 > 완성인사이트 SQL 워크시트에서 완성 자동팝업 사용을 해제하고 다시 접속합니다. "Enable Completion Auto-Popup in SQL Worksheet" 다시 접속됩니다.', 4, 1);

--질문 5. SQL Developer
insert into tblQuestion values (5, 'SQL Developer', 'Developer를 실행하는데 실행되지 않고 로드 중... 창에서 넘어가지 않습니다.', '2021-06-20', 19);

insert into tblReply values (5, '1. %appdata% 폴더로 이동한다 > 2. SQL Developer 폴더를 삭제한다. 3. SQL Developer를 다시 실행하면 켜진다.', 5, 1);

--질문 6. 자바
insert into tblQuestion values (6, '자바', '오류 문구로 cannot resolve symbol symbol : class in () location : class StackTest() 가 출력되었는데 어디가 문제인지 잘 모르겠습니다.', '2021-06-28', 34);

insert into tblReply values (6, '보통 이 에러는 철자가 틀렸을 경우에 많이 발생합니다. 클래스, 메소드, 변수의 철자를 세심히 확인해 보고, 특히 철자를 확인할때 대 소문자 구분을 확실히 체크하세요. (자바는 대소문자를 구별합니다.) 그리고 클래스에서 발생할 경우 import를 해주었는지 확인필요.', 6, 2);

--질문 7. 자바
insert into tblQuestion values (7, '자바', 'non-static variable a cannot br referenced from a static context 에러가 발생합니다...', '2021-07-02', 41);

insert into tblReply values (7, 'static 선언자의 사용어부를 살펴보고 static 메소드 안에 static으로 선언되어지지 않은 메소드나 변수가 있는지 확인해보세요. 만약 그런것이 있으면 메소드를 새로 만들어 그쪽에서 선언하되, 인스턴스를 생성해서 불러줘야 합니다.', 7, 2);

--질문 8. 오라클
insert into tblQuestion values (8, '오라클', '실행 시 "요청한 작업을 수행하는 중 오류 발생: IO오류 : The Network Adapter coupd not establish the connection" 와 같은 문구가 뜨면서 실행이 안됩니다!', '2021-07-14', 47);

insert into tblReply values (8, '서비스(로컬) 선택 작업 관리자 창에서 서비스 >  OracleService로 시작되는 OracleServiceXe 를 선택한 후, 서비스 시작 버튼을 클릭합니다. 마찬가지의 방법으로, 목록 중 "Oracle... TNSListner" 도 선택하여, 서비스를 시작해 줍니다.', 8, 2);

--질문 9. 자바
insert into tblQuestion values (9, '자바', 'variable num might not have been intialized라고 에러가 뜨는데 어떻게 해결해야하는지 모르겠습니다.', '2021-07-27', 50);

insert into tblReply values (9, '이 에러는 지역변수(메소드 내에서 선언한 변수)를 초기화 하지 않은채 선언했을 경우 발생하고, 맴버 필드가 아닌 경우는 반드시 변수 선언시 초기화를 해주어야 합니다. (맴버 필드는 자바 프로그램 자체에서 자동으로 default값으로 초기화 해준다.)', 9, 2);

--질문 10. SQL Developer
insert into tblQuestion values (10, 'SQL Developer', ' DB 연결 설정을 하다가 실패 -테스트 실패: IO 오류: The Newtork Adapter could not establish the connection 라고 뜹니다 해결 방법을 잘 모르겠습니다...', '2021-08-16', 60);

insert into tblReply values (10, '우선 cmd창을 열어서 ipconfig를 입력해 IP주소를 확인하고, 여기서 확인한 IPv4 주소를 [호스트 이름]에 "localhost" 대신 넣어주고 다시 해보세요.', 10, 2);

--질문 11.오라클
insert into tblQuestion values (11, '오라클', '디벨로퍼 실행 시 Oracle] SQL Developer "오류 : 업체코드 17002, 12505" SQL Developer 17002, 12505 라고 에러가 뜨면서 실행이 되지 않습니다ㅠㅠ', '2021-07-22', 63);

insert into tblReply values (11, '특정 오라클 서비스들이 실행되지 않아 오라클과 SQL Developer가 연결할 수 없어 발생하는 에러로 보입니다. 작업 관리자 > 서비스에 들어간 후 OracleMTSRecoveryService, OracleServiceXE, OracleXEClrAgent, OracleXETNSListener4가지 서비스가 모두 실행중이어야 합니다.', 11, 3);

--질문 12.자바
insert into tblQuestion values (12, '자바', '인터페이스 관련 복습 중 MouseEvent(Test) should be declared abstract; it does not define 라는 에러가 떴는데 어떤 에러인지 궁금합니다...!', '2021-08-11', 63);

insert into tblReply values (12, 'Interface는 모든 메소드가 선언만 되고 구현되지 않은 추상 메소드입니다. 만약 Interface를 implements하려면 implements한 클래스가 Interface에서 선언한 모든 메소드를 구현해 주어야 합니다. ', 12, 3);

--질문 13.자바
insert into tblQuestion values (13, '자바', ' unexpected type required : value(Int) found : class(char) 라는 에러가 났는데, 어디가 문제인지 모르겠습니다..', '2021-08-20', 63);

insert into tblReply values (13, 'unexpected type 에러를 해석하면 "기대하지 않은 타입"이란 뜻을 가지고 있습니다. 즉, 원하는 타입(required)이 아닌데 잘못된 타입(found)을 써준 경우 발생합니다. 에러 체크된 부분의 타입을 required 에서 나타난 타입으로 변경해 주시면 됩니다.', 13, 3);

--질문 14. 자바
insert into tblQuestion values (14, '자바', '실행은 되는것 같은데 java.lang.ArrayIndexOutBoundsException at Test.main 라며 배열 어딘가에서 에러 문구가 나온것같습니다.', '2021-09-19', 63);

insert into tblReply values (14, '이 에러는 특이하게 컴파일은 이상없이 되지만 실행을 하면 발생하는 에러입니다. 배열의 범위를 넘어설 경우에 발생하므로 에러난 위치의 배열의 참조 범위를 확인해보시고 선언해둔 배열의 범위에 맞게 조정해 주시면 됩니다.', 14, 3);

--질문 15. 자바
insert into tblQuestion values (15, '자바', '이 에러에 대한 답을 듣고싶어요ㅠㅠ java.io.InputStream(Test) is abstract; cannot be instantiated', '2021-10-21', 90);

insert into tblReply values (15, 'abstract로 선언된 클래스를 직접 new 명령어를 이용하여 인스턴스화 할 경우에 발생하는 에러입니다. 왜냐하면, 추상 클래스는 직접 new 명령어를 이용하여 인스턴스화 할 수 없기 때문입니다. 이 경우에는 인스턴스를 다른 방법으로 생성하시면 됩니다.', 15, 3);


--질문 16. Java
insert into TBLQUESTION values (16
                                ,'이클립스'
                                ,'Mac을 사용중인데 이클립스에서 한글을 입력할때 마지막 글자가 지워지는데 왜 이러는걸까요? ㅠㅠ'
                                ,'2021-09-23'
                                ,167);

insert into TBLREPLY values (16
                            ,'이클립스 맥 버전을 시용할 때 생기는 버그입니다 ㅠㅠ..'
                            ,16
                            ,6);

--질문 17. Python
insert into TBLQUESTION values (17
                                ,'파이썬 ValueError'
                                ,'Python ValueError가 발생했는데 왜 오류가 났을까요? ㅠㅠ'
                                ,'2021-10-27'
                                ,91);

insert into TBLREPLY values (17
                            ,'ValueError는 부적절한 값을 가진 인자를 받았을 때 발생하는 에러입니다.'
                            ,17
                            ,4);

--질문 18. Python
insert into TBLQUESTION values (18
                                ,'파이썬 NameError'
                                ,'파이썬 프로그래밍중 NameError가 발생했는데 왜 오류가 났을까요? ㅠㅠ'
                                ,'2021-10-28'
                                ,93);

insert into TBLREPLY values (18
                            ,'지역변수, 전역 변수 이름을 찾을 수 없는 경우에 NameError 가 발생합니다. 즉, 위에서 선언하지도 않은 변수를 사용하려고 할 때 발생하는 에러입니다."네가 사용하려는 변수가 없는데?" 이런 에러입니다.'
                            ,18
                            ,4);

--질문 19. Python
insert into TBLQUESTION values (19
                                ,'파이썬 OverFlowError'
                                ,'파이썬 프로그래밍중 OverFlowError가 발생했는데 왜 오류가 났을까요...???'
                                ,'2021-11-03'
                                ,110);

insert into TBLREPLY values (19
                            ,'연산의 결과가 너무 커서 데이터 타입이 표현할 수 있는 숫자의 범위를 넘어가는 경우에 발생합니다.'
                            ,19
                            ,4);

--질문 20. 오라클
insert into TBLQUESTION values (20
                                ,'오라클 오류'
                                ,'Ora-01045 오류가 왜 발생했을까요?'
                                ,'2021-11-30'
                                ,163);

insert into TBLREPLY values (20
                            ,'유저 생성 후에 Ora-01045 에러가 발생하면 생성하고 권한을 주지 않아서 발생하는 에러입니다.'
                            ,20
                            ,6);

--질문 21. 오라클
insert into TBLQUESTION values (21
                                ,'오라클 에러 발생'
                                ,'ORA-00001 오류가 왜 발생했을까요? ㅠㅠㅠ'
                                ,'2021-12-01'
                                ,145);

insert into TBLREPLY values (21
                            ,'UPDATE 또는 INSERT 문이 중복 키를 삽입하려할때 발생하는 오류입니다. 고유 제한 사항을 제거하거나 키를 삽입하지않으면 해결할 수 있습니다.'
                            ,21
                            ,6);

--질문 22. 오라클
insert into TBLQUESTION values (22
                                ,'오라클 에러좀 봐주세요 ㅠㅠ'
                                ,'ORA-00022 에러가 발생했는데 어떻게 해결해야하나요??'
                                ,'2021-12-02'
                                ,161);

insert into TBLREPLY values (22
                            ,'지정된 세션이 존재하지 않거나 호출자에게 액세스 권한이 없을때 발생하는 오류입니다. 액세스 권한이있는 올바른 세션 ID를 지정하면 해결할 수 있습니다.'
                            ,22
                            ,6);

--질문 23. html
insert into TBLQUESTION values (23
                                ,'Html 501'
                                ,'501 Not Implemented 에러가 발생했는데 무슨 뜻 인가요?'
                                ,'2021-12-05'
                                ,117);

insert into TBLREPLY values (23
                            ,'서버가 요청을 이행하는 데 필요한 기능을 지원하지 않음을 나타냅니다.'
                            ,23
                            ,5);

--질문 24. html
insert into TBLQUESTION values (24
                                ,'Html 502'
                                ,'502 Bad Gateway 에러가 발생했는데 무슨 뜻 인가요?'
                                ,'2021-12-07'
                                ,120);

insert into TBLREPLY values (24
                            ,'서버가 게이트웨이로부터 잘못된 응답을 수신했음을 의미합니다. 인터넷상의 서버가 다른 서버로부터 유효하지 않은 응답을 받은 경우 발생합니다.'
                            ,24
                            ,5);

--질문 25. html
insert into TBLQUESTION values (25
                                ,'Html 504 에러'
                                ,'504 Gateway Timeout 오류가 왜 발생했을까요? ㅠㅠ'
                                ,'2021-12-10'
                                ,133);


insert into TBLREPLY values (25
                            ,'웹페이지를 로드하거나 브라우저에서 다른 요청을 채우려는 동안 한 서버가 액세스하고 있는 다른 서버에서 적시에 응답을 받지 못했음을 의미합니다. 이 오류 응답은 서버가 게이트웨이 역할을 하고 있으며 적시에 응답을 받을 수 없을 경우 주어집니다. 이 오류는 대게 인터넷상의 서버 간의 네트워크 오류이거나 실제 서버의 문제입니다. 컴퓨터, 장치 또는 인터넷 연결에 문제가 아닐 수 있습니다.'
                            ,25
                            ,5);

--질문 26. html
insert into TBLQUESTION values (26
                                ,'Html 작성중 506에러가 발생했어요 ㅠㅠ'
                                ,'506 Variant Also Negotiates 오류가 발생했는데 왜 이러는걸까요??'
                                ,'2021-12-15'
                                ,137);

insert into TBLREPLY values (26
                            ,'서버에 내부 구성 오류가 있는 경우 발생합니다. 요청을 위한 투명한 콘텐츠 협상이 순환 참조로 이어집니다.'
                            ,26
                            ,5);

--질문 27. CSS
insert into TBLQUESTION values (27
                                ,'CSS 파일 변경 후 적용'
                                ,'CSS 파일 변경 후 적용이 안되는데 어떻게 해야하나요? ㅠㅠ'
                                ,'2021-12-22'
                                ,117);

insert into TBLREPLY values (27
                            ,'브라우저 캐시 삭제를 해보세요!'
                            ,27
                            ,5);

--질문 28. html
insert into TBLQUESTION values (28
                                ,'Html 응답코드'
                                ,'422 Unprocessable Entity (WebDAV) 응답코드가 무슨 뜻인가요??'
                                ,'2022-01-05'
                                ,166);

insert into TBLREPLY values (28
                            ,'요청은 잘 만들어졌지만, 문법 오류로 인하여 따를 수 없다는 의미입니다.'
                            ,28
                            ,6);

--질문 29. CSS
insert into TBLQUESTION values (29
                                ,'CSS Link'
                                ,'Css를 Link태그로 걸었는데 적용이 안돼요 ㅠㅠ'
                                ,'2022-01-10'
                                ,130);

insert into TBLREPLY values (29
                            ,'브라우저 캐시를 지워보고 만약 안된다면 Css파일 이름 변경도 해보세요'
                            ,29
                            ,5);

--질문 30. html
insert into TBLQUESTION values (30
                                ,'Html 응답코드 405'
                                ,'405 Method Not Allowed 응답코드가 무슨 의미인가요? ㅠㅠ'
                                ,'2022-01-25'
                                ,168);

insert into TBLREPLY values (30
                            ,'요청한 메소드는 서버에서 알고 있지만, 제거되었고 사용할 수 없습니다. 예를 들어, 어떤 API에서 리소스를 삭제하는 것을 금지할 수 있습니다. 필수적인 메소드인 GET과 HEAD는 제거될 수 없으며, 이 에러 코드를 리턴할 수 없습니다.'
                            ,30
                            ,6);


--질문31. Java
select * from TBLQUESTION;
select * from TBLREPLY;

insert into TBLQUESTION values (31
                                ,'자바 난수'
                                ,'원하는 범위의 난수를 얻으려면 어떻게 해야하나요?'
                                ,'2022-05-25'
                                ,180);

insert into TBLREPLY values (31
                            ,'Math.random()를 사용하세요.'
                            ,31
                            ,1);

--질문 32. Java
insert into TBLQUESTION values (32
                                ,'자바 에러 도와주세요 ㅠㅠ'
                                ,'Exception in thread "main" java.io.FileNotFoundException 메시지가 떴는데 왜 이러는걸까요???'
                                ,'2022-05-26'
                                ,175);

insert into TBLREPLY values (32
                            ,'파일에 접근하려고 하는데 파일을 찾지 못했을 때 발생하는 에러입니다.'
                            ,32
                            ,1);

--질문33. Java
insert into TBLQUESTION values (33
                                ,'추상클래스, 인터페이스'
                                ,'추상클래스와 인터페이스의 차이점을 잘 모르겠습니다.'
                                ,'2022-05-29'
                                ,170);

insert into TBLREPLY values (33
                            ,'멤버변수나 일반메서드(추상메서드가 아닌 메스다)가 하나라도 포함되어야한다면 추상 클래스로 작성하세요. 인터페이스는 하나 이상 구현할 수 있지만, 상속할수있는 클래스는 단 하나이므로 추상메서드만으로 구성된 클래스라면, 추상클래스로 하는 것보다는 인터페이스로 작성하는 것이 좋습니다.'
                            ,33
                            ,1);

--질문 34. 자바
insert into TBLQUESTION values (34
                                ,'자바 오류좀 봐주세요!!'
                                ,'MouseEvent(클래스명) should be declared abstract; it does not define 오류가 발생했는데 왜 발생한걸까요?'
                                ,'2022-06-10'
                                ,177);

insert into TBLREPLY values (34
                            ,'implements한 Interface의 모든 메소드를 구현하지 않아서 발생되는 오류입니다.'
                            ,34
                            ,1);

--질문 35. 자바
insert into TBLQUESTION values (35
                                ,'illegal start of expression'
                                ,'자바 illegal start of expression 오류가 발생했는데 무슨 오류인가요? ㅠㅠ'
                                ,'2022-06-12'
                                ,175);

insert into TBLREPLY values (35
                            ,'문장에 문법적 오류가 있다는 뜻입니다. 에러가 발생한 곳의 문법을 확인해보세요.'
                            ,35
                            ,1);

--질문 36. 자바스크립트
insert into TBLQUESTION values (36
                                ,'자바스크립트 오류 도와주세요 ㅠㅠ'
                                ,'SyntaxError: missing ) after argument list 이라는 메시지가 떴는데 어떻게 해결해야하나요? ㅠㅠ'
                                ,'2022-06-24'
                                ,175);

insert into TBLREPLY values (36
                            ,'consoe.log 호출 시 )를 누락하였습니다.'
                            ,36
                            ,1);

--질문 37. 자바
insert into TBLQUESTION values (37
                                ,'class, interface, or enum expected'
                                ,'class, interface, or enum expected 오류가 발생했는데 무슨 오류인가요???'
                                ,'2022-06-27'
                                ,225);

insert into TBLREPLY values (37
                            ,'이 메시지의 의미는 ‘키워드 class나 interface 또는 enum가 없다.’ 이지만, 보통 괄호(‘{’ 또는 ‘}’)의 개수가 일치하지 않는 경우에 발생합니다. 열린 괄호 {와 닫힌괄호}의 개수가 같은지 확인해야 합니다.'
                            ,37
                            ,2);

--질문38. Java
insert into TBLQUESTION values (38
                                ,'자바  cannot find symbol'
                                ,'자바  cannot find symbol오류가 발생했는데 무슨 문제일까요? ㅠㅠ'
                                ,'2022-07-12'
                                ,233);

insert into TBLREPLY values (38
                            ,'지정된 변수나 메서드를 찾을 수 없다는 뜻으로 선언되지 않은 변수나 메서드를 사용하거나, 변수나 메서드의 이름을 잘못 사용한 경우에 발생합니다. 자바에서는 대소문자 구분을 하기 때문에 철자뿐만 아니라 대소문자의 일치 여부도 꼼꼼하게 확인해야 합니다.'
                            ,38
                            ,3);

--질문39. Java
insert into TBLQUESTION values (39
                                ,'자바 Exception in thread "main" java.lang.NoSuchMethodError: main'
                                ,'자바 Exception in thread "main" java.lang.NoSuchMethodError: main 오류가 왜 발생했을까요??'
                                ,'2022-07-15'
                                ,255);

insert into TBLREPLY values (39
                            , 'main메서드를 찾을 수 없다.’는 뜻인데 실제로 클래스 내에 main메서드가 존재하지 않거나 메서드의 선언부(public static void main(String[] args))에 오타가 존재하는 경우에 발생합니다.'
                            ,39
                            ,3);

--질문 40. 자바
insert into TBLQUESTION values (40
                                ,'자바 오류 질문이요 ㅠㅠ'
                                ,'unreported exception java.io.IOException(Exception명); must be caught or declatred to be thrown 오류가 발생했는데 왜 발생한걸까요?'
                                ,'2022-07-20'
                                ,235);

insert into TBLREPLY values (40
                            ,'예외가 발생했는데 예외처리를 하지 않았을 경우 발생하는 오류입니다.'
                            ,40
                            ,3);

--질문 41. 자바
insert into TBLQUESTION values (41
                                ,'자바 큐'
                                ,'자바 큐에 객체를 꺼내서 반환하는 메서드가 무엇인가요??'
                                ,'2022-07-28'
                                ,244);

insert into TBLREPLY values (41
                            ,'object poll()입니다.'
                            ,41
                            ,3);


--질문 42. Java
insert into TBLQUESTION values (42
                                ,'자바 오류'
                                ,'Exception in thread "main" java.lang.NullPointerException이라는 오류 메시지가 떴는데 이게 뭔가요? ㅠㅠ'
                                ,'2022-07-29'
                                ,266);

insert into TBLREPLY values (42
                            ,'null은 유효한 객체 인스턴스가 아니므로 할당되는 메모리가 없습니다. null객체에 접근하거나 method를 호출하는 경우 발생하는 에러입니다.'
                            ,42
                            ,4);

--질문 43. 자바
insert into TBLQUESTION values (43
                                ,'자바 큐 메서드'
                                ,'자바 큐에 객체를 저장하는 메서드가 무엇인가요??'
                                ,'2022-07-30'
                                ,266);

insert into TBLREPLY values (43
                            ,'boolean offer(Object o)입니다.'
                            ,43
                            ,4);

--질문 44. 자바
insert into TBLQUESTION values (44
                                ,'자바 에러메시지좀 봐주세요 ㅠㅠ'
                                ,'package java.servlet(패키지명) does not exist오류가 발생했는데 왜 발생한걸까요?'
                                ,'2022-08-01'
                                ,279);

insert into TBLREPLY values (44
                            ,'import한 패키지가 존재하지 않을 경우 발생되는 오류입니다.'
                            ,44
                            ,1);

--질문45. Java
insert into TBLQUESTION values (45
                                ,'ArrayIndexOutOfBoundsException오류'
                                ,'프로젝트를 진행하던중 Exception in thread "main" java.lang.ArrayIndexOutOfBoundsException 오류가 발생했는데 무슨 오류인가요??'
                                ,'2022-08-10'
                                ,287);

insert into TBLREPLY values (45
                            ,'배열의 범위를 넘어선 인덱스를 참조할 때 발생하는 에러입니다.'
                            ,45
                            ,5);

--질문46. JS
insert into TBLQUESTION values (46
                                ,'Map'
                                ,'Map안에 또 Map을 만드는 것도 가능할까요?'
                                ,'2022-08-13'
                                ,250);

insert into TBLREPLY values (46
                            ,'새로운 Map을 생성해서 원래 있던 value를 replace해주면 되지 않을까요?'
                            ,46
                            ,2);

--질문47. 오라클
insert into TBLQUESTION values (47
                                ,'DDL'
                                ,'DDL이 무엇인지 잘 모르겠어요 ㅠㅠ..'
                                ,'2022-08-20'
                                ,210);

insert into TBLREPLY values (47
                            ,'DDL은 데이터베이스를 정의하는 언어이며, 데이터를 생성, 수정, 삭제하는등의 데이터의 전체 골격을 결정하는 역할을 하는 언어입니다.'
                            ,47
                            ,2);

--질문 48. 자바스크립트
insert into TBLQUESTION values (48
                                ,'a javascript error occurred in the main process 오류'
                                ,'a javascript error occurred in the main process 오류가 발생했는데 어떻게 해결해야하나요? ㅠㅠ'
                                ,'2022-08-30'
                                ,200);

insert into TBLREPLY values (48
                            ,'관련 프로그램들이 겹치거나 오류가 났을 확률이 높습니다. 관련된 프로그램들을 종료한 후 삭제하고 재부팅하면 쉽게 해결할 수 있습니다.'
                            ,48
                            ,2);

--질문 49. 자바
insert into TBLQUESTION values (49
                                ,'자바 큐 메서드 질문이요!'
                                ,'자바 큐에 객체를 읽어오는 메서드가 무엇인가요??'
                                ,'2022-09-01'
                                ,309);

insert into TBLREPLY values (49
                            ,'Object peek()입니다.'
                            ,49
                            ,5);


--질문 50. 자바
insert into TBLQUESTION values (50
                                ,'자바 illegal start of expression'
                                ,'illegal start of expression오류가 발생했는데 왜 발생한걸까요?'
                                ,'2022-09-03'
                                ,299);

insert into TBLREPLY values (50
                            ,'선언자(modifier)를 잘못 집에 넣은 경우 발생되는 오류입니다.'
                            ,50
                            ,5);

--질문 51. 오라클
insert into TBLQUESTION values (51
                                ,'오라클 실행순서'
                                ,'오라클 각 절의 실행순서가 어떻게되나요??'
                                ,'2022-09-05'
                                ,222);


insert into TBLREPLY values (51
                            ,'1.from, 2.where, 3.group by, 4.having, 5.select, 6.order by 순으로 실행됩니다.'
                            ,51
                            ,2);

--질문 52. 오라클
insert into TBLQUESTION values (52
                                ,'ORA-00918'
                                ,'ORA-00918 오류가 발생했는데 어떻게 해결해야하나요? ㅠㅠ'
                                ,'2022-09-08'
                                ,225);

insert into TBLREPLY values (52
                            ,'조회 시에 테이블에 같은 이름의 컬럼이 있고 alias를 사용하지 않은 상태에서 select할 때 어떤 컬럼의 값을 사용할 지 알 수 없기 때문에 나는 오류입니다. 해결법은 alias를 지정하거나 select문에서 둘 중에 한 컬럼을 제거하면 됩니다.'
                            ,52
                            ,2);

--질문 53. JS
insert into TBLQUESTION values (53
                                ,'노드 모듈'
                                ,'파일이 폴더 안에 없을 땐 노드를 키면 실행이 되는데 파일이 폴더 안에 있을땐 노드를 키면 모듈을 찾을 수 없다고 에러가 납니다..'
                                ,'2022-09-20'
                                ,270);

insert into TBLREPLY values (53
                            ,'node를 실행하실때 현재 본인의 위치에서 실행하고자 하는 파일의 relative path를 주어야합니다.'
                            ,6
                            ,4);

--질문54. 오라클
insert into TBLQUESTION values (54
                                ,'ORA-00904오류'
                                ,'ORA-00904오류가 왜 발생했을까요..? ㅠㅠ'
                                ,'2022-09-20'
                                ,235);

insert into TBLREPLY values (54
                            ,'입력된 열 이름이 누락되었거나 잘못 되었을 경우 발생하는 오류인데 해당 열이 테이블에 존재하는지 확인해보세요.'
                            ,54
                            ,3);

--질문55. 오라클
insert into TBLQUESTION values (55
                                ,'ORA-00937'
                                ,'ORA-00937 오류가 발생했어요.. ㅠㅠㅠ'
                                ,'2022-10-01'
                                ,270);

insert into TBLREPLY values (55
                            ,'컬럼 리스트에 집계 함수와 일반 컬럼을 동시에 사용할 수 없습니다.'
                            ,55
                            ,4);

--질문56. 오라클
insert into TBLQUESTION values (56
                                ,'ORA-00937'
                                ,'ORA-00937 오류가 발생했어요.. ㅠㅠㅠ'
                                ,'2022-10-01'
                                ,270);

insert into TBLREPLY values (56
                            ,'입력된 열 이름이 누락되었거나 잘못 되었을 경우 발생하는 오류입니다. 해당 열이 테이블에 존재하는지 확인해보세요.'
                            ,56
                            ,4);

--질문 57. 자바
insert into TBLQUESTION values (57
                                ,'자바오류좀 봐주세요 ㅠㅠ'
                                ,'ArithmeticException 오류가 왜 발생했을까요??'
                                ,'2022-10-15'
                                ,313);

insert into TBLREPLY values (57
                            ,'정수를 0으로 나눌경우 발생하는 오류입니다.'
                            ,57
                            ,6);


--질문58. Spring
insert into TBLQUESTION values (58
                                ,'토큰 실시간 인식'
                                ,'로그인해서 토큰을 가져오는 것까지는 성공하였으나, 실시간으로 인식해서 바뀌지 못하고 새로고침을 해야 인식을 하고 바뀌고 있습니다. 어떤 식으로 코드를 손 보면 좋을까요??'
                                ,'2022-10-22'
                                , 199);
insert into TBLREPLY values (58
                            , '이런식으로 바로 호출하면 어떨까요? 그리고 else if 문은 필요 없어 보입니다! 함수 scope 인 것 같은데 if문 조건 만족하지 않으면 제가 작성한 것처럼 바로 return 해버리면 되니까요! 굳이 else if(!token)은 체크할 필요 없을 것 같아요'
                            ,58
                            ,2);

--질문59. 오라클
insert into TBLQUESTION values (59
                                ,'오라클 조건절'
                                ,'오라클 조건절(where)에서 사용하는 구문 종류가 궁금해요!'
                                ,'2022-10-25'
                                ,287);

insert into TBLREPLY values (59
                            ,'조건절(where)에서 사용하는 구문에는 1.between, 2.in, 3.like가 있습니다.'
                            ,59
                            ,5);

--질문60. Spring
insert into TBLQUESTION values (60
                                ,'서버 이미지'
                                ,'서버에 이미지 폴더를 만들어서 거기에 이미지들을 저장하고 db에는 그 폴더의 경로를 저장해놔서 프론트에 이미지가 필요한 페이지는 response에 그 경로를 전달해서 사용할수 있게 하고 싶은데 어떻게 해야할까요?'
                                ,'2022-11-01'
                                , 201);

insert into TBLREPLY values (60
                            ,'노드는 multer 를 사용하는 것으로 알고있습니다.'
                            ,60
                            ,2);


select * from TBLQUESTION;
select * from TBLREPLY;

select * from TBLCOURSEINFO where COMPLETEDATE is null;





















