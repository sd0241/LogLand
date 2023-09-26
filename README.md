
# 이미지 메타데이터를 활용한 클라우드 기반 다이어리 서비스 LogLand
 
### 기간  
 2022.5.2.~2022.6.7.  
 
### 내용   
NodeJS와 React 기반 사진 다이어리 웹 사이트 AWS의 리소스들을 사용해 서비스 및 Terraform으로 프로비저닝
 
 ### 상세 과정
 
1. 뉴스 기사 크롤링  
   a. 연예,스포츠,정치등 6개 분야 네이버 뉴스 메인페이지에 있는 순서로(중복 제거) 6개씩 30분마다 크롤링(beautifulsoup4)   
   b. ‘xxx 키워드 검색‘ 입력시 xxx를 검색 후 관련 뉴스 크롤링(Selenium)    
2. 크롤링한 뉴스 기사 전처리 후 Kobart 모델링 후 요약기사 생성 
3. 기사 본문, 언론사, 요약 뉴스등 7개의 정보 RDS(mariadb)에 적재 
4. FastAPI로 뉴스 주제 음성 입력시 해당 주제 뉴스 기사 요약문 3개 or 검색하고 싶은 키워드 음성 입력시 해당 기사 요약문 1개를 response 하는 api 생성 
5. 라즈베리파이 4에 해당 api 호출 함수 생성 
6. 요약 뉴스 TTS 출력 
7. HTML & CSS 활용 FastAPI 웹 페이지 구현
 
### 사용 기술 stack
 
 ![image](./test_code1/stack.png)


### System Architecture  

![image](./test_code1/arc.png)  


### 인원 및 역할
- 총원 5명 
- 역할 : EKS 활용 LogLand 서비스, Terraform으로 AWS 리소스 프로비저닝

### 상세 역할

**< part (1) : EKS 활용 LogLand 서비스 >**  
   - 크롤링 한 뉴스 기사 원문 데이터 KoBART로 모델링 후 요약문 생성 
   - 크롤링한 데이터 + 요약문 RDS에 적재

**< part (2) : Raspberry Pi4 ↔ API 서버 연동 및 스피커 서비스 구현 >**
   - FastAPI에서 뉴스 주제, 키워드 검색시 요약문을 반환하는 api 생성
   - Raspberry Pi4에서 만들어진 api 호출 후 response된 요약문 tts로 출력하는 함수 생성  

**< part (3) : 웹 서버 생성 및 배포 >**
   - EC2 생성 후 서버 환경 구축
   - FastAPI로 만든 웹페이지 및 API AWS route53으로 도메인 등록 후 nginx로 배포

# 프로젝트 결과

## AI-Speaker & NewsSum 시연 영상 (썸네일 Click!)
[![mv](https://img.youtube.com/vi/i5SYENVIA4M/hqdefault.jpg)](https://www.youtube.com/watch?v=i5SYENVIA4M)
[![web](https://img.youtube.com/vi/gvhjLhK6EMc/hqdefault.jpg)](https://www.youtube.com/watch?v=gvhjLhK6EMc)


### 개선 사항 
- Stress Test 시 단순 HTTP 접속 테스트밖에 하지 못한점
- Kakao Login 밖에 구현하지 못한점(Cognito를 사용하지 않은 점)
- 다양한 Trouble Shooting을 경험해보지 못한 점
- 로깅, 모니터링 관련 깊이있는 작업 및 협업을 하지 못한 점
- ElastiCache를 Terraform으로 프로비저닝까지 했으나 시간 부족으로 연동하지 못했음
- Jira를 깊게 활용하지 못하고 Confluence도 써보지 못함(Notion으로 대체)
