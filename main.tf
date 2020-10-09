data "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_cluster" "tfc_agent" {
  name               = "${var.name_prefix}tfc-agent"
  capacity_providers = ["FARGATE"]

  tags = var.common_tags
}

resource "aws_ecs_task_definition" "tfc_agent" {
  family = "${var.name_prefix}-tfc-agent"
  container_definitions = templatefile("${path.module}/container-definitions/tfc-agent.json.tmpl", {
    tfc_agent_container_tag    = var.tfc_agent_container_tag
    tfc_agent_container_memory = tostring(var.tfc_agent_container_memory)
    environment_variables      = jsonencode([for k, v in var.tfc_agent_environment_variables : { name = k, value = v }])
    awslogs-group              = var.aws_cloud_watch_settings.awslogs-group
    awslogs-region             = var.aws_cloud_watch_settings.awslogs-region
    awslogs-stream-prefix      = var.aws_cloud_watch_settings.awslogs-stream-prefix
  })
  execution_role_arn       = data.aws_iam_role.ecsTaskExecutionRole.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.tfc_agent_container_memory
  cpu                      = 1024

  tags = var.common_tags
}

resource "aws_cloudwatch_log_group" "tfc_agent" {
  name              = var.aws_cloud_watch_settings.awslogs-group
  retention_in_days = var.aws_cloud_watch_settings.log-retention-days

  tags = var.common_tags
}

resource "aws_security_group" "tfc_agent" {
  name        = "${var.name_prefix}tfc-agent-sg"
  description = "TFC Agent security group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

resource "aws_ecs_service" "tfc_agent" {
  name                               = "${var.name_prefix}tfc-agent-svc"
  launch_type                        = "FARGATE"
  cluster                            = aws_ecs_cluster.tfc_agent.id
  task_definition                    = aws_ecs_task_definition.tfc_agent.arn
  desired_count                      = var.tfc_agent_count
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = var.tfc_agent_count < 2 ? 0 : 50

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.tfc_agent.id]
    assign_public_ip = var.tfc_agent_assign_public_ip
  }

}