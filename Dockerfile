FROM node:10.3.0


WORKDIR /app

COPY package*.json ./
# 의존성 설치
RUN npm install

# 나머지 애플리케이션 파일 복사
COPY . .
# 애플리케이션 실행 포트 노출
EXPOSE 8080

# 애플리케이션 시작 명령
CMD ["npm", "start"]
