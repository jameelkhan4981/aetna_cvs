provider "aws" {
  region = "us-east-1"
  access_key = "AKIATQPD7DLEUNNPHLWT"
  secret_key = "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"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
/*
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "my-app"
      image = "dockernano/node.js:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1

  network_configuration {
    subnets         = ["subnet-06f194b9966732f6d"]
    security_groups = ["sg-01336129f0e1a2364"]
    assign_public_ip = false
  }
}*/


resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task"
  container_definitions    = jsonencode([
    {
      name      = "my-container",
      image     = "nginx",
      cpu       = 256,
      memory    = 512,
      essential = true,
	  portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-2:241533131465:targetgroup/test-ecs/52d5f55a70ff0d5a"
    container_name   = "my-container"
    container_port   = 80
  }
}

#resource "aws_lb_target_group" "my_target_group" {
#  name     = "test-ecs"
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = "vpc-0ff80fc93116ef50d"
#}

#resource "aws_vpc" "main1" {
#  cidr_block = "10.0.0.0/16"
#}
