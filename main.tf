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
    assign_public_ip = true
  }
}
