# resource "aws_s3_bucket" "site" {
#   bucket = var.domain_name
# }

resource "aws_s3_bucket" "site" {
  bucket = "${var.domain_name}"
}

resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.site.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://*.${var.domain_name}",
                        "https://${var.domain_name}",
                        "http://localhost:8080"]
    expose_headers  = []
  }
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.site.id
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.site.id

  block_public_acls   = false
  block_public_policy = false
}

# Pre-CDN public bucket

# data "template_file" "s3_public_read_object" {
#   template = "${file("${path.module}/policies/s3_policy.json.tpl")}"
#   vars = {
#     bucket = aws_s3_bucket.site.bucket
#   }
# }

# resource "aws_s3_bucket_policy" "s3_public_read_object" {
#   bucket = aws_s3_bucket.site.id
#   policy = data.template_file.s3_public_read_object.rendered
# }

data "template_file" "s3_public_read_object" {
  template = "${file("${path.module}/policies/s3_cf_policy.json.tpl")}"
  vars = {
    bucket = aws_s3_bucket.site.bucket
    oai_arn = aws_cloudfront_origin_access_identity.OAI.iam_arn
  }
}

resource "aws_s3_bucket_policy" "s3_public_read_object" {
  bucket  = aws_s3_bucket.site.id
  policy  = data.template_file.s3_public_read_object.rendered
}

resource "aws_s3_bucket_website_configuration" "config" {
  bucket = aws_s3_bucket.site.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "src" {
  for_each = fileset("../app/build/", "**")
  bucket = aws_s3_bucket.site.bucket
  key = each.value
  source = "../app/build/${each.value}"
  content_type = length(regexall(".*css", each.value)) > 0 ? "text/css" : "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../app/build/${each.value}")
}