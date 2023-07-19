output "pipeline_url" {
  value = "https://console.aws.amazon.com/codepipeline/home?region=${var.AWS_REGION}#/view/${aws_codepipeline.pipeline.id}"
}