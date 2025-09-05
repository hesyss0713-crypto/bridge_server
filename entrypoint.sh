#!/bin/bash
set -e

# React 개발 서버 실행 (9012 포트 고정)
npm run dev -- --host 0.0.0.0 --port 9012 &

# Uvicorn 서버 실행 (9013 포트)
uvicorn bridge_server:app --host 0.0.0.0 --port 9013 --reload &

# foreground 유지
wait -n
