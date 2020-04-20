pipeline {
     agent any
     environment
         {
             VERSION = 'latest'
             PROJECT = 'calculator'
             IMAGE = 'calculator:latest'
             ECRURL = 'http://808995289075.dkr.ecr.eu-west-3.amazonaws.com/calculator'
             ECRCRED = 'ecr:eu-west-3:calculator-ecr-credentials'
         }
     triggers {
          pollSCM('* * * * *')
          }
     stages {
          stage("Compile") {
               steps {
                    sh "./gradlew compileJava"
                     }
           }
         // stage("Unit test") {
              // steps {
                  //  sh "./gradlew test"
                    //  }
               // }
         // stage("Code coverage") {
              // steps {
                  // sh "./gradlew jacocoTestReport"
                  // sh "./gradlew jacocoTestCoverageVerification"
                   //  }
               // }
         // stage("Static code analysis") {
             // steps  {
                  //  sh "./gradlew checkstyleMain"
                   //  }
              // }
          stage("Package") {
               steps {
                    sh "./gradlew build"
                     }
                }

          stage("Docker build") {
               steps    {
                    sh "docker build -t calculator:latest ."
                        }
                }
                stage('Docker push')
                        {
                            steps
                            {
                                script
                                {
                                    // login to ECR - for now it seems that that the ECR Jenkins plugin is not performing the login as expected. I hope it will in the future.
                                    sh("eval \$(aws ecr get-login --no-include-email | sed 's|https://||')")
                                    // Push the Docker image to ECR
                                    docker.withRegistry(ECRURL, ECRCRED)
                                    {
                                        docker.image(IMAGE).push()
                                    }
                                }
                            }
                        }


         stage("Update version") {
               steps    {
                    sh "sed  -i 's/{{VERSION}}/g' calculator.yaml"
                        }
                }

         stage("Deploy to staging") {
               steps     {
                    sh "kubectl config use-context staging"
                    sh "kubectl apply -f hazelcast.yaml"
                    sh "kubectl apply -f calculator.yaml"
                    sh " docker run -d --rm -p 8765:8080 --name calculator_1 gheorghecater/calculator_1"
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


