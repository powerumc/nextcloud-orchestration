NextCloud Orchestration
=======================

[English](README.md) | [한국어](README.ko.md)

## :one: 개요

이 프로젝트는 [NextCloud](https://github.com/nextcloud) 오픈소스 프로젝트를 이용하여 여러분의 클라우드에 파일 저장소 구축을 도와줍니다. 원하는 만큼 또는 무제한의 저장 공간을 구축할 수 있고 여러 사람들과 파일을 공유할 수 있습니다.

NextCloud 는 가장 강력한 오픈소스 파일 저장소 프로젝트입니다. NextCloud 가 제공하는 기능은 아래와 같습니다. 더 자세한 기능은 [NextCloud 홈페이지](https://nextcloud.com/)를 방문하세요.

- 파일 저장소
- 디바이스와 파일 동기화 (윈도우, 맥, 리눅스, 아이폰, 안드로이드)
- 강력한 파일 암호화
- 외부 파일 저장소 연결
- 채팅
- 간단한 그룹웨어 시스템

## :two: 필수 사항

#### 사전 준비 사항 | [설치 방법](docs/INSTALLATION.ko.md#사전-준비-사항-설치-방법)
- [Git](https://git-scm.com/) | 소스제어 및 버전 관리 도구
- [Terraform](https://www.terraform.io/) | 인프라 환경 관리 도구
- [Ansible](https://www.ansible.com/) 2.7 이상 버전 | IT 자동화 도구
- [Amazon CLI](https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/cli-chap-install.html) | AWS 클라우드 서비스 명령 도구
- 클라우드 서비스 제공자 계정
  - [x] AWS (아마존 웹서비스) 클라우드 | [AWS 가입하기](https://aws.amazon.com/ko/) | [AWS 1년 무료 항목 확인하기](https://aws.amazon.com/ko/free/) | [AWS 간편 월 요금 계산기](https://calculator.s3.amazonaws.com/index.html?lng=ko_KR#/)

## :three: NextCloud 설치하기 | [자세한 설치 방법](docs/INSTALLATION.ko.md#NextCloud-설치하기)

1. Git 으로 이 저장소의 소스코드를 클론 받기
   ```bash
   git clone https://github.com/powerumc/nextcloud-orchestration
   ```
2. Terraform 실행
   ```bash
   cd terraform/aws
   source terraform-apply.sh
   ```
3. Ansible 실행
   ```bash
   cd ansible
   . ./ansible-run.sh
   ```
4. https 를 사용하는 경우 버그 수정 패치
   ```bash
   cd ansible
   . ./ansible-nextcloud-config.sh
   ```

## :four: 참여하기

- 오류나 버그가 있다면 알려주세요 | [이슈 등록하기](https://github.com/powerumc/nextcloud-orchestration/issues)
- 코드를 개선해 주세요 | [개선하기](https://github.com/powerumc/nextcloud-orchestration/pulls)

## :five: 라이선스

MIT License  
A short and simple permissive license with conditions only requiring preservation of copyright and license notices. Licensed works, modifications, and larger works may be distributed under different terms and without source code.

https://github.com/nextcloud  
GNU Affero General Public License v3.0  
Permissions of this strongest copyleft license are conditioned on making available complete source code of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights. When a modified version is used to provide a service over a network, the complete source code of the modified version must be made available.