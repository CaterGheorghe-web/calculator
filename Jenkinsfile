pipeline {
     agent any
     environment
         {
             VERSION = 'latest'
             PROJECT = 'calculator'
             IMAGE = 'calculator:latest'
             ECRURL = 'http://808995289075.dkr.ecr.eu-west-3.amazonaws.com/calculator'
             ECRCRED = 'ecr:calculator-ecr-credentials'
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
                                    sh("eval \$(aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 808995289075.dkr.ecr.eu-west-3.amazonaws.com/calculator)")
                                    // Push the Docker image to ECR
                                    docker.withRegistry(ECRURL, ECRCRED)
                                    {
                                        docker.image(IMAGE).push()
                                    }
                                }
                            }
                        }


          // stage("Docker login") {
                          //steps {
                               //withCredentials([[$class: 'aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 808995289075.dkr.ecr.eu-west-3.amazonaws.com/calculator', credentialsId: 'ecr.eu-west-3:calculator-ecr-credentials',
                                          //usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                                   // sh "docker login --username $USERNAME --password $PASSWORD"
                              // }
                         // }
                    // }
                    // stage("Docker push") {
                        //sh "docker login -u gheorghecater -p flavius1357"
                       // sh "docker tag calculator:1.0 gheorghecater/calculator:firsttry "
                       // sh "docker push gheorghecater/calculator"
                        //  }
                   //  }
           //stage("Push image") {
        /* Push image using withRegistry. */
                    // docker.withRegistry('aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 808995289075.dkr.ecr.eu-west-3.amazonaws.com/calculator', 'ecr.eu-west-3:calculator-ecr-credentials') {
                    // app.push("${env.BUILD_NUMBER}")
                    // app.push("latest")
                               //  }
                      // }
          //stage("Docker push") {
            // steps    {
                  // sh "docker tag calculator:latest  808995289075.dkr.ecr.eu-west-3.amazonaws.com/calculator:latest"
                  // sh "docker push 808995289075.dkr.ecr.eu-west-3.amazonaws.com/calculator:latest"
                       // }
                   // }

         // stage("Update version") {
              // steps    {
                   // sh "sed  -i 's/{{VERSION}}/${BUILD_TIMESTAMP}/g' calculator.yaml"
                        // }
                //}

         // stage("Deploy to staging") {
              // steps     {
                   // sh "kubectl config use-context staging"
                   // sh "kubectl apply -f hazelcast.yaml"
                   // sh "kubectl apply -f calculator.yaml"
                  //sh " docker run -d --rm -p 8765:8080 --name calculator_1 gheorghecater/calculator_1"
                       //  }
               // }

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


