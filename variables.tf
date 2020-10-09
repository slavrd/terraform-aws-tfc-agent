# General

variable "name_prefix" {
  description = "Prefix to be used in the names of the managed resources."
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Tags to attach to the managed resources."
  type        = map(string)
  default     = {}
}

# Network

variable "vpc_id" {
  description = "The Id of the VPC to use."
  type        = string
}

variable "subnet_ids" {
  description = "The Ids of the subnets to use."
  type        = list(string)
}

# AWS ECS

variable "tfc_agent_count" {
  description = "The number of active agents."
  type        = number
  default     = 4
  validation {
    condition     = var.tfc_agent_count >= 1 && var.tfc_agent_count <= 8
    error_message = "The tfc_agent_count must be between 1 and 8."
  }
}

variable "aws_cloud_watch_settings" {
  description = "Object containing the settings for the Cloud Watch group the ECS logs will be sent to."
  type = object({
    awslogs-group         = string
    awslogs-region        = string
    awslogs-stream-prefix = string
    log-retention-days    = number
  })
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

variable "tfc_agent_container_memory" {
  description = "The memory allocated for the TFC Agent containers."
  type        = number
  default     = 2048
}

variable "tfc_agent_assign_public_ip" {
  description = "Whether to assign a public IP to the TFC Agent containers. Note that the agents neet outbound internet access."
  type        = bool
  default     = true
}
