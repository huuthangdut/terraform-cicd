# VPC; Subnets

module "network" {
  source                    = "../modules/network"
  APP_NAME                  = var.APP_NAME
  ENV                       = var.ENV
  AWS_REGION                = var.AWS_REGION
}

module "storage" {
  source                    = "../modules/storage"
  APP_NAME                  = var.APP_NAME
  ENV                       = var.ENV
}

# IAM; Keys; Security groups

module "security" {
  source          = "../modules/security"
  APP_NAME        = var.APP_NAME
  ENV             = var.ENV
  AWS_REGION      = var.AWS_REGION
  VPC_ID          = module.network.main-vpc-id
  CONTAINER_PORT  = var.ECS_CONTAINER_PORT
  PUBLIC_KEY_PATH = var.PUBLIC_KEY_PATH
}

# Autoscaling groups & load balancer

module "scaling" {
  source                = "../modules/scaling"
  APP_NAME              = var.APP_NAME
  ENV                   = var.ENV
  ECS_AMI_ID            = var.ECS_AMI_ID
  ECS_INSTANCE_TYPE     = var.ECS_INSTANCE_TYPE
  VPC_ID                = module.network.main-vpc-id
  SUBNETS               = module.network.subnet-ids
  ASG_MAX_SIZE          = var.ASG_MAX_SIZE
  ELB_SECURITY_GROUPS   = [module.security.elb-security-group]
  ECS_SECURITY_GROUPS   = [module.security.ecs-security-group-id]
  EC2_INSTANCE_PROFILE  = module.security.ecs-ec2-instance-profile
  ECS_INSTANCE_KEY_NAME = module.security.keypair-name
  ECS_CLUSTER_NAME      = module.ecs-service.ecs-cluster-name
}

# Management

module "management" {
  source                        = "../modules/management"
  APP_NAME                      = var.APP_NAME
  ENV                           = var.ENV
  ALARM_ACTIONS_HIGH_CPU        = [module.scaling.autoscaling-policy-scale-up-arn]
  ALARM_ACTIONS_LOW_CPU         = [module.scaling.autoscaling-policy-scale-down-arn]
  # ALARM_ACTIONS_HIGH_5xx_ERRORS = [module.notifications.sns-topic-arn]
  AUTOSCALING_GROUP_NAME        = module.scaling.ecs-autoscaling-group-name
  ALB_ARN_SUFFIX                = module.scaling.alb-arn-suffix
}

# ECR; ECS & tasks

module "ecs-service" {
  source                            = "../modules/containers"
  APP_NAME                          = var.APP_NAME
  ENV                               = var.ENV
  CONTAINER_PORT                    = var.ECS_CONTAINER_PORT
  ECR_URL                           = var.ECR_URL
  ECS_SERVICE_IAM_ROLE              = module.security.ecs-service-role-arn
  ECS_SERVICE_IAM_POLICY_ATTACHMENT = module.security.ecs-service-attachment
  TARGET_GROUP_ARN                  = module.scaling.target-group-arn
  AWS_REGION                        = var.AWS_REGION
  CLOUDWATCH_LOG_GROUP              = module.management.cloudwatch-log-group-id
  ASG_MAX_SIZE                      = var.ASG_MAX_SIZE
}


module "code-build" {
  source                            = "../modules/codebuild"
  APP_NAME                          = var.APP_NAME
  ENV                               = var.ENV
  AWS_REGION                        = var.AWS_REGION
  SOURCE_REPO_NAME                  = var.SOURCE_REPO_NAME
  SOURCE_REPO_BRANCH                = var.SOURCE_REPO_BRANCH
  ECR_URL                           = var.ECR_URL
  ECR_ARN                           = var.ECR_ARN
  ARTIFACT_BUCKET_ARN               = module.storage.artifact_bucket_arn
}

module "code-pipeline" {
  source                            = "../modules/codepipeline"
  APP_NAME                          = var.APP_NAME
  ENV                               = var.ENV
  AWS_REGION                        = var.AWS_REGION
  SOURCE_REPO_NAME                  = var.SOURCE_REPO_NAME
  SOURCE_REPO_BRANCH                = var.SOURCE_REPO_BRANCH
  ECS_CLUSTER_NAME                  = module.ecs-service.ecs-cluster-name
  ECS_SERVICE_NAME                  = module.ecs-service.ecs-service-name
  ARTIFACT_BUCKET                   = module.storage.artifact_bucket
  ARTIFACT_BUCKET_ARN               = module.storage.artifact_bucket_arn
  CODEBUILD_PROJECT                 = module.code-build.codebuild_id
}