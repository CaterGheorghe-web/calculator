pipeline {
     agent any
     triggers {
          pollSCM('* * * * *')
          }
     stages {
          stage("Compile") {
               steps {
                    sh "./gradlew compileJava"
                     }
           }
          stage("Unit test") {
               steps {
                    sh "./gradlew test"
                      }
                }
          stage("Code coverage") {
               steps {
                   sh "./gradlew jacocoTestReport"
                   sh "./gradlew jacocoTestCoverageVerification"
                     }
                }
          stage("Static code analysis") {
              steps  {
                    sh "./gradlew checkstyleMain"
                     }
               }
          stage("Package") {
               steps {
                    sh "./gradlew build"
                     }
                }

          stage("Docker build") {
               steps    {
                    sh "docker build -t calculator:${BUILD_TIMESTAMP} ."
                        }
                }

           stage("Docker login") {
                steps    {
                   withCredentials([[$class: 'aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 808995289075.dkr.ecr.eu-west-3.amazonaws.com/calculator', credentialsId: 'calculator-ecr-credentials',
                               usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                       sh "docker login --username $USERNAME --password $PASSWORD"
                       // sh "docker login --username gheorghecater --password flavius1357"
                         }
                   }
                }
           //stage("Push image") {
        /* Push image using withRegistry. */
                    // docker.withRegistry('aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 808995289075.dkr.ecr.eu-west-3.amazonaws.com/calculator', 'ecr.eu-west-3:calculator-ecr-credentials') {
                    // app.push("${env.BUILD_NUMBER}")
                    // app.push("latest")
                               //  }
                      // }
          stage("Docker push") {
              steps    {
                    sh "docker tag calculator:latest 808995289075.dkr.ecr.eu-west-3.amazonaws.com/calculator:latest"
                    sh "docker push 808995289075.dkr.ecr.eu-west-3.amazonaws.com/calculator:latest"
                        }
                    }

          stage("Update version") {
               steps    {
                    sh "sed  -i 's/{{VERSION}}/${BUILD_TIMESTAMP}/g' calculator.yaml"
                         }
                }

          stage("Deploy to staging") {
               steps     {
                    sh "kubectl config use-context staging"
                    sh "kubectl apply -f hazelcast.yaml"
                    sh "kubectl apply -f calculator.yaml"
                  //sh " docker run -d --rm -p 8765:8080 --name calculator_1 gheorghecater/calculator_1"
                         }
                }

          stage("Acceptance test") {
               steps    {
                    sleep 60
                    sh "chmod +x acceptance-test.sh && ./acceptance-test.sh"
                        }
               }

          stage("Release") {
               steps    {
                    sh "kubectl config use-context production"
                    sh "kubectl apply -f hazelcast.yaml"
                    sh "kubectl apply -f calculator.yaml"
                        }
                }
          stage("Smoke test") {
              steps    {
                  sleep 60
                  sh "chmod +x smoke-test.sh && ./smoke-test.sh"
                      }
              }
           }
     }


