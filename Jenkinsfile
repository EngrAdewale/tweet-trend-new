pipeline {
    agent {
        label 'maven'
    }

   environment {
    PATH = "/opt/apache-maven-3.9.5/bin:$PATH"
}
    stages {
        stage("build"){
            steps {
                 echo "----------- build started ----------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                 echo "----------- build completed ----------"
            }
        }
    stage('SonarQube analysis') {
    environment {
      scannerHome = tool 'Adewale-sonar-scanner'
    }
    steps{
    withSonarQubeEnv('Adewale-sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
      sh "${scannerHome}/bin/sonar-scanner"
    }
  }
}
    

        // Add more stages for your build and deployment steps here
    }
}
