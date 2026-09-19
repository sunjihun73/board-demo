# 사내 업무 게시판 (PM 교육용 베이스라인)

Claude Code 활용 개발 시연 90분 교육의 **시작 상태(step 0)** 프로젝트입니다.
커리큘럼 초안 v0.2의 "시연 환경(교육용 가정)"에 맞춰 구성했습니다.

- 업무 애플리케이션 : Spring Boot 3.3.5 + JSP + MyBatis + PostgreSQL 16(로컬 Docker)
- 기본 기능 : 게시판 목록 / 상세 / 등록, 페이징, 교육용 로그인 계정
- **검색 기능은 포함되어 있지 않습니다.** (세션 2에서 Claude Code로 구현하는 대상)

---

## 1. 실행 환경

| 항목 | 버전 |
|---|---|
| JDK | 21 (검증 기준 21.0.12) |
| 빌드 | Gradle 8.10.2 (래퍼 포함 — 별도 설치 불필요) |
| DB | PostgreSQL 16 (Docker 컨테이너) |
| 패키징 | war (JSP 렌더링을 위해 jar 대신 war 사용) |

## 2. DB 기동 (Ubuntu + Docker)

```bash
cd board-demo
docker compose up -d
docker compose ps            # health 확인
```

| 항목 | 값 |
|---|---|
| 호스트/포트 | localhost:5432 |
| DB | boarddb |
| 계정 | boarduser / boardpw |
| 컨테이너명 | board-demo-postgres |
| 데이터 볼륨 | board-demo-pgdata |

접속 확인 :

```bash
docker exec -it board-demo-postgres psql -U boarduser -d boarddb -c "\dt"
```

정리 :

```bash
docker compose down          # 컨테이너만 중지·삭제 (데이터 유지)
docker compose down -v       # 볼륨까지 삭제 (완전 초기화)
```

> 5432 포트를 이미 쓰고 있다면 `docker-compose.yml`의 포트를 `"15432:5432"`로 바꾸고
> `application.properties`의 JDBC URL도 함께 수정하세요.

## 3. 애플리케이션 실행

```bash
./gradlew bootRun
```

또는 패키징 후 실행:

```bash
./gradlew clean build
java -jar build/libs/board-demo.war
```

- 접속 : http://localhost:8080
- 로그인 : `pmuser` / `pm1234`

> **기동할 때마다 `schema.sql` → `data.sql`이 실행되어 board 테이블이 재생성됩니다.**
> (`spring.sql.init.mode=always`) 시연 중 데이터가 지저분해져도 재기동하면 35건 초기 상태로 돌아갑니다.
> 입력한 데이터를 유지하려는 단계에서는 해당 설정을 `never`로 바꾸세요.

> 최초 실행 시 Gradle 배포판과 의존성 다운로드가 필요합니다. 교육 당일 네트워크 의존을 없애려면
> 사전에 한 번 `./gradlew clean build`를 실행해 `~/.gradle` 캐시를 채워 두세요.
> 이후에는 `./gradlew bootRun --offline`으로도 기동할 수 있습니다.

## 4. 화면 및 URL

| URL | 설명 |
|---|---|
| `/login` | 로그인 |
| `/board/list?page=1` | 목록 (페이지당 10건, 예제 데이터 35건 = 4페이지) |
| `/board/detail?id=1` | 상세 (조회수 증가) |
| `/board/writeForm`, `POST /board/write` | 등록 |
| `/board/writerList?writer=김PM` | 레거시 작성자 조회 화면 |

## 5. 프로젝트 구조

```
board-demo
├── docker-compose.yml        PostgreSQL 16
├── build.gradle / settings.gradle
├── gradlew, gradlew.bat, gradle/wrapper/
└── src/main
    ├── java/com/example/board
    │   ├── BoardDemoApplication.java
    │   ├── config/        WebConfig, LoginInterceptor(세션 기반 로그인 체크)
    │   ├── controller/    HomeController, LoginController, BoardController
    │   ├── domain/        Board, PageInfo
    │   ├── mapper/        BoardMapper (MyBatis 인터페이스)
    │   └── service/       BoardService
    ├── resources
    │   ├── application.properties
    │   ├── schema.sql / data.sql      초기 스키마·예제 데이터 35건
    │   ├── mappers/BoardMapper.xml    SQL
    │   └── static/css/style.css
    └── webapp/WEB-INF/views           login.jsp, board/list·detail·form·writerList.jsp
```

호출 흐름(세션 1 분석 대상) : `JSP → Controller → Service → Mapper(XML) → PostgreSQL`

## 6. 교육 세션과의 연결

| 세션 | 내용 | 베이스라인 상태 |
|---|---|---|
| 1. 레거시 파악 | 구조·호출 흐름 분석 | 분석 대상 소스 포함 |
| 2. 기능 추가 | 제목/내용 검색 구현 | **미구현** — 목록·건수 쿼리, 페이징, JSP가 수정 대상 |
| 3. 테스트 자동화 | Playwright E2E | 미포함 — 세션 3에서 생성 (고정 데이터 35건 준비됨) |
| 4. 취약점 점검 | SQL Injection·XSS | 취약 코드 포함 (아래 강사용 안내 참고) |
| 5. 연동 기술 | API 래핑 + MCP | 미포함 — 별도 모듈로 준비 예정 |

## 7. 강사용 안내 — 의도적으로 남겨 둔 취약 코드

교육용 로컬 환경(로컬 Docker PostgreSQL, 가상 데이터·가상 계정) 전용입니다. 외부 배포 금지.

1. **SQL Injection** — `src/main/resources/mappers/BoardMapper.xml`의 `selectByWriterLegacy`
   - `WHERE writer = '${writer}'` 로 사용자 입력을 문자열 결합
   - 진입점 : 목록 하단 "작성자 조회" 입력창 → `/board/writerList?writer=`
   - 재현 예 : `김PM' OR '1'='1` 입력 시 전체 목록이 조회됨
   - 조치 방향 : `#{writer}` 파라미터 바인딩
   - PostgreSQL JDBC는 기본적으로 한 Statement의 다중 구문 실행을 허용하므로,
     재현 시 조회 계열 입력만 사용하고 교육용 컨테이너 외부에서는 실행하지 마세요.

2. **XSS** — `src/main/webapp/WEB-INF/views/board/detail.jsp`
   - 제목·작성자·내용을 `${board.content}` 형태로 이스케이프 없이 출력
   - 재현 예 : 글쓰기에서 내용에 스크립트 태그를 포함해 등록 후 상세 화면 확인
   - 조치 방향 : `<c:out>` 또는 출력 맥락에 맞는 인코딩 적용
   - 참고 : 목록·작성자 조회 화면은 `<c:out>`을 사용하고 있어 대비 설명이 가능합니다.

## 8. 테스트

`src/test`의 스모크 테스트는 실제 DB에 접속합니다. 실행 전 `docker compose up -d`가 필요합니다.

```bash
./gradlew test
```

## 9. Git 태그

`step0-baseline` 태그로 초기 상태가 커밋되어 있습니다.
시연 중 상태가 꼬이면 아래로 복귀할 수 있습니다.

```bash
git status
git reset --hard step0-baseline
```

세션 진행에 맞춰 `step1-analysis`, `step2-search`, `step3-e2e`, `step4-security`, `step5-mcp`
태그를 추가로 만들어 두면 단계 전환이 쉬워집니다.
