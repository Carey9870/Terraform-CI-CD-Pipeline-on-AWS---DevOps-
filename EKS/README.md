------- In terminal ---------

1. terraform fmt
2. terraform init
3. terraform validate
4. terraform plan


NOTE: we do not do terraform apply --auto-approve, jenkins will be the one creating the EKS.

On the UI of the Jenkins, create a Jenkins Pipeline to deploy an EKS Cluster

--------------------------------------------
NOTE:
    Jenkins will require you to provide aws access keys and secret keys, because it will make changes to your aws account.

    Under Pipeline, add script:
        pipeline {
            agent key
            environment {
                AWS_ACCESS_KEY_ID = credential('AWS_ACCESS_KEY_ID')
                AWS_SECRET_ACCESS_KEY = credential('AWS_SECRET_ACCESS_KEY')
                AWS_DEFAULT_REGION = "us-east-1"
            }
            stages {
                stage('Checkout SCM') {
                    steps {
                        script {
                            # paste script generated from pipeline syntax.
                        }
                    }
                }
                stage("Initializing Terraform"){
                    steps {
                        script {
                            dir('EKS'){  # EKS folder we created
                                sh 'terraform init'
                            }
                        }
                    }
                }
                stage("Formatting Terraform"){
                    steps {
                        script {
                            dir('EKS'){  # EKS folder we created
                                sh 'terraform fmt'
                            }
                        }
                    }
                }
                stage("Validating Terraform"){
                    steps {
                        script {
                            dir('EKS'){  # EKS folder we created
                                sh 'terraform validate'
                            }
                        }
                    }
                }
                stage("Planning/Reviewing Terraform"){
                    steps {
                        script {
                            dir('EKS'){  # EKS folder we created
                                sh 'terraform plan'
                            }
                            input(message: "Are you sure you want to proceed?" OK: 'Proceed')  # make sure to add a parameter
                        }
                    }
                }
                stage("Creating an EKS Cluster"){
                    steps {
                        script {
                            dir('EKS'){  # EKS folder we created
                                sh 'terraform apply --auto-approve'
                            }
                        }
                    }
                }
                stage("Deploying Nginx Application"){
                    steps {
                        script {
                            dir('EKS/configurationFiles'){  # EKS folder we created
                                sh 'aws eks update-kubeconfig --name my-eks-cluster'
                                sh 'kubectl apply -f deployment.yaml'
                                sh 'kubectl apply -f service.yaml'
                            }
                        }
                    }
                }
            }
        }
    
    - right click pipeline syntax, open in new tab, do everything you need to do, then click generate pipeline script and copy the script generated.

