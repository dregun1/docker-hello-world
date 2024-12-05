FROM node

# 애플리케이션 파일을 /app 디렉토리에 복사
WORKDIR /app

# package.json과 package-lock.json 파일 먼저 복사
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

# 의존성 설치
RUN npm install

# 나머지 애플리케이션 파일 복사
COPY . .

# 애플리케이션 실행 포트 노출
EXPOSE 8080

# 애플리케이션 시작 명령
CMD ["npm", "start"]
