resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "${var.APP_NAME}-artifact-bucket-2-${var.ENV}"

  tags = {
    Name = "${var.APP_NAME}-artifact-bucket-${var.ENV}"
  }
}
