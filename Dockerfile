FROM python:3.12-slim

WORKDIR /app

# 필수 패키지 설치 + Node.js 20 + dos2unix
RUN apt-get update && apt-get install -y \
    bash \
    curl gnupg ca-certificates build-essential dos2unix \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Python venv 생성 및 FastAPI 설치
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
    && pip install --no-cache-dir fastapi uvicorn[standard]

# Node.js 의존성 설치 (devDependencies 포함)
COPY package*.json ./
RUN npm install --production=false

# 앱 복사
COPY . .

# CRLF → LF 변환 (node_modules 포함)
RUN find node_modules -type f -name "*.js" -exec dos2unix {} +

# 포트 오픈 (React dev + FastAPI bridge)
EXPOSE 9012 9013 9014

# entrypoint.sh 복사 + 실행 권한
COPY entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
