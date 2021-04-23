# Introduction

**T#**<sup>T Sharp</sup>은 **It's torr!**와 **torrssen2**, **Transmission**이 통합 설치되어 기본 연동이 설정된 도커 이미지입니다.

# Related Apps

- [**It's torr!**](https://github.com/grollcake-torr/torr)
- [**torrssen2**](https://github.com/tarpha/torrssen2)
- [**Transmission**](https://transmissionbt.com/)

# Usage

```
docker run -d \
  --name=tsharp \
  -p 7780:8080 \
  -v /path/to/config/data:/root/data \
  -v /path/to/download:/download \
  --restart unless-stopped \
  banyazavi/tsharp
```

# Parameters

## Mandatory Parameters

| Parameter | Function |
|-----------|----------|
| -p 8080 | torrssen2 웹 접속 포트 |
| -p 51413 | Transmission 컨트롤 포트 |
| -p 51413/udp | Transmission 컨트롤 포트 (UDP) |
| -v /root/data | torrssen2 DB 및 Transmission 설정 볼륨 |
| -v /download | torrssen2 기본 다운로드 디렉토리 |

## Optional Parameters

| Parameter | Function |
|-----------|----------|
| -e PUID | 실행 유저 ID |
| -e PGID | 실행 그룹 ID |
| -p 80 | It's torr! RSS 접속 포트 |
| -p 9091 | Transmission RPC 접속 포트 |
| -v /www/torr/UserConfig.php | It's torr! 사용자 정의 설정 |
| -v /anywhere/in/container | 추가 다운로드 디렉토리 |

### PUID / PGID

파일은 실행 유저:그룹 소유로 생성됩니다.  
특정 소유로 파일을 내려받아야 한다면 이 환경변수를 변경하세요. (기본값: 0(root):100(users))

### Port 80

이 포트를 외부에 개방한다면 **It's torr!**의 RSS 정보를 `/torr/torr.php` 경로에서 받아볼 수 있습니다.  
다운로드 스테이션 등 외부 서비스에서 이곳의 RSS를 활용하고자 한다면 이 포트를 개방하세요.

### Port 9091

이 포트는 트랜스미션 RPC의 접속 포트입니다.  
외부 도구를 통해 다운로드 상태를 확인하거나 웹 UI를 통해 트랜스미션 옵션을 변경하고 싶을 때, 이 포트를 개방하여 트랜스미션에 접속할 수 있습니다.

이 포트를 개방하여 내장된 트랜스미션을 범용으로 사용할 수도 있으나, **torrssen2**의 다운로드 파일 관리 동작과 충돌할 수 있으므로 권장하지 않습니다.

### -v /www/torr/UserConfig.php

이 포트는 **It's torr!**의 사용자 정의 설정을 바인딩합니다.  
사용자 정의 설정의 사용 방법은 다음을 참조하세요. [/grollcake-torr/torr#업데이트](https://github.com/grollcake-torr/torr#%EC%97%85%EB%8D%B0%EC%9D%B4%ED%8A%B8)

### -v /anywhere/in/container

기본 다운로드 디렉토리 외 사용자가 원하는 디렉토리를 추가로 바인딩하여 사용할 수 있습니다.  
단, 이 경우 추가로 바인딩한 디렉토리를 **torrssen2 > 다운로드 경로 관리** 메뉴에 등록하여야 합니다.

# Advanced Settings

## 사용자 아이디 및 비밀번호 설정

- torrssen2: **환경 설정 > 로그인**에서 설정할 수 있습니다.
- Transmission: **/root/data/settings.json** 파일의 아래 옵션을 수정합니다.  
  **username**와 **password**을 **torrssen2 > 환경 설정 > 트랜스미션**과 같이 수정해야 합니다.

```
    "rpc-authentication-required": true,
    "rpc-username": "your_username",
    "rpc-password": "your_password",
```

# Notice

- 본 이미지는 amd64 이외 아키텍처에서의 동작을 보증하지 않습니다.
- 공개 사이트의 상황에 따라 RSS 제공이 지연, 거부 또는 제공 자체가 불가능할 수 있습니다.
