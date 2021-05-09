terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {
    bucket = "ayt-sample-terraform-state"
    region = "ap-northeast-1"
    key = "terraform.tfstate"
    encrypt = true
    aws_dynamodb_table = "terraform_state_lock"
  }


}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

# resource "aws_instance" "app_server" {
#   ami           = "ami-f80e0596"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "ExampleAppServerInstance"
#   }
# }

resource "aws_s3_bucket" "terraform_state" {
  bucket = "ayt-sample-terraform-state"
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "terraform_state_lock"
  read_capacity = 1
  write_capacity = 1
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}