# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 성격

Claude Code 활용 개발 시연 **90분 교육용 베이스라인(step 0)** 프로젝트입니다. 의도적으로 레거시 스타일(JSP + MyBatis XML + 세션 로그인)로 작성되었고, **검색 기능은 일부러 빠져 있으며**(세션 2 구현 대상), **취약 코드가 의도적으로 남아 있습니다**(세션 4 점검 대상). 따라서:

- 리팩터링이나 "현대화"를 자발적으로 제안하지 마세요. 레거시 구조 자체가 교재입니다.
- 아래 "의도적 취약 코드"는 사용자가 명시적으로 고치라고 할 때만 수정합니다. 다른 작업 중 발견해도 그냥 두세요.
- 외부 배포 금지. 로컬 Docker + 가상 데이터·가상 계정 전용입니다.

## 개발 명령

DB가 먼저 떠 있어야 합니다. 앱 기동·테스트 모두 실제 PostgreSQL에 접속합니다.

```bash
docker compose up -d                 # PostgreSQL 16 (board-demo-postgres)
docker compose ps                    # health 확인
./gradlew bootRun                    # http://localhost:8080 (로그인 pmuser / pm1234)
./gradlew test                       # 스모크 테스트 (DB 필요)
./gradlew test --tests '*BoardDemoApplicationTests*'   # 단일 테스트
./gradlew clean build && java -jar build/libs/board-demo.war
```

- 의존성 캐시가 채워져 있으면 `--offline` 사용 가능 (`./gradlew bootRun --offline`).
- DB 직접 조회: `docker exec -it board-demo-postgres psql -U boarduser -d boarddb`
- 상태가 꼬이면 복귀: `git reset --hard step0-baseline`

### 기동할 때마다 DB가 초기화됩니다

`spring.sql.init.mode: always`라서 기동 시 `schema.sql`(DROP TABLE 포함) → `data.sql`이 실행되어 **예제 데이터 35건 상태로 되돌아갑니다**. 입력 데이터를 유지해야 하는 작업이라면 먼저 `never`로 바꾸고, 시연 데이터를 리셋하려면 그냥 재기동하면 됩니다.

## 아키텍처

호출 흐름은 한 방향으로 단순합니다:

```
JSP → Controller → Service(@Transactional) → BoardMapper(인터페이스) → mappers/BoardMapper.xml → PostgreSQL
```

파일 하나만 봐서는 안 보이는 연결 고리들:

- **JSP 뷰 해석** — `war` 패키징 + `tomcat-embed-jasper`로 JSP를 렌더링합니다(그래서 jar가 아닌 war). 컨트롤러가 돌려주는 `"board/list"` 같은 문자열은 `application.yml`의 `spring.mvc.view.prefix/suffix`를 통해 `src/main/webapp/WEB-INF/views/board/list.jsp`로 해석됩니다. 뷰 파일은 `src/main/resources`가 아니라 **`src/main/webapp`** 아래에 있습니다.
- **SQL의 위치** — 매퍼 인터페이스(`mapper/BoardMapper.java`)에는 SQL이 없습니다. 실제 SQL은 전부 `src/main/resources/mappers/BoardMapper.xml`에 있고, `mybatis.mapper-locations`로 연결됩니다. 쿼리를 바꾸려면 **두 파일을 같이** 봐야 합니다.
- **`resultType="Board"`** — `mybatis.type-aliases-package: com.example.board.domain` 덕분에 축약형이 동작합니다. `view_count` → `viewCount` 매핑은 `map-underscore-to-camel-case: true`에 의존하므로, 새 컬럼을 추가할 때 별도 resultMap이 필요 없습니다.
- **로그인** — Spring Security가 아닙니다. `WebConfig`가 `LoginInterceptor`를 `/board/**`에 걸고, 세션의 `loginUser` 속성 유무만 확인합니다. 계정은 `application.yml`의 `demo.login.username/password`를 `LoginController`가 `@Value`로 주입받아 문자열 비교합니다. 글 작성자(`writer`)도 세션의 `loginUser`에서 가져옵니다.
- **페이징** — `PageInfo`(domain)가 offset/총 페이지/페이지 블록(5개 단위)을 모두 계산하는 불변 객체입니다. 컨트롤러의 `PAGE_SIZE = 10`이 유일한 크기 설정이고, JSP는 `pageInfo.hasPrev` / `startPage` / `endPage`만 읽습니다. **검색 기능을 추가하려면 목록 쿼리·건수 쿼리·`PageInfo` 생성·JSP 페이징 링크의 쿼리스트링을 모두 함께 고쳐야 합니다.**
- **날짜 표시** — JSP의 `${board.createdAtText}`는 컬럼이 아니라 `Board`의 파생 getter(`yyyy-MM-dd HH:mm` 포맷)입니다.

## 의도적 취약 코드 (교육 자료 — 요청 없이 고치지 말 것)

1. **SQL Injection** — `mappers/BoardMapper.xml`의 `selectByWriterLegacy`가 `WHERE writer = '${writer}'`로 문자열 결합합니다. 진입점은 목록 하단 "작성자 조회" → `/board/writerList?writer=`. 조치 방향은 `#{writer}` 바인딩.
2. **XSS** — `views/board/detail.jsp`가 제목·작성자·내용을 `${board.content}`처럼 이스케이프 없이 출력합니다. 조치 방향은 `<c:out>`. 대비용으로 `list.jsp`와 `writerList.jsp`는 이미 `<c:out>`을 쓰고 있으니 **이 두 파일의 이스케이프를 걷어내지 마세요.**

## 주의사항

- 문서·주석·커밋 메시지·UI 문자열은 한국어입니다. 기존 톤을 따르세요.
- JSP와 응답 인코딩이 UTF-8 강제(`server.servlet.encoding.force: true`)로 맞춰져 있습니다. 한글이 깨지면 이 설정부터 확인하세요.
- `logging.level.com.example.board: DEBUG`라서 MyBatis가 실행 SQL과 파라미터를 콘솔에 찍습니다(세션 1 호출 흐름 설명용). 끄지 마세요.
- 세션 3(Playwright E2E)은 고정 데이터 35건을 전제로 합니다. `data.sql`의 건수·내용을 바꾸면 그 시나리오가 깨집니다.
