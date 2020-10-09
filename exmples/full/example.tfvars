name_prefix = "example-tfc-agents-"
common_tags = {
  owner     = "example@tfc.agents"
  project   = "example-tfc-agents"
  terraform = "true"
}

vpc_cidr_block = "172.30.0.0/16"
public_subnet_cidrs = [{
  cidr     = "172.30.0.0/24"
  az_index = 0
}]
private_subnet_cidrs = [{
  cidr     = "172.30.1.0/24"
  az_index = 0
  },
  {
    cidr     = "172.30.2.0/24"
    az_index = 1
}]

tfc_agent_count         = 5
tfc_agent_container_tag = "0.1.3"
tfc_agent_environment_variables = {
  TFC_AGENT_TOKEN     = "REPLACE_WITH_VALID_TFC_AGENT_POOL_TOKEN"
  TFC_AGENT_LOG_LEVEL = "TRACE"
  TFC_AGENT_SINGLE    = "TRUE"
}

aws_cloud_watch_settings = {
  awslogs-group         = "/ecs/tfc-agents"
  awslogs-region        = "eu-central-1"
  awslogs-stream-prefix = "tfc-agent-"
  log-retention-days    = 30
}