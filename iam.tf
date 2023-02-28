provider "aws" {
   profile ="default"
   region="ap-south-1"
}
resource "aws_iam_user" "s3user" {
  name = "s3user"
}
resource "aws_s3_bucket" "bucket" {
  bucket = "bucket-feb-26"
  acl    = "private"
}
resource "aws_iam_access_key" "lb" {
  user    = aws_iam_user.s3user.name
  
}
resource "aws_iam_user_policy" "lb_ro" {

  name = "test"
  user = aws_iam_user.s3user.name
  policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3-object-lambda:Get*",
                "s3-object-lambda:List*"
            ],
            "Resource": "*"
        }
    ]
    })
}
resource "aws_iam_user_login_profile" "example" {
  user    = aws_iam_user.s3user.name
#   pgp_key = "keybase:some_person_that_exists"
    password_reset_required     = false
}

output "password" {
  value = aws_iam_user_login_profile.example.encrypted_password
}