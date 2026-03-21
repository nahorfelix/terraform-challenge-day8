module "node_app" {
  source = "../../../../modules/services/node-app-cluster"

  cluster_name  = "node-app-production"
  instance_type = "t3.medium" # Heavier compute for prod
  min_size      = 3
  max_size      = 10
}