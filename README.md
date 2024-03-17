				                    Terraform CI/CD Pipeline on AWS
Task
	Create an EKS cluster on AWS using Terraform

Process
	VSCode (Terraform code developed by Developer)  ->  GitHub Repository  -> Jenkins CI/CD  ->  Terraform  -> EKS Cluster

Step by Step
	1. Write Terraform code, then push to github.
	2. The github repo will trigger a jenkins pipeline.
	3. Deploy the changes on AWS Cloud platform hence creating an EKS cluster.

In Terraform
	1. Create an EC2 instance.
	2. Deploy jenkins on the EC2 instance
	3. Jenkins triggers a pipeline to create an EKS cluster

1. Make sure you have created an s3 bucket. It will be used as our backend.

---------Before starting the project ---------
1. In the terminal:
		- aws configure    			#get access key and secret key

------- If you create sth, always re-run in terminal ---------
1. terraform fmt
2. terraform init
3. terraform validate
4. terraform plan
5. terraform apply --auto-approve

-----------If you think, you have gone wrong somewhere, in the terminal -----------------------
1. terraform destroy --auto-approve

----------------------------------------

----------Files we use --------------

	1. data.tf - creates data sources and availability zones
 
	2. backend.tf - storage. we'll use s3
 
	3. provider - the cloud platform we using *aws*
 
	4. main.tf - creates resources: VPC, SG (Security Groups) , EC2 instances
 
	5. terraform.tfvars - 
 
	6. variables.tf -
 
	7. jenkins-install.sh - a file that has commands to install jenkins, git, terraform and kubectl on an EC2 instance.

---------------------------------------------

- To access the Jenkins Server, copy the public ipv4 address and add port 8080 in front of it - e.g., 35.153.100.235:8080

- You will be asked password, copy the path given, add to the terminal (sudo cat path-you-copied) after clicking connect, then copy password

---------------------------------------

------- In terminal ---------

1. terraform init
2. terraform fmt
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

