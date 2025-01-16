#!/bin/bash

BASE_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo $BASE_DIR

# django_barobill 디렉토리 경로 (출발지)
SOURCE_DIR="$BASE_DIR/django_barobill"

# 패키지 디렉토리 경로
PACKAGE_DIR="$BASE_DIR/package"

# package/django_barobill 디렉토리 경로 (목적지)
DEST_DIR="$PACKAGE_DIR/django_barobill"

# 삭제하려는 디렉토리 목록
DIRS_TO_DELETE=("django_barobill.egg-info" "build" "dist")

# 디렉토리 삭제 처리
for DIR in "${DIRS_TO_DELETE[@]}"; do
  if [ -d "$PACKAGE_DIR/$DIR" ]; then
    rm -rf "$PACKAGE_DIR/$DIR"
    echo "$PACKAGE_DIR/$DIR 디렉토리가 삭제되었습니다."
  else
    echo "$PACKAGE_DIR/$DIR 디렉토리가 존재하지 않습니다."
  fi
done


# 목적지 디렉토리 생성 (존재하지 않는 경우)
mkdir -p "$DEST_DIR"

# 모든 파일 및 디렉토리를 복사 (충돌 시 덮어쓰기)
cp -r "$SOURCE_DIR/"* "$DEST_DIR"

echo "모든 파일이 $DEST_DIR 로 복사되었습니다."

cd $PACKAGE_DIR || { echo "package 디렉토리로 이동할 수 없습니다."; exit 1; }

# 가상환경의 Python 실행 경로
PYTHON_VENV="$BASE_DIR/.venv/bin/python"

# setup.py 파일 경로
SETUP_FILE="$PACKAGE_DIR/setup.py"

# 실행 명령어
$PYTHON_VENV $SETUP_FILE sdist bdist_wheel

twine upload "$PACKAGE_DIR/dist/*"