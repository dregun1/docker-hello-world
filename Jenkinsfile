
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
      image: 'docker',
      command: '/bin/bash',
      ttyEnabled: true
    ),
  ],
  volumes: [ 
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), 
  ]
) {
    node('docker-build') {
        def dockerHubCred = credentials('DockerHubCredential') // 생성했던 도커허브 credentials ID 입력.
        def appImage
        
        stage('Checkout'){
            container('git'){
                checkout scm
            }
        }
        
        stage('Build'){
            container('docker'){
                script {
                    appImage = docker.build("mwjang/node-hello-world") // mwjang 부분에 자신의 도커허브 사용자 이름 입력.
                }
            }
        }
        
        stage('Test'){
            container('docker'){
                script {
                     sh 'docker run --rm -t -v /home/jenkins/agent/workspace/test:/workspace mwjang/node-hello-world bash -c "cd /workspace && npm test"'
                }
            }
        }

        stage('Push'){
            container('docker'){
                script {
                    docker.withRegistry('https://registry.hub.docker.com', dockerHubCred){
                        appImage.push("${env.BUILD_NUMBER}")
                        appImage.push("latest")
                    }
                }
            }
        }
    }
    
}
