terraform {
  required_version = "> 0.9.0"
}

# ---------------------------------------------------------------------------------------------------------------------
#                                                          AWS
# ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  region = "${var.region}"
}
# ---------------------------------------------------------------------------------------------------------------------
# Repositories ecr and S3
# ---------------------------------------------------------------------------------------------------------------------
module "repos" {
  source = "./repositories"

  name = "faq-chat"
}
# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE vpc
# ---------------------------------------------------------------------------------------------------------------------
module "vpc_faq_chatbot" {
  source = "./network"
}
# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE security group
# ---------------------------------------------------------------------------------------------------------------------

module "security_group" {
  source = "/security"

  name = "faq-chatbot"
  project_naam = "faq-chatbot"
  vpc_id = "${module.vpc_faq_chatbot.vpc_id}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE codebuild project
# ---------------------------------------------------------------------------------------------------------------------
module "build_project_faq_chatbot" {
  source = "./codebuild"

  name = "faq-chatbot-build-project"
  bucket_location = "${module.repos.s3_bucket_location}"

}

/*

# ---------------------------------------------------------------------------------------------------------------------
# CREATE elb
# ---------------------------------------------------------------------------------------------------------------------
module "faq_chatbot_elb" {
  source = "./alb"

  subnet_ids        = ["${module.vpc_faq_chatbot.pbl_subnet_a_id}", "${module.vpc_faq_chatbot.pbl_subnet_b_id}"]
  name              = "faq-chatbot-elb"
  vpc_id            = "${module.vpc_faq_chatbot.vpc_id}"
  health_check_path = "/slack/events"
  sg_id = "${module.security_group.sg_id}"
}
# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE task definition
# ---------------------------------------------------------------------------------------------------------------------
module "task_faq_chatbot" {
  source = "./task-def"

  name                     = "faq_chatbot1"
  requires_compatibilities = "EC2"
  container_name           = "faq_chatbot"
  image                    = "${module.repos.ecr_url}"
  containerPort            = 3000
  hostPort = 3000
  network_mode = "bridge"
}
# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ECS CLUSTER
# ---------------------------------------------------------------------------------------------------------------------
module "ecs_cluster_faq_chatbot" {
  source = "./ecs-cluster"

  name          = "faq-chatbot1"
  max_size      = 6
  min_size      = 1
  instance_type = "t2.micro"
  vpc_id        = "${module.vpc_faq_chatbot.vpc_id}"

  subnet_ids = [
    "${module.vpc_faq_chatbot.pbl_subnet_a_id}",
    "${module.vpc_faq_chatbot.pbl_subnet_b_id}",
    "${module.vpc_faq_chatbot.prv_subnet_a_id}",
    "${module.vpc_faq_chatbot.prv_subnet_b_id}",
  ]
  sg_id = "${module.security_group.sg_id}"
}
# ---------------------------------------------------------------------------------------------------------------------
# CREATE ecs service
# ---------------------------------------------------------------------------------------------------------------------

module "faq_chatbot_service" {
  source = "./ecs-service"

  name           = "faq_chatbot"
  ecs_cluster_id = "${module.ecs_cluster_faq_chatbot.ecs_cluster_id}"

  image         = "${module.repos.ecr_url}"
  image_version = "latest"
  cpu           = 256
  memory        = 512
  desired_count = 1

  container_port = "3000"
  host_port      = "3000"
  elb_tg_arn     = "${module.faq_chatbot_elb.target_group1_arn}"

  task_def_arn          = "${module.task_faq_chatbot.task_def_arn}"
  deployment_controller = "CODE_DEPLOY"
}
/*
# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE Deployment app and deployment group
# ---------------------------------------------------------------------------------------------------------------------
module "faq_codedeploy" {
  source = "./deployment"

  name               = "faq-chatbot"
  deployment_option  = "WITH_TRAFFIC_CONTROL"
  deployment_type    = "BLUE_GREEN"
  cluster_name       = "${module.ecs_cluster_faq_chatbot.cluster_name}"
  service_name       = "${module.faq_chatbot_service.service_name}"
  listener_arns      = "${module.faq_chatbot_elb.listners_arns1}"
  target_group_name1 = "${module.faq_chatbot_elb.target_group1_name}"
  target_group_name2 = "${module.faq_chatbot_elb.target_group2_name}"
  compute_platform   = "ECS"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE Codepipeline
# ---------------------------------------------------------------------------------------------------------------------
module "Faq_codePipeline" {
  source = "./pipeline"

  name = "faq-chatbot"
  build_project_name = "${module.build_project_faq_chatbot.project_name}"
  ClusterName = "${module.ecs_cluster_faq_chatbot.cluster_name}"
  ServiceName = "${module.faq_chatbot_service.service_name}"
  project_id = "${module.build_project_faq_chatbot.project_id}"

  bucket = "${module.repos.s3_bucket_location}"
  bucket_arn = "${module.repos.s3_bucket_arn}"
}


#------------------------------------------------test-------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
# CREATE THE task definition fargate
# ----------------------------------------------------------------------------------------------------------------------
/*
module "task_faq_chatbot_fargate" {
  source = "./task-def"

  name                     = "faq_chatbot_fargate"
  requires_compatibilities = "FARGATE"
  container_name           = "faq_chatbot"
  image                    = "292242131230.dkr.ecr.eu-west-2.amazonaws.com/faq_chat:latest"
  containerPort            = 80
  network_mode             = "awsvpc"
}
*/

