## 사전 준비 사항

- [Git](https://git-scm.com/) | 소스제어 및 버전 관리 도구
- [Terraform](https://www.terraform.io/) | 인프라 환경 관리 도구
- [Ansible](https://www.ansible.com/) | IT 자동화 도구
- [Amazon CLI](https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/cli-chap-install.html) | AWS 클라우드 서비스 명령 도구

### 사전 준비 사항 설치 방법

- 맥 운영체제에 설치하기
    ```bash
    brew install git awscli ansible terraform
    ```
- 리눅스(우분투) 운영체제에 설치하기
    ```bash
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt update
    sudo apt install git-all awscli ansible unzip

    wget https://releases.hashicorp.com/terraform/0.12.17/terraform_0.12.17_linux_amd64.zip
    unzip terraform_0.12.17_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    ```

### AWS 계정의 엑세스 키 만들기

1. AWS 서비스의 `보안, 자격 증명 및 규정 준수` 의 `IAM` 서비스로 이동합니다.
2. `사용자` -> 사용자 이름 클릭 -> `보안 자격 증명` 으로 이동합니다.
3. `액세스 키` 섹션의 `엑세스 키 만들기` 버튼을 클릭합니다.
4. 화면에 표시되는 `액세스 키 ID`, `비밀 액세스 키` 가 표시됩니다.  
   이 정보는 절대로 외부에 노출되면 안됩니다.

### AWS EC2 키 페어 만들기

1. AWS 서비스의 `컴퓨팅` -> `EC2` 서비스로 이동합니다.
2. `네트워크 및 보안` 의 `키 페어` 메뉴를 클릭합니다.
3. `키 페어 생성` 버튼을 클릭합니다.
4. `키 페어 이름`을 입력한 후 `생성` 버튼을 클릭합니다.
5. 자동으로 다운로드 되는 암호키 파일(`.pem`)을 안전한 위치에 보관합니다.
   이 암호키 파일(`.pem`)은 절대 외부에 노출되면 안됩니다.

### AWS CLI 구성

아래의 명령은 절대 공용 PC 에서 실행하지 마십시오.

```bash
aws configure
```

명령을 입력한 후 AWS 에 엑세스할 수 있는 키와 리전 정보를 입력해야 합니다

```bash
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: 
Default output format [None]:
```

이 정보는 일반적으로 `~/.aws/` 디렉토리에 `credentials`, `config` 파일에 기록됩니다.

## NextCloud 설치하기

### :one: 소스코드 받기

1. Git 저장소의 소스코드를 다운로드 받을 디렉토리 준비
   ```bash
   mkdir -p ~/workspace/github
   cd ~/workspace/github
   ```
2. Git 을 이용하여 저장소를 클론 받기
    ```bash
    git clone https://github.com/powerumc/nextcloud-orchestration
    ```

### :two: 환경 설정 하기
Terraform 관련 파일을 열어 내용을 수정합니다. | [환경 구성으로 가기](#AWS-환경-구성)
   - `terraform/aws/provider.tf`
   - `terraform/aws/variables.tf`

### :three: Terraform 실행하기  
   소스 코드의 루트 디렉토리에서 아래의 명령을 입력하세요.
   ```bash
   cd terraform/aws
   terraform init
   source terraform-apply.sh
   ```
   검토 사항을 확인한 후 클라우드 서비스 제공자에 리소스를 생성하려면 `yes` 를 입력하세요.  
   이 과정이 완료되면 클라우드 서비스에 필요한 리소스들이 모두 생성됩니다.
   
   생성되는 AWS 클라우드 리소스의 목록입니다.
   - [x] AWS (아마존 웹서비스) 클라우드 | [AWS 가입하기](https://aws.amazon.com/ko/) | [AWS 1년 무료 항목 확인하기](https://aws.amazon.com/ko/free/) | [AWS 간편 월 요금 계산기](https://calculator.s3.amazonaws.com/index.html?lng=ko_KR#/)
      - [EC2](https://aws.amazon.com/ko/ec2/)
      - [EBS](https://aws.amazon.com/ko/ebs/)
      - [Route 53](https://aws.amazon.com/ko/route53/)
      - [VPC](https://aws.amazon.com/ko/vpc/)
      - [EIP](https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)
      - [ENI](https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/using-eni.html)
- [ ] Azure (애저) 클라우드
  - 아직 지원 안함

### :three: Ansible 실행하기  
   소스 코드의 루트 디렉토리에서 아래의 명령을 입력하세요.
   ```bash
   cd ansible
   . ./ansible-run.sh
   ```
   이 스크립트를 실행하면 NextCloud 데이터베이스에 사용할 비밀번호를 입력해야 합니다.  
   데이터베이스에 생성되는 'root' 사용자 비밀번호와 'nextcloud' 사용자 비밀번호를 입력합니다.

   여러분의 클라우드 서비스 제공자의 서버에 설치되는 소프트웨어 목록입니다.
   - [Amazon Linux 2](https://aws.amazon.com/ko/about-aws/whats-new/2017/12/introducing-amazon-linux-2/)
   - [Docker](https://www.docker.com/)
   - [Docker Compose](https://docs.docker.com/compose/)
     - [NextCloud](https://nextcloud.com/)
     - [MariaDB](https://mariadb.org/mariadb.org)
     - [Nginx](https://www.nginx.com/)
     - [LetsEncrypt Certbot](https://certbot.eff.org/)

### :four: 관리자 ID 및 비밀번호 생성
웹 브라우저를 실행하여 여러분의 도메인 또는 IP 주소로 접속합니다.

`terraform/aws/variables.tf` 파일에
- 여러분의 도메인을 입력하셨다면 `https://yourdomain.com` 와 같이 웹 브라우저로 접속이 가능하며,  
- 도메인을 입력하지 않았다면 `http://0.0.0.0` 과 같이 서버의 IP 로 접속할 수 있습니다.

이제 여러분의 NextCloud 웹 사이트에 접속이 되시나요?  
그렇다면 웹 브라우저에서 관리자의 ID 및 비밀번호를 입력합니다.

### :five: https 구성을 위해 config.php 파일 업데이트
**만약, 여러분의 도메인이 없다면 이 단계는 무시하세요.**

여러분이 도메인 주소가 있다면 자동으로 https 가 구성되어 접속할 수 있습니다.  
하지만 https 주소로 웹 브라우저 접속은 가능하지만 데스크톱, 모바일 앱에서는 접속이 불가능 합니다.  
데스크톱, 모바일 장치에서 NextCloud 에 접속하기 위해 아래의 명령을 추가로 실행합니다.

소스 코드의 루트 디렉토리에서 아래의 명령을 입력하세요.
```bash
cd ansible
. ./ansible-nextcloud-config.sh
```

## :six: 무제한 저장소가 필요하세요? | [추가 방법](S3-EXTERNAL-STORAGE.ko.md)

이제 데스크톱, 모바일 앱에서도 여러분의 HTTPS 클라우드 주소로 접속이 가능합니다.

## 환경 변수 구성

### AWS 환경 구성

1. 클라우드 서비스 제공자의 리전 변경하기  
    소스코드 경로의 [`terraform/aws/provider.tf`](../terraform/aws/provider.tf) 에 위치합니다.

    `ap-northeast-2` 는 아시아 태평양(서울)을 의미합니다.
    ```terraform
    provider "aws" {
      version = "~>2.41.0"
      region  = "ap-northeast-2"  # 클라우드 서비스 제공자의 리소스가 생성되는 리전
    }
    ```

    리전 목록은 링크를 클릭하여 확인하세요. | [리전 목록 확인하기](https://docs.aws.amazon.com/ko_kr/general/latest/gr/rande.html#apigateway_region)

2. 클라우드 서비스 제공자에 생성될 리소스 변경하기  
    소스코드 경로의 [`terraform/aws/variables.tf`](../terraform/aws/variables.tf) 에 위치합니다.
    ```terraform
    variable "nextcloud" {
      type = object({
        vpc_cidr_block        = string
        subnet_cidr_block     = string
        instance_private_ip   = string
        instance_ami          = string
        instance_key_name     = string
        instance_type         = string
        ebs_db_volumn_type    = string
        ebs_db_volumn_size    = number
        route53_domain        = string
        your_nextcloud_domain = string
        your_email            = string
        ssh_key_file_path     = string
      })
      default = {
        vpc_cidr_block        = "10.10.0.0/16"
        subnet_cidr_block     = "10.10.0.0/24"
        instance_private_ip   = "10.10.0.10"
        instance_ami          = "ami-0d59ddf55cdda6e21"
        instance_key_name     = ""                  # (필수) 암호키 이름 (AWS EC2 키페어 이름)
        instance_type         = "t2.micro"          # (옵션) EC2 인스턴트 크기 설정 https://aws.amazon.com/ko/ec2/instance-types/
        ebs_db_volumn_type    = "gp2"               # (옵션) 데이터베이스 등의 저장소로 사용되는 볼륨 유형 https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/EBSVolumeTypes.html
        ebs_db_volumn_size    = 100                 # (옵션) 볼륨 사이즈 https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/volume_constraints.html
        route53_domain        = ""                  # (옵션) AWS Route 53 도메인 이름, 도메인 이름이 'example.com' 이라면 'example.com.' 을 입력하세요
        your_nextcloud_domain = ""                  # (옵션) AWS Route 53 A 레코드 이름(접속할 도메인 이름), 'example.com' 이라면 'example.com' 을 입력하세요
        your_email            = ""                  # (옵션) 무료 SSL 구성에 필요한 당신의 이메일 주소
        ssh_key_file_path     = ""                  # (필수) AWS EC2 인스턴스에 접속할 키 파일 경로
      }
    }
    ```

    아래는 환경 구성의 예시입니다.

    ```terraform
    variable "nextcloud" {
      type = object({
        vpc_cidr_block        = string
        subnet_cidr_block     = string
        instance_private_ip   = string
        instance_ami          = string
        instance_key_name     = string
        instance_type         = string
        ebs_db_volumn_type    = string
        ebs_db_volumn_size    = number
        route53_domain        = string
        your_nextcloud_domain = string
        your_email            = string
        ssh_key_file_path     = string
      })
      default = {
        vpc_cidr_block        = "10.10.0.0/16"
        subnet_cidr_block     = "10.10.0.0/24"
        instance_private_ip   = "10.10.0.10"
        instance_ami          = "ami-0d59ddf55cdda6e21"
        instance_key_name     = "example-aws"
        instance_type         = "t2.micro"
        ebs_db_volumn_type    = "gp2"
        ebs_db_volumn_size    = 100
        route53_domain        = "example.com."
        your_nextcloud_domain = "cloud.example.com"
        your_email            = "example@example.com"
        ssh_key_file_path     = "/mypath/example-aws.pem"
      }
    }
    ```