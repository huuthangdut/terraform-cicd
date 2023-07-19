output "artifact_bucket" {
  value = aws_s3_bucket.artifact_bucket.bucket
}

output "artifact_bucket_arn" {
  value = aws_s3_bucket.artifact_bucket.arn
}