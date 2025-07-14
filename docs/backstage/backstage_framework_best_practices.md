# Framework팀을 위한 Backstage 활용 가이드

## 목차
1. [참조 현황 시각화/검색](#참조-현황-시각화검색)
2. [릴리즈 영향도 리포트/알림](#릴리즈-영향도-리포트알림)
3. [API 문서/가이드 통합](#api-문서가이드-통합)
4. [S3 메타데이터 기반 자동화](#s3-메타데이터-기반-자동화)
5. [PR 기반 메타데이터 자동 갱신](#pr-기반-메타데이터-자동-갱신)
6. [대규모 Lambda 함수 관리](#대규모-lambda-함수-관리)
7. [요약 표](#요약-표)
8. [부록: 참고자료 및 실무 팁](#부록-참고자료-및-실무-팁)

---

## 1️⃣ 참조 현황 시각화/검색

### 의미/효과
- 공통 모듈(Framework, 라이브러리, 패키지)이 **어떤 서비스/팀/레포에서, 어떤 버전/어떤 API/클래스/함수로, 어떻게 쓰이고 있는지** 한눈에 대시보드로 확인
- 신규 기능/버그 대응/Deprecated 정책/성능 개선 시 **실제 영향 범위, 사용 패턴, 팀별 의존성**을 즉시 파악할 수 있음

### 구현 방식
- 각 repo에서 `deps-report.json`(의존성/사용 API 자동화) 생성  
  - 예: 서비스명, 사용중인 공통모듈/버전, 사용하는 주요 API/클래스/함수, 담당자 등
- Backstage의 Software Catalog + Dependency 플러그인 연동  
  - 각 서비스/모듈의 `catalog-info.yaml`에 공통모듈 사용 정보(버전 등) 등록
  - 자동화 스크립트로 Backstage에 데이터 반영
- 대시보드/검색 UI  
  - 공통모듈 별로, 사용 중인 서비스/팀/API/버전 필터/검색
  - "이 API/클래스/함수, 이 버전"을 실제로 쓰는 팀 리스트
  - 최신/구버전/Deprecated 사용 현황·비율을 시각화

### 운영 팁/사례
- 영향도 높은 API(사용처 많음), 위험/구버전 집중 관리
- 신규 기능/정책 Push 시, 실제 사용팀만 골라 타게팅 가능
- 담당자/팀별 의존성 맵으로 커뮤니케이션/지원 효율화

---

## 2️⃣ 릴리즈 영향도 리포트/알림

### 의미/효과
- 공통모듈(Framework) 버전/기능/계약(API, 메소드 등)이 변경될 때 **실제 영향을 받는 서비스/팀/담당자/업무**를 자동 리포트로 생성 & Slack/이메일/PR 코멘트로 알림
- "실제 영향 받는 곳만" 사전 공지/테스트/지원 → 릴리즈 리스크/사고/소통 비용 대폭 감소

### 구현 방식
- 릴리즈/PR/배포 트리거 시, 영향도 자동 리포트 생성 스크립트 실행  
  - (예: deps-report.json 등과 비교하여 변경된 API/클래스/함수와 해당 사용 서비스/팀 매칭)
- Backstage 플러그인 or 자체 스크립트에서 리포트 자동 게시  
  - Markdown, Excel, HTML 등 다양한 포맷
  - 영향 서비스, 사용중 버전, 영향받는 API, 담당자, 영향 상세 내역 표
- Slack, 이메일, PR 코멘트, 사내 포털 등 자동 알림 연동  
  - 실제 영향 받는 팀/담당자만 타겟팅
  - 대규모 조직에서도 소음 없이 효율적 관리

### 운영 팁/사례
- 릴리즈/배포 전 필수 체크리스트로 활용  
- 영향도 리포트 "NO CHANGE" → 안심 배포, "CHANGED" → 사전 커뮤니케이션, 추가 테스트/가이드 배포
- 리포트 이력 관리로 회고/사고 추적/품질 개선

---

## 3️⃣ API 문서/가이드 통합

### 의미/효과
- 각 서비스/공통모듈의 API 명세(Swagger, OpenAPI, gRPC, GraphQL) 문서, 사용 예시, FAQ, 베스트프랙티스, 런북 등 **최신 정보**를 한 곳에서 실시간 자동 집계/검색/공유
- 타팀/신규멤버/외부 파트너도 "최신, 표준, 정확한" API 사용법/가이드 즉시 확인

### 구현 방식
- Swagger/OpenAPI/gRPC 등 문서의 중앙화 & 자동 수집  
  - 각 repo의 문서 파일 등록 (`catalog-info.yaml`에 API 명세 URL 추가)
  - Backstage의 API Catalog 플러그인 & 문서 뷰어 플러그인 활용
  - 자동화 파이프라인으로 최신 문서 동기화
- 가이드/예시/FAQ 통합  
  - 모듈별 사용 가이드, 샘플 코드, 런북(운영 가이드) 문서를 Markdown/ADR/Notion 등으로 자동 수집 & 검색 가능하게 연동
- UI에서 통합 검색/조회  
  - "API별 사용법, Schema, 예시" 즉시 검색
  - Deprecated/변경 API, 최신 업데이트, 릴리즈 노트 등도 한눈에

### 운영 팁/사례
- API 문서 자동화 + 가이드 최신화 → 타팀/프론트/QA/R&D 온보딩 속도↑
- 실제 사용 예시 코드/FAQ/주의사항을 쉽게 문서에 추가, 조직 전체 품질↑
- 문서/코드/운영 정보 싱크 자동화로 "문서 부실/오래된 정보" 문제 해소

---

## 4️⃣ S3 메타데이터 기반 자동화

### 의미/효과
- **비용 효율적** 메타데이터 저장소로 S3 활용, PostgreSQL 대신 JSON 기반 구조화된 데이터 관리
- **확장성** 보장: 1,400개 Lambda + 14개 NestJS 서비스 메타데이터를 저비용으로 저장/관리
- **유연성** 확보: 스키마 변경 시 DB 마이그레이션 없이 JSON 구조만 업데이트

### 구현 방식
- **S3 버킷 구조 설계**
  ```
  s3://backstage-metadata/
  ├── services/
  │   ├── user-service/metadata.json
  │   ├── order-service/metadata.json
  │   └── ...
  ├── lambda/
  │   ├── order-processor/metadata.json
  │   ├── payment-handler/metadata.json
  │   └── ...
  └── core/
      └── framework/metadata.json
  ```

- **메타데이터 표준 스키마**
  ```json
  {
    "service": {
      "name": "user-service",
      "type": "nestjs-service",
      "owner": "backend-team",
      "system": "core-platform"
    },
    "dependencies": {
      "core-framework": "^2.1.0",
      "other-services": ["auth-service", "notification-service"]
    },
    "apis": [
      {
        "name": "user-api",
        "spec": "https://api.internal/user/swagger.json",
        "version": "v1.2.0"
      }
    ],
    "deployment": {
      "type": "ecs-fargate",
      "cluster": "production",
      "last-deployed": "2025-01-15T10:30:00Z"
    }
  }
  ```

- **Backstage 연동 방식**
  - S3 API 기반 Entity Provider 구현
  - 주기적 동기화 (5분마다) 또는 웹훅 기반 실시간 갱신
  - 메타데이터 캐싱으로 성능 최적화

### 운영 팁/사례
- **비용 최적화**: 월 $10-50 저비용으로 대규모 메타데이터 관리
- **백업/복구**: S3 버전 관리로 메타데이터 히스토리 추적
- **권한 관리**: IAM 기반 팀별 메타데이터 접근 제어

---

## 5️⃣ PR 기반 메타데이터 자동 갱신

### 의미/효과
- **개발 워크플로우 자연스러운 통합**: 개발자가 별도 작업 없이 코드 변경 시 메타데이터 자동 갱신
- **실시간 정확성**: PR 단위로 메타데이터 업데이트하여 항상 최신 상태 유지
- **영향도 가시성**: PR 단계에서 Backstage 영향 범위 미리 확인

### 구현 방식
- **GitHub Actions 워크플로우**
  ```yaml
  name: Update Backstage Metadata
  on:
    pull_request:
      paths: ['services/**', 'core/**', 'lambda/**']
  
  jobs:
    update-metadata:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - name: Extract metadata
          run: npm run extract-metadata
        - name: Upload to S3
          run: npm run upload-metadata
        - name: Notify Backstage
          run: curl -X POST "$BACKSTAGE_WEBHOOK_URL"
  ```

- **자동 메타데이터 추출**
  - NestJS: package.json, swagger.json, CODEOWNERS 분석
  - Lambda: handler.ts, serverless.yml, 트리거 정보 추출
  - Core Framework: 의존성 그래프, API 변경사항 추적

- **PR 코멘트 자동화**
  - 메타데이터 변경사항 요약
  - 영향받는 서비스/팀 목록
  - Backstage 링크 및 관련 대시보드

### 운영 팁/사례
- **코드 리뷰 효율성**: PR에서 Backstage 영향도 즉시 확인
- **릴리즈 준비**: 메타데이터 변경사항 기반 릴리즈 체크리스트 자동 생성
- **품질 관리**: 메타데이터 스키마 검증으로 일관성 유지

---

## 6️⃣ 대규모 Lambda 함수 관리

### 의미/효과
- **1,400개 Lambda 함수** 통합 관리 및 가시성 확보
- **서버리스 거버넌스**: 함수별 소유권, 트리거, 의존성 명확화
- **비용 최적화**: 사용되지 않는 함수 식별 및 리소스 효율화

### 구현 방식
- **Lambda Discovery 자동화**
  ```typescript
  // AWS Lambda API 기반 함수 메타데이터 수집
  const functions = await lambda.listFunctions().promise();
  
  for (const func of functions.Functions) {
    const metadata = {
      name: func.FunctionName,
      runtime: func.Runtime,
      memorySize: func.MemorySize,
      timeout: func.Timeout,
      lastModified: func.LastModified,
      triggers: await getTriggers(func.FunctionName),
      metrics: await getCloudWatchMetrics(func.FunctionName)
    };
    
    await uploadToS3(metadata);
  }
  ```

- **함수 그룹화 및 시스템 매핑**
  ```yaml
  # 화주포탈 Lambda 그룹
  apiVersion: backstage.io/v1alpha1
  kind: System
  metadata:
    name: shipper-portal
  spec:
    owner: shipper-team
    domain: logistics
  ---
  apiVersion: backstage.io/v1alpha1
  kind: Component
  metadata:
    name: order-processor
  spec:
    type: aws-lambda
    system: shipper-portal
    owner: order-team
  ```

- **모니터링 및 알림 통합**
  - CloudWatch 메트릭 연동
  - 에러율, 실행 빈도, 비용 추적
  - 사용되지 않는 함수 자동 탐지

### 운영 팁/사례
- **함수 라이프사이클 관리**: 생성/수정/삭제 시 자동 메타데이터 갱신
- **성능 최적화**: 실행 패턴 분석으로 메모리/타임아웃 최적화 제안
- **보안 관리**: 함수별 IAM 역할 및 VPC 설정 추적

---

## 7️⃣ 요약 표

| 주제 | 의미/효과 | 구현 방법(Backstage 연동) | 운영 팁/사례 |
|------|-----------|---------------------------|-------------|
| 참조 현황 시각화/검색 | 공통모듈 사용팀/버전/API/클래스 한눈에, 영향범위 파악 | deps-report.json, catalog-info.yaml, 플러그인, 대시보드 | 영향높은 API 집중관리, 지원↑ |
| 릴리즈 영향도 리포트/알림 | 실제 영향 서비스/담당자 자동 파악, 사전 알림/사고 방지 | 자동 리포트, Backstage/Slack/PR/이메일 연동 | 릴리즈+품질 체크리스트, 회고 |
| API 문서/가이드 통합 | 최신/표준 API, 가이드, 예시, FAQ 한곳에, 온보딩/지원↑ | API Catalog 플러그인, 문서 자동화, 가이드/FAQ 통합 | 문서 최신화, 사용예시/FAQ 확산 |
| **S3 메타데이터 기반 자동화** | **비용 효율적 메타데이터 저장, 확장성/유연성 확보** | **S3 JSON 구조, Entity Provider, 주기적 동기화** | **월 $10-50 저비용, 백업/복구 자동화** |
| **PR 기반 메타데이터 자동 갱신** | **개발 워크플로우 자연스러운 통합, 실시간 정확성** | **GitHub Actions, 자동 추출/업로드, PR 코멘트** | **코드 리뷰 효율성, 릴리즈 준비 자동화** |
| **대규모 Lambda 함수 관리** | **1,400개 함수 통합 관리, 서버리스 거버넌스** | **Lambda Discovery, 함수 그룹화, 모니터링 통합** | **라이프사이클 관리, 성능/보안 최적화** |

---

## 8️⃣ 부록: 참고자료 및 실무 팁

### 공식 문서 및 사례
- [Backstage 공식 문서](https://backstage.io/docs/)
- [공식 adopters 사례](https://backstage.io/adopters/)
- [Software Catalog란?](https://backstage.io/docs/features/software-catalog/overview)
- [API Docs 플러그인](https://backstage.io/docs/features/software-catalog/descriptor-format#apidefinitions)
- [Dependency Graph 플러그인(서드파티)](https://github.com/RoadieHQ/backstage-plugin-graph)
- [실서비스 적용 사례(Spotify, Netflix 등)](https://backstage.io/adopters/)

### 신규 추가 자료
- [S3 Entity Provider 구현 가이드](https://backstage.io/docs/features/software-catalog/external-integrations)
- [AWS Lambda 모니터링 Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)
- [GitHub Actions Backstage 연동 사례](https://github.com/backstage/backstage/tree/master/plugins/github-actions)

### 실무 경험 공유
- 의존성/참조현황 자동화는 CI에서 deps-report.json 생성 → S3로 업로드, Backstage 주기적 수집 추천
- 릴리즈 영향도 리포트는 "실제 영향 받는 팀만" 타겟팅, Slack/이메일/PR 코멘트 자동화로 커뮤니케이션 효율↑
- 문서/가이드/FAQ/런북은 Markdown/Notion/Swagger 기반으로 자동화 파이프라인 구축 추천
- **S3 메타데이터는 JSON 스키마 버전 관리로 하위 호환성 유지**
- **PR 기반 업데이트는 배치 처리로 성능 최적화 (여러 변경사항 한번에 처리)**
- **Lambda 함수는 태그 기반 그룹화로 관리 효율성 극대화**

### 구현 로드맵
1. **Phase 1 (1개월)**: S3 메타데이터 구조 설계 및 기본 Entity Provider 구현
2. **Phase 2 (1개월)**: PR 기반 자동화 워크플로우 구축
3. **Phase 3 (1개월)**: Lambda 함수 Discovery 및 모니터링 통합
4. **Phase 4 (1개월)**: 대시보드 최적화 및 알림 시스템 완성

---

> 추가 구현 예시, 플러그인 활용법, 자동화 스크립트 샘플, 실서비스 적용 경험이 필요하다면 언제든 팀 채널에 문의해 주세요!