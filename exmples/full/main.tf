module "network" {
  source = "github.com/slavrd/terraform-aws-basic-network?ref=0.4.1"

  vpc_cidr_block       = var.vpc_cidr_block
  common_tags          = var.common_tags
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  name_prefix          = var.name_prefix
}

module "tfc_agent" {
  source = "../../"

  name_prefix                     = var.name_prefix
  common_tags                     = var.common_tags
  vpc_id                          = module.network.vpc_id
  subnet_ids                      = module.network.private_subnet_ids
  tfc_agent_count                 = var.tfc_agent_count
  aws_cloud_watch_settings        = var.aws_cloud_watch_settings
  tfc_agent_environment_variables = var.tfc_agent_environment_variables
  tfc_agent_container_tag         = var.tfc_agent_container_tag
  tfc_agent_assign_public_ip      = false # deploying the agents in subnets with outgoing traffic routed via NAT Gateway.

  depends_on = [
    module.network
  ]
}