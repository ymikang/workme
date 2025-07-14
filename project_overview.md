# 프로젝트 기술 및 운영 현황 요약

## 🎯 대화 컨텍스트
- **AI 컨설팅 전문가(너)** ↔ **개발 생산성 혁신 리더(나)**
- 목적: 최신, 검증된 AI/DevOps/DevTool/클라우드 기술을 활용해 개발·운영 생산성 극대화
- 조건: 최신 트렌드, 대규모 기업 검증 정보만 활용. 실전 적용 가능성/효율성 최우선.

---

## 🏗️ 기술 스택 및 인프라

### 1. **백엔드**
- **Node.js + NestJS + TypeScript**
- **AWS ECS(Fargate)** 기반 14개 NestJS 모듈 분리 배포
- **공통 Framework(core)**: 사내 공통 라이브러리 형태로 별도 관리/배포
- **아키텍처 표준**
  - **4 Layer 구조**: Controller → Service → Domain → Repository
  - **SOLID 원칙**: 모든 백엔드 서비스는 SOLID 원칙을 준수하도록 표준화

### 2. **프론트엔드**
- **Vue3** 기반, 포탈별로 1개씩 별도 프론트엔드 존재

### 3. **데이터베이스**
- **AuroraDB (PostgreSQL 호환)**

### 4. **배치/비동기 처리**
- **AWS Lambda**: 배치/스케줄러/이벤트 기반 작업 담당

### 5. **특이 시스템: 화주포탈**
- 약 **1,400개 AWS Lambda** 함수로 구성된 대규모 서버리스 구조

### 6. **인프라 관리**
- **Terraform**: 모든 AWS 인프라 리소스 관리 (DB 제외)
  - ECS Fargate 클러스터/서비스
  - Lambda 함수 및 트리거
  - VPC, 보안 그룹, 로드밸런서
  - S3 버킷, IAM 역할/정책
  - CloudWatch 로그 그룹, 알림

---

## 📦 배포 및 구조 요약
- **NestJS 모듈 14개**: ECS Fargate 컨테이너로 개별 배포
- **Core(공통 Framework)**: 사내 라이브러리/패키지로 각 모듈이 참조
- **백엔드 아키텍처**: 4 Layer 구조, SOLID 원칙 준수
- **프론트엔드**: 포탈별 Vue3 SPA 각 1개
- **DB**: AuroraDB(PostgreSQL)
- **배치**: AWS Lambda
- **화주포탈**: 1,400개 Lambda 기반 서버리스
- **인프라**: Terraform 기반 IaC (Infrastructure as Code)

---

> ⚠️ 모든 대화/조언/기술 제안 시 이 파일 내용을 반드시 참조.
> 
> - 반드시 최신, 대규모 조직에서 검증된 기술/사례/도구/플러그인만 추천
> - PoC, 실전 적용, ROI까지 고려
> - "실제 효율/운영/확장성" 관점 우선
> - **Terraform 기반 인프라 관리 원칙 준수**

---