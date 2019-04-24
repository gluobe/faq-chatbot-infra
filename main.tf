terraform {
  required_version = "> 0.9.0"
}

# ----------------------------------------------------------------------------------------------------------------------
#                                                          AWS
# ----------------------------------------------------------------------------------------------------------------------
provider "aws" {
  region = "${var.region}"
}

# ----------------------------------------------------------------------------------------------------------------------
# Repositories ecr and S3
# ----------------------------------------------------------------------------------------------------------------------
module "repos" {
  source = "./repositories"

  name = "faq-chat"
  project_naam = "${var.project_naam}"

}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE THE vpc
# ----------------------------------------------------------------------------------------------------------------------
module "vpc_faq_chatbot" {
  source = "./network"
  project_naam = "${var.project_naam}"

}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE THE security group
# ----------------------------------------------------------------------------------------------------------------------
module "security_group" {
  source = "/security"

  name = "faq-chatbot"
  vpc_id = "${module.vpc_faq_chatbot.vpc_id}"
  project_naam = "${var.project_naam}"

}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE THE codebuild project
# ----------------------------------------------------------------------------------------------------------------------
module "build_project_faq_chatbot" {
  source = "./codebuild"

  name = "faq-chatbot-build-project"
  bucket_location = "${module.repos.s3_bucket_location}"
  project_naam = "${var.project_naam}"


}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE elb
# ----------------------------------------------------------------------------------------------------------------------
module "faq_chatbot_alb" {
  source = "./alb"
  subnet_ids        = ["${module.vpc_faq_chatbot.pbl_subnet_a_id}", "${module.vpc_faq_chatbot.pbl_subnet_b_id}"]
  name              = "faq-chatbot-elb"
  vpc_id            = "${module.vpc_faq_chatbot.vpc_id}"
  health_check_path = "/health"
  sg_id = "${module.security_group.sg_id}"
  port = 3000

  project_naam = "${var.project_naam}"
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE THE ECS CLUSTER
# ----------------------------------------------------------------------------------------------------------------------

module "ecs_cluster_faq_chatbot" {
  source = "./ecs-cluster"

  name          = "faq-chatbot"
  max_size      = 6
  min_size      = 1
  instance_type = "t2.micro"
  vpc_id        = "${module.vpc_faq_chatbot.vpc_id}"

  subnet_ids = [
    "${module.vpc_faq_chatbot.prv_subnet_a_id}",
    "${module.vpc_faq_chatbot.prv_subnet_b_id}"
  ]
  sg_id = "${module.security_group.sg_id}"
  project_naam = "${var.project_naam}"

}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE ecs service en task definition
# ----------------------------------------------------------------------------------------------------------------------
module "faq_chatbot_service" {
  source = "./ecs-service"

  name           = "faq_chatbot"
  ecs_cluster_id = "${module.ecs_cluster_faq_chatbot.ecs_cluster_id}"
  image         = "${module.repos.ecr_url}"
  image_version = "latest"
  cpu           = 256
  memory        = 512
  desired_count = 1
  elb_tg_arn     = "${module.faq_chatbot_alb.target_group_arn}"
  deployment_controller = "ECS"
  requires_compatibilities = "EC2"
  container_name           = "faq_chatbot"
  containerPort            = 3000
  hostPort = 3000
  network_mode = "bridge"
  project_naam = "${var.project_naam}"
  launch_type = "EC2"
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE THE Codepipeline
# ----------------------------------------------------------------------------------------------------------------------
module "Faq_codePipeline" {
  source = "./pipeline"

  name = "faq-chatbot"
  build_project_name = "${module.build_project_faq_chatbot.project_name}"
  ClusterName = "${module.ecs_cluster_faq_chatbot.cluster_name}"
  ServiceName = "${module.faq_chatbot_service.service_name}"
  project_id = "${module.build_project_faq_chatbot.project_id}"

  bucket = "${module.repos.s3_bucket_location}"
  bucket_arn = "${module.repos.s3_bucket_arn}"

  project_naam = "${var.project_naam}"
}

