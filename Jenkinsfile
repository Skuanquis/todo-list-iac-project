pipeline {
  agent any

  parameters {
    string(name: 'AWS_REGION', defaultValue: 'us-east-2', description: 'Región de AWS donde se despliega')
  }

  environment {
    TF_IN_AUTOMATION          = 'true'
    TF_VAR_aws_region         = "${params.AWS_REGION}"
    TF_VAR_aws_access_key     = credentials('aws-access-key-id')
    TF_VAR_aws_secret_key     = credentials('aws-secret-access-key')
    TF_VAR_ruta_clave_publica = 'clave.pub'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Pruebas') {
      steps {
        sh '''
        python3 -m venv .venv
        .venv/bin/pip install -r app/requirements.txt
        cd app
        ../.venv/bin/python -m pytest --junitxml=resultados.xml
        '''
      }
      post {
        always {
          junit 'app/resultados.xml'
        }
      }
    }

    stage('Terraform') {
      steps {
        withCredentials([file(credentialsId: 'tareas-ssh-key', variable: 'CLAVE_SSH')]) {
          dir('terraform') {
            sh '''
            ssh-keygen -y -f "$CLAVE_SSH" > clave.pub
            terraform init -input=false
            terraform validate
            terraform plan -input=false -out=tfplan
            terraform apply -input=false tfplan
            '''
          }
        }
      }
    }

    stage('Inventario') {
      steps {
        dir('terraform') {
          sh '''
          terraform output -raw inventario > ../ansible/inventory
          cat ../ansible/inventory
          '''
        }
      }
    }

    stage('Deploy con Ansible') {
      steps {
        withCredentials([file(credentialsId: 'tareas-ssh-key', variable: 'CLAVE_SSH')]) {
          dir('ansible') {
            sh 'ansible-playbook -i inventory playbook.yml -e "ansible_ssh_private_key_file=$CLAVE_SSH"'
          }
        }
      }
    }

    stage('Verificación') {
      steps {
        sh '''
        URL=$(terraform -chdir=terraform output -raw url_app)
        curl -fsS --retry 5 --retry-delay 3 "$URL/health"
        '''
      }
    }

    stage('Terraform destroy') {
      steps {
        input message: '¿Quieres destruir la infraestructura?'
        dir('terraform') {
          sh 'terraform destroy -input=false -auto-approve'
        }
      }
    }
  }

  post {
    success {
      echo 'Pipeline completado correctamente.'
    }
    failure {
      echo 'Error en el pipeline.'
    }
  }
}
