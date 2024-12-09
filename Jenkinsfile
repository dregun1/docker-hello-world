
podTemplate(label: 'docker-build', 
  containers: [
    containerTemplate(
      name: 'argo',
      image: 'argoproj/argo-cd-ci-builder:latest',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'docker',
      image: 'docker',
      command: 'cat',
      ttyEnabled: true
    ),
  ],
  volumes: [ 
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), 
  ]
) {
    node('docker-build') {
        def dockerHubCred = 'DockerHubCredentail'// 생성했던 도커허브 credentials ID 입력.
        def appImage
        
        stage('Checkout'){
            container('argo'){
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
        stage('Deploy'){
            container('argo'){
                checkout([$class: 'GitSCM',
                        branches: [[name: '*/main' ]],
                        extensions: scm.extensions,
                        userRemoteConfigs: [[
                            url: 'git@github.com:dregun1/docker-hello-world-deployment.git',
                            credentialsId: 'dregun1',
                        ]]
                ])
                sshagent(credentials: ['dregun1']){
                    sh("""
                        #!/usr/bin/env bash
                        set +x
                        export GIT_SSH_COMMAND="ssh -oStrictHostKeyChecking=no"
                        git config --global user.email "dregun1@naver.com"
                        git checkout main
                        cd env/dev && kustomize edit set image mwjang/node-hello-world:${BUILD_NUMBER}
                        git commit -a -m "updated the image tag"
                        git push
                    """)
                }
            }
        }


      
    }
    
}
