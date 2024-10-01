##Providers
provider "aws" {
  region = var.aws_default_region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

##DataSources
# Obter informações do cluster EKS
data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "auth" {
  name = data.aws_eks_cluster.cluster.name
}

# Referenciando a VPC existente
data "aws_vpc" "eks_vpc" {
  filter {
    name   = "tag:Name"
    values = ["Base VPC"]  
  }
}

# Referenciando as sub-redes existentes
data "aws_subnet" "private_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["PrivateSubnet1"]   #criado no infra
  }
}

data "aws_subnet" "private_subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["PrivateSubnet2"]  #criado no infra
  }
}



#K8s Deploy
resource "kubernetes_deployment" "foodway_api" {
  metadata {
    name      = "foodway-api"
    namespace = "default"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "foodway-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "foodway-api"
        }
      }

      spec {
        container {
          name  = "foodway-api"
          image = var.foodway_api_image  # Imagem da API que está como variável

          port {
            container_port = 80
          }

          env {
            name  = "DB_CONNECTION_STRING"
            value = "Host=foodway-postegres-instance.cpacesu4acyh.us-east-1.rds.amazonaws.com;Port=5432;Database=foodway;User Id=${var.foodway_db_user};Password=${var.foodway_db_password};"
          }
        }
      }
    }
  }
}

#K8s Service
resource "kubernetes_service" "foodway_api_service" {
  metadata {
    name      = "foodway-api-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "foodway-api"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
    timeouts {
    create = "60m"
  }
}
