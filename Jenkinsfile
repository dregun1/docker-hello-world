
podTemplate(label: 'docker-build',
  containers: [
    containerTemplate(
      name: 'git',
      image: 'alpine/git',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'docker',
      image: 'docker:latest', // 최신 도커 이미지 사용
      command: 'cat',
      ttyEnabled: true,
      envVars: [
        envVar(key: 'HOME', value: '/home/jenkins'), // Jenkins 작업 환경 설정
        envVar(key: 'DOCKER_CONFIG', value: '/home/jenkins/.docker') // 도커 환경 설정 경로
      ]
    )
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
    emptyDirVolume(mountPath: '/home/jenkins/agent/workspace') // 작업 디렉토리 보장
  ]
) {
  node('docker-build') {
    def dockerHubCred = credentials('DockerHubCredential') // DockerHub 자격증명 ID
    def appImage

    stage('Checkout') {
      container('git') {
        checkout scm
      }
    }

    stage('Build') {
      container('docker') {
        script {
          // Build 작업 전 디렉토리 확인 및 생성
          sh 'mkdir -p /home/jenkins/agent/workspace/test'
          sh 'chmod -R 777 /home/jenkins/agent/workspace'
          appImage = docker.build("mwjang/node-hello-world") // 도커 이미지 빌드
        }
      }
    }

    stage('Test') {
      container('docker') {
        script {
          appImage.inside {
            // npm 작업 실행
            sh 'npm install'
            sh 'npm test'
          }
        }
      }
    }

    stage('Push') {
      container('docker') {
        script {
          docker.withRegistry('https://registry.hub.docker.com', dockerHubCred) {
            appImage.push("${env.BUILD_NUMBER}")
            appImage.push("latest")
          }
        }
      }
    }
  }
}
