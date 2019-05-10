output "url" {
  value = "http://${module.faq_chatbot_alb.lb_dns_name}/slack/events"
}
