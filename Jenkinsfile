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
              stage('Build preparations')
                      {
                          steps
                          {
                              script
                              {
                                  // calculate GIT lastest commit short-hash
                                  gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                                  shortCommitHash = gitCommitHash.take(7)
                                  // calculate a sample version tag
                                  VERSION = shortCommitHash
                                  // set the build display name
                                  currentBuild.displayName = "#${BUILD_ID}-${VERSION}"
                                  IMAGE = "$PROJECT:$VERSION"
                              }
                          }
                      }

          stage("Docker build") {
               steps    {
               script
                               {
                                   // Build the docker image using a Dockerfile
                                   docker.build("$IMAGE")
                               }
                    //sh "docker build -t calculator:latest ."
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




         stage("Deploy to staging") {
               steps     {
                   // sh "kubectl config use-context staging"
                   // sh "kubectl apply -f hazelcast.yaml"
                   // sh "kubectl apply -f calculator.yaml"
                    sh " docker run -d --rm -p 8765:8080 --name calculator gheorghecater/calculator"
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


