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

