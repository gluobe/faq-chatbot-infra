region = "eu-west-2"
image = ""

cluster_naam = "faq-chatbot-cluster"
as_group_naam = "faq-chatbot-asg"
launch_configuration_naam ="faq-launch-config"
iam_role_naam = "faq-chatbot-role"
iam_instance_profile_naam = "faq-instace-profile"
security_group_naam = "faq-security-group"
max_size = 6
min_size = 1
instance_type = "t2.micro"


service_naam = "faq-chatbot-service"
task_def_naam = "faq-chatbot-task-def"
container_naam = "faq-chatbot"
service_role_naam = "faq-chatbot-service-role"
ecs_cluster_id = "${}"
image = "292242131230.dkr.ecr.eu-west-2.amazonaws.com/faq_chat"
image_version = "latest"
cpu = 9
memory = 500
container_port = 3000
host_port = 80
desired_count = 1
elb_name = ""
elb_naam =""
elb_security_group = ""
vpc_id = ""
subnet_ids = ""
instance_port = ""
health_check_path = ""