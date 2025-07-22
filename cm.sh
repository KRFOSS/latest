#!/bin/bash

# 우분투/데비안/칼리 미러 소스 변경 스크립트 (ROKFOSS Mirror 용)

# 루트 권한 확인
if [ "$(id -u)" != "0" ]; then
   echo "이 스크립트는 루트 권한으로 실행해야 합니다." 1>&2
   exit 1
fi

# 배포판 타입 확인 (Ubuntu, Debian 또는 Kali)
if grep -q "Ubuntu" /etc/os-release; then
    DISTRO="ubuntu"
    echo "우분투 배포판이 감지되었습니다."
elif grep -q "Kali" /etc/os-release; then
    DISTRO="kali"
    echo "칼리 리눅스 배포판이 감지되었습니다."
else
    DISTRO="debian"
    echo "데비안 배포판이 감지되었습니다."
fi


# 우분투 미러 소스 변경 스크립트 (ROKFOSS Mirror 용)

# 미러 주소 변수 선언 (환경변수 우선, 없으면 기본값)
MIRROR_URL="${MIRROR_URL:-http.krfoss.org}"

# 루트 권한 확인
if [ "$(id -u)" != "0" ]; then
   echo "이 스크립트는 루트 권한으로 실행해야 합니다." 1>&2
   exit 1
fi

# 우분투 배포판 확인
if ! grep -q "Ubuntu" /etc/os-release; then
    echo "이 스크립트는 우분투에서만 동작합니다."
    exit 1
fi

# 배포판 버전 코드네임 확인
CODENAME=$(lsb_release -cs 2>/dev/null || grep -oP 'VERSION_CODENAME=\K\w+' /etc/os-release)
if [ -z "$CODENAME" ]; then
    echo "배포판 버전을 확인할 수 없습니다. 수동으로 확인해주세요."
    exit 1
fi

echo "우분투 버전: $CODENAME을(를) 인식했습니다."

# Ubuntu 24.04(noble) 이상 버전 확인
USE_DEB822_FORMAT=false
if [[ "$CODENAME" == "noble" || "$CODENAME" > "noble" ]]; then
    USE_DEB822_FORMAT=true
    echo "Ubuntu $CODENAME 감지: DEB822 형식 사용"
fi

# 기존 파일 백업 디렉토리 생성
mkdir -p /etc/apt/backup

if [ "$USE_DEB822_FORMAT" = true ]; then
    # DEB822 형식 (ubuntu.sources) 사용
    if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then
        BACKUP_FILE="/etc/apt/backup/ubuntu.sources.bak.$(date +%Y%m%d)"
        cp /etc/apt/sources.list.d/ubuntu.sources "$BACKUP_FILE"
        echo "기존 ubuntu.sources를 $BACKUP_FILE로 백업했습니다."
        # 혹시 있을 수 있는 legacy sources.list도 백업하고 비활성화
        if [ -f /etc/apt/sources.list ]; then
            cp /etc/apt/sources.list /etc/apt/backup/sources.list.bak.$(date +%Y%m%d)
            echo "# 이 파일은 비활성화되었습니다. DEB822 형식이 /etc/apt/sources.list.d/ubuntu.sources에 사용됨" > /etc/apt/sources.list
        fi
    else
        echo "경고: /etc/apt/sources.list.d/ubuntu.sources 파일을 찾을 수 없습니다."
        echo "DEB822 형식으로 새로 생성합니다."
        mkdir -p /etc/apt/sources.list.d
    fi
    # Ubuntu용 DEB822 형식 sources 파일 생성
    cat > /etc/apt/sources.list.d/ubuntu.sources << EOF
Types: deb deb-src
URIs: https://${MIRROR_URL}/ubuntu/
Suites: $CODENAME $CODENAME-updates $CODENAME-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb deb-src
URIs: https://${MIRROR_URL}/ubuntu/
Suites: $CODENAME-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF
    echo "✓ ubuntu.sources 파일이 성공적으로 변경되었습니다."
else
    # 기존 Legacy 형식 사용
    echo "sources.list 파일을 ROKFOSS 미러 주소로 변경합니다..."
    BACKUP_FILE="/etc/apt/backup/sources.list.bak.$(date +%Y%m%d)"
    cp /etc/apt/sources.list "$BACKUP_FILE"
    echo "기존 sources.list를 $BACKUP_FILE로 백업했습니다."
    COMPONENTS="main restricted universe multiverse"
    cat > /etc/apt/sources.list << EOF
# 우분투 메인 저장소
deb https://${MIRROR_URL}/ubuntu $CODENAME $COMPONENTS
deb-src https://${MIRROR_URL}/ubuntu $CODENAME $COMPONENTS

# 업데이트
deb https://${MIRROR_URL}/ubuntu $CODENAME-updates $COMPONENTS
deb-src https://${MIRROR_URL}/ubuntu $CODENAME-updates $COMPONENTS

# 보안 업데이트
deb https://${MIRROR_URL}/ubuntu $CODENAME-security $COMPONENTS
deb-src https://${MIRROR_URL}/ubuntu $CODENAME-security $COMPONENTS

# 백포트
deb https://${MIRROR_URL}/ubuntu $CODENAME-backports $COMPONENTS
deb-src https://${MIRROR_URL}/ubuntu $CODENAME-backports $COMPONENTS
EOF
    echo "✓ sources.list 파일이 성공적으로 변경되었습니다."
fi

# APT 캐시 업데이트
echo "APT 캐시를 업데이트합니다..."
apt update

# 결과 메시지 출력
echo "✅ 모든 우분투 저장소가 ROKFOSS 미러로 성공적으로 변경되었습니다."
echo "✅ 이제 https://${MIRROR_URL} 미러를 통해 패키지를 다운로드합니다."