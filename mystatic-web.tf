resource "aws_s3_bucket" "staticweb" {
  bucket = "my-static-website-123456789" #change name 
  acl    = "public-read"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
  website {
    index_document = var.index
  }

}

resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.staticweb.bucket
  policy = <<EOF
    {
  "Id": "StaticWebPolicy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3GetObjectAllow",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::my-static-website-123456789/*",
      "Principal": "*"
    }
  ]
}
EOF

}



resource "aws_s3_bucket_object" "html" {
  for_each = fileset("/home/mahmoud/iti/terraform/", "**/*.html")

  bucket       = aws_s3_bucket.staticweb.bucket
  key          = each.value
  source       = "/home/mahmoud/iti/terraform/${each.value}"
  etag         = filemd5("/home/mahmoud/iti/terraform/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "css" {
  for_each = fileset("/home/mahmoud/iti/terraform/", "**/*.css") #add file path 

  bucket       = aws_s3_bucket.staticweb.bucket
  key          = each.value
  source       = "/home/mahmoud/iti/terraform/${each.value}"          #add file path 
  etag         = filemd5("/home/mahmoud/iti/terraform/${each.value}") #add file path 
  content_type = "text/css"
}

resource "aws_s3_bucket_object" "js" {
  for_each = fileset("/home/mahmoud/iti/terraform/", "**/*.js") #add file path 

  bucket       = aws_s3_bucket.staticweb.bucket
  key          = each.value
  source       = "/home/mahmoud/iti/terraform/${each.value}"          #add file path 
  etag         = filemd5("/home/mahmoud/iti/terraform/${each.value}") #add file path 
  content_type = "application/javascript"
}


resource "aws_s3_bucket_object" "file" {
  for_each = fileset("/home/mahmoud/iti/terraform/", "**/*.csv") #add file path 

  bucket       = aws_s3_bucket.staticweb.bucket
  key          = each.value
  source       = "/home/mahmoud/iti/terraform/${each.value}"          #add file path 
  etag         = filemd5("/home/mahmoud/iti/terraform/${each.value}") #add file path 
  content_type = "text/csv"
}

#you can add more file  but  every time change content_type 
