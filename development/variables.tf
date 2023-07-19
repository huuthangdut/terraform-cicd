variable "AWS_ACCESS_KEY" {
  default = ""
}

variable "AWS_SECRET_KEY" {
  default = ""
}


variable "AWS_REGION" {
  default = "us-east-1"
}

variable "APP_NAME" {
  default = "app"
}

variable "ENV" {
  default = "dev"
}

variable "ECS_AMI_ID" {
  default = "ami-0a8f0cfd4100d96e8"
}

variable "ECS_INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "ECR_URL" {
  default = "207061669504.dkr.ecr.us-east-1.amazonaws.com/app-ecr-repository-dev"
}

variable "ECR_ARN" {
  default = "arn:aws:ecr:us-east-1:207061669504:repository/app-ecr-repository-dev"
}

variable "ECS_CONTAINER_PORT" {
  default = 5000
}

variable "ASG_MAX_SIZE" {
  default = 1
}

variable "PUBLIC_KEY_PATH" {
  default = "keypair.pub"
}

variable "SOURCE_REPO_NAME" {
  default = "huuthangdut/simple-app"
}

variable "SOURCE_REPO_BRANCH" {
  default = "main"
}
