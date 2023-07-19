[
  {
    "essential": true,
    "memory": 256,
    "name": "${APP_NAME}",
    "cpu": 256,
    "image": "${REPOSITORY_URL}:latest",
    "workingDirectory": "/app",
    "portMappings": [
      {
        "containerPort": ${CONTAINER_PORT},
        "hostPort": 0
      }
    ],
    "environment": [
     
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${CLOUDWATCH_LOG_GROUP}",
        "awslogs-region": "${AWS_REGION}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]