output "foodway_app_service_url" {
  value = kubernetes_service.foodway_api_service.status[0].load_balancer[0].ingress[0].hostname
}