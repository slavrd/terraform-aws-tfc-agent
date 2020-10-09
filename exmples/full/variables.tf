# Common

variable "name_prefix" {
  type    = string
  default = ""
}

variable "common_tags" {
  type        = map(string)
  description = "A mapping of tags to be applied to the created resources."
}

# Network

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block to assign to the VPC"
}

variable "public_subnet_cidrs" {
  type = list(object({
    cidr     = string
    az_index = number
  }))
  description = "List of objects reprisenting the public subnets CIDRs and their availability zones. The az_index property is used as an index to retireve a zone from the list of the availability zones for the current AWS region."
}

variable "private_subnet_cidrs" {
  type = list(object({
    cidr     = string
    az_index = number
  }))
  description = "List of objects reprisenting the private subnets CIDRs and their availability zones. The az_index property is used as an index to retireve a zone from the list of the availability zones for the current AWS region."
}

# ECS TFC Agents

variable "aws_cloud_watch_settings" {
  description = "Object containing the settings for the Cloud Watch group the ECS logs will be sent to."
  type = object({
    awslogs-group         = string
    awslogs-region        = string
    awslogs-stream-prefix = string
    log-retention-days    = number
  })
}

variable "tfc_agent_count" {
  description = "The number of active agents."
  type        = number
  default     = 4
  validation {
    condition     = var.tfc_agent_count >= 1 && var.tfc_agent_count <= 8
    error_message = "The tfc_agent_count must be between 1 and 8."
  }
}

variable "tfc_agent_environment_variables" {
  description = "A map of environment variables and their values to set in the launched containers. Must contain TFC_AGENT_TOKEN set to a valid TFC agent pool token."
  type        = map(string)
  validation {
    condition     = contains(keys(var.tfc_agent_environment_variables), "TFC_AGENT_TOKEN")
    error_message = "The tfc_agent_environment_variables map must contain 'TFC_AGENT_TOKEN'."
  }
}

variable "tfc_agent_container_tag" {
  description = "The tag of the TFC Agent container to run."
  type        = string
  default     = "latest"
}