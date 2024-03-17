terraform {
    backend "s3" {
        bucket = ""   // give the bucket name, just copy from aws
        key = "jenkins/terraform.tfstate"      // get the key
        region = "us-east-1"
    }
}

