provider "aws" {
  region = var.region

  version = "~> 2.54.0"
}

data "aws_eks_cluster_auth" "default" {
  name = aws_eks_cluster.cluster.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.default.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority.0.data)
  load_config_file = false

  version = "~> 1.11.0"
}

provider "helm" {
  kubernetes {
    host     = aws_eks_cluster.cluster.endpoint
    token    = data.aws_eks_cluster_auth.default.token
    cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority.0.data)
  }

  version = "~> 1.1.0"
}

provider "k14sx" {
  kapp {
    kubeconfig_yaml = data.template_file.kubeconfig.rendered
  }
}

locals {
  ytt_lib_dir = "${path.module}/../../../ytt-libs"
}