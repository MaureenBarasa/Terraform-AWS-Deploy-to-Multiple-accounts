# This Repository is for an Automation Project to deploy resources from an AWS account in another AWS account.

It provides a step by step guide on how to do this. 

The Project will make use of:

- IAM
- Parameter-Store
- CodeCommit
- CodeBuild
- CodePipeline
- S3
- SNS 

1. SET UP CREDENTIALS ON PARAMETER STORE

- Create a user Terraform/Git on the AWS account (DevOps Account) that will host the CodePipeline.
- Generate Access Keys and Secret Keys for the user.
- Store the credentials to Parameter store. I stored mine as; 

    - devops-access-key
    - devops-secret-key

2. CREATE S3 BUCKET FOR TERRAFORM STATE FILES. 

- Create an S3 bucket to be used as terraform backend/store terraform state files. 
- Ensure bucket is not publicly accessible. 

3. SET IAM PERMISSIONS

- Terraform User Permissions: Ensure the Terraform/Git user created in 1 above has the appropriate permissions to use CodePipeline, CodeBuild, S3 bucket. I gave my user admin rights but it is advisable to limit permissions for this user to the specific services the user will access. 

- CrossAccount Permissions: Create the below roles for cross account access. 

On the DevOps account: 

The cross account role should have relevant access permisions, for testing purposes I gave my role admin access. But it is recommended to give limited permissions necessary for the functions the role will perform. 

Edit trust relationships as below:

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::Dev/Prod/Staging Account ID:root",
          "Created CodeBuild Service Role ARN"
        ]
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}


On the Prod/dev/Staging account (where you need to provision resources):

The cross account role should have relevant access permissions, for testing purposes I gave my role admin access. But it is recommended to give limited permissions necessary for the functions the role will perform.

Add an Inline policy for Terraform S3 state bucket access:

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::mybucket"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::************-terraform-st-bckt/*"
        }
    ]
}


Edit trust relationship as below:

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "Created CodeBuild Service Role ARN",
          "arn:aws:iam::DevOps Account ID:root"
        ]
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}

- S3 state Bucket Permissions: Set the below bucket policy on the create S3 terraform state bucket.

{
    "Version": "2012-10-17",
    "Id": "Policy1642707597159",
    "Statement": [
        {
            "Sid": "Stmt1642707591970",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::401392287136:role/service-role/codebuild-Terraform-Test-service-role",
                    "arn:aws:iam::342053932470:role/Cross-Account-Staging"
                ]
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::maureen-terraform-st-bckt"
        }
    ]
}


- CodeBuild Role Permissions: On the DevOps account, create a Role that will be used by the CodeBuild Project. Ensure the role has the following permissions. 

SSM permissions (Can be SSM Read Only access)

add the below 2 inline policies:

The crossaccount assume role policy


{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "role ARN created on the DevOps account for CrossAccount Access to the dev/staging/prod accounts"
    }
}


The terraform state bucket access

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::mybucket"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::**********-terraform-st-bckt/*"
        }
    ]
}


Edit the trust relationship of the role as below:


{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::DevOps Account ID:role/Cross-Account-Dev",
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}




SET IAM PERMISSIONS

CREATE BUILDSPEC FILES

CREATE TERRAFORM FILES

CREATE BUILD PROJECTS

CREATE PIPELINE






