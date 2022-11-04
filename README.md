# 교육센터 관리 시스템  ✏️   

## 1. 기획 목적 🔥
기존의 교육센터 운영/관리에 있어서 관리자, 교사, 교육생, 수료생에게 계정 별 필요한 기능을 제공하며, 추가 요구사항에서의 교사 평가 / 공지사항 / 질문 게시판 / 문서 추천 / 수료생 게시판의 기능 추가를 통해 기존 일련의 작업들을 단순화시키고, DB 관리의 효율성을 증가시키고자 한다.

## 2. 개발 환경 ⚙️
<img width="1028" alt="스크린샷 2022-11-04 오후 6 37 03" src="https://user-images.githubusercontent.com/75536654/199941102-6a116cf6-bd80-4010-9c2c-0852951ff2de.png">

## 3. 팀원 소개 및 업무 분담 👨‍👨‍👧‍👦
<img width="530" alt="스크린샷 2022-11-04 오후 6 37 54" src="https://user-images.githubusercontent.com/75536654/199941260-cdc8775a-a53d-4703-810b-170dbff0b24e.png">

## 4. 사 용기술 🕹
* ANSI-SQL : DDL, DML
* PL/SQL: Procedure

## 5. ERD 🔮
<img width="1180" alt="스크린샷 2022-11-04 오후 6 39 10" src="https://user-images.githubusercontent.com/75536654/199941488-2b3c8734-9bc3-42e5-8237-fe8f2d7c1fe7.png">

## 7. 핵심 기능 설명 📚
1. 관리자 - 관리자 계정 로그인
<img width="125" alt="스크린샷 2022-11-04 오후 6 16 18" src="https://user-images.githubusercontent.com/75536654/199938119-aaa751f7-aa64-4c9a-b722-5cb79a236903.png">
2. 관리자 - 특정 과정의 개설 과목 정보 조회
<img width="527" alt="스크린샷 2022-11-04 오후 6 21 47" src="https://user-images.githubusercontent.com/75536654/199938251-3e154cad-7e03-4bd9-8851-ffa36a78fd93.png">
3. 관리자 - 수료한 교육생의 과정 및 정보 조회
<img width="557" alt="그림1" src="https://user-images.githubusercontent.com/75536654/199938669-160d1484-c7b3-48ab-8fbe-292fa3cb813d.png">
4. 관리자 - 각 교육과정에 해당하는 모든 교사에 대한 평가 정보
<img width="615" alt="그림1" src="https://user-images.githubusercontent.com/75536654/199939381-759346a6-4545-4eb8-95c1-efda1225ab34.png">
5. 교사 - 현재 진행중인 과정에 속한 정보 조회
<img width="518" alt="그림1" src="https://user-images.githubusercontent.com/75536654/199938829-f771c6ca-c6ce-473e-89d0-6713044eea64.png">
6. 교사 - 진행중인 과정에 속한 학생 정보 조회
<img width="545" alt="그림1" src="https://user-images.githubusercontent.com/75536654/199938934-d4ff3aa4-9309-40b7-bd20-92f8a1867f51.png">
7. 교사 - 교육생 출석 점수 조회
<img width="374" alt="그림1" src="https://user-images.githubusercontent.com/75536654/199939059-a993cd48-184b-491f-abc5-ddd03bee04fe.png">
8. 교사 - 시험 응시 여부 조회
<img width="451" alt="그림1" src="https://user-images.githubusercontent.com/75536654/199939159-6fff4e14-9d6b-43c3-939e-98419791a240.png">
<img width="496" alt="그림1" src="https://user-images.githubusercontent.com/75536654/199939224-f5eb4cd9-a283-4c02-96a0-503d03511dda.png">
9. 교육생 - 개인 성적 조회
<img width="757" alt="그림1" src="https://user-images.githubusercontent.com/75536654/199939286-638ec8a5-324e-45df-b781-47ea8e74d21c.png">
10. 교육생 - 공지사항 조회
![그림1](https://user-images.githubusercontent.com/75536654/199939514-fb7acf73-729d-478f-aedf-6c094c0c3f99.png)
11. 질문 & 답변 게시판
<img width="984" alt="그림1" src="https://user-images.githubusercontent.com/75536654/199939694-c5ed1e3b-654a-454a-a74f-301b9d62ac59.png">
12. 추천 문서 게시판 - 교육생들이 사용해본 문서를 추천
<img width="1183" alt="스크린샷 2022-11-04 오후 6 32 26" src="https://user-images.githubusercontent.com/75536654/199940021-f904c828-fd49-42f8-8005-2285f068b27e.png">
13. 수료생 게시판 - 면접 후기, 취업 후기, 기업, 수료한 과정 정보
<img width="876" alt="그림1" src="https://user-images.githubusercontent.com/75536654/199940107-d3dee3ca-0f34-44a4-991a-a9e7fc48941f.png">

 
## 7. 전체 기능 설명 📚
* 관리자
  * 교사 정보 관리
  * 교육생 정보 관리
  * 개설 과정 및 과목 관리
  * 출결 관리 및 조회
  * 교사평가 관리 및 조회
  * 공지사항 관리 및 조회
  * 질문게시판 관리 및 조회
  * 문서추천기능 관리 및 조회
  * 수료생게시판 관리 및 조회
* 교사
  * 강의 스케줄 조회
  * 출석 점수 조회
  * 성적 입출력
  * 출결 관리 및 조회
  * 시험 관리 및 성적 조회
  * 교사 평가 조회
  * 공지사항 관리 및 조회
  * 문서추천 기능 조회
  * 수료생게시판 관리 및 조회
* 교육생
  * 성적 조회
  * 출결 조회
  * 과정 및 과목 조회
  * 교사 평가 작성
  * 공지사항 조회
  * 질문게시판 작성 및 조회
  * 문서추천기능 작성 및 조회
  * 수료생게시판 조회



