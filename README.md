# TFC agents on AWS ECS

A Terraform configuration to deploy TFC Agent containers on AWS ECS via FARGATE.

The module will create

* AWS ECS Task definition to launch a TAC Agent container
* AWS CloudWatch group to store the container logs
* AWS Security group to use with the ECS tasks
* AWS ECS Cluster
* AWS ECS Service which launches a number of tasks

## Prerequisites

* Have Terraform version `>= 0.13`
* AWS Provider version `~> 3.8`

## Input Variables

Variables for the modules are placed in `variables.tf` files. Each variable has a description of what it us used for and many have default values provided as well.

The table below contains the input variables available for the root Terraform module. Any variables that do not have a `default` value must be set by the user.

| Variable | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| name_prefix | `string` | `""` | Prefix to be used in the names of the managed resources. |
| common_tags | `map(string)` | `{}` | Tags to attach to the managed resources. |
| vpc_id | `string` | |  The Id of the VPC to use. |
| subnet_ids | `list(string)` | | The Ids of the subnets to use. |
| tfc_agent_count | `number` | `4` | The number of active agents. |
| aws_cloud_watch_settings | `object({awslogs-group=string, awslogs-region=string, awslogs-stream-prefix=string, log-retention-days=number})` | |Object containing the settings for the Cloud Watch group the ECS logs will be sent to. |
| tfc_agent_environment_variables | `map(string)` | | A map of environment variables and their values to set in the launched containers. Must contain TFC_AGENT_TOKEN set to a valid TFC agent pool token. |
| tfc_agent_container_tag | `string` | `"latest"` | The tag of the TFC Agent container to run. |
| tfc_agent_container_memory | `number` | `2048` | The memory allocated for the TFC Agent containers. |
| tfc_agent_assign_public_ip | `bool` | `true` |Whether to assign a public IP to the TFC Agent containers. Note that the agents neet outbound internet access.

## Output

No outputs are currently defined for the module.

## Basic Module use

Bellow is a basic example of using the module

```HCL
module "tfc_agent" {
  source = "github.com/slavrd/terraform-aws-tfc-agent"

  name_prefix = "example-tfc-agents-"
  common_tags = {
    owner     = "example@tfc.agents"
    project   = "example-tfc-agents"
    terraform = "true"
  }

  vpc_id     = "vpc-xxxxxx"
  subnet_ids = ["subnet-xxxx", "subnet-yyyy"]

  tfc_agent_count = 5

  aws_cloud_watch_settings = {
    awslogs-group         = "/ecs/tfc-agents"
    awslogs-region        = "eu-central-1"
    awslogs-stream-prefix = "tfc-agent-"
    log-retention-days    = 30
  }

  tfc_agent_environment_variables = {
    TFC_AGENT_TOKEN     = "REPLACE_WITH_VALID_TFC_AGENT_POOL_TOKEN"
    TFC_AGENT_LOG_LEVEL = "TRACE"
    TFC_AGENT_SINGLE    = "TRUE"
  }

  tfc_agent_container_tag    = "0.1.3"
  tfc_agent_assign_public_ip = true
}
```