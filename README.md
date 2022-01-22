```yaml
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

===============================
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
=========================================

On the Prod/dev/Staging account (where you need to provision resources):

The cross account role should have relevant access permissions, for testing purposes I gave my role admin access. But it is recommended to give limited permissions necessary for the functions the role will perform.

Add an Inline policy for Terraform S3 state bucket access:

================================================
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
=====================================================

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
=========================================================

- S3 state Bucket Permissions: Set the below bucket policy on the create S3 terraform state bucket.

======================================================
{
    "Version": "2012-10-17",
    "Id": "Policy1642707597159",
    "Statement": [
        {
            "Sid": "Stmt1642707591970",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "Created CodeBuild Service Role ARN",
                    "Created DevOps Account Cross Account Role ARN"
                ]
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::*****************-terraform-st-bckt"
        }
    ]
}
=======================================================

- CodeBuild Role Permissions: On the DevOps account, create a Role that will be used by the CodeBuild Project. Ensure the role has the following permissions. 

SSM permissions (Can be SSM Read Only access)

add the below 2 inline policies:

The crossaccount assume role policy

============================================
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "role ARN created on the DevOps account for CrossAccount Access to the dev/staging/prod accounts"
    }
}
==============================================

The terraform state bucket access

======================================
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
=========================================

Edit the trust relationship of the role as below:

==========================================
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
============================================


4. CREATE A CODECOMMIT OR GITHUB REPOSITORY

Add the below files to the repository; I have uploaded the files on this repo. 

5. CREATE CODE BUILD PROJECTS USING CODEBUILD

These can be created using CloudFormation or manually on the console.

Ensure the build projects are using the CodeBuild service role created earlier.

Also the build project should reference the correct buildspec.yml file. See below:

buildspectest.yml  for the terraform init, validate and plan stage.
buildspecapply.yml  for the terraform apply stage.

See guide here[1] on how to do this.

6. CREATE AN SNS TOPIC AND SUBSCRIPTION
These can be created using CloudFormation or manually on the console. See guide here[2] and [3] on how to do this.
This will be used to send emails foir the manual approval stage on the pipeline. 

7. CREATE PIPELINE USING CODEPIPELINE
The pipeline can be created using CloudFormation or manually on the console.

It will have four stages

Source stage
CodeBuild Stage (Terrfoam, init , validate and plan stage)
Manual approval stage (before Terraform Apply)
CodeBuild (Terraform Apply stage)

If creating the pipeline manually from console;
The initial Pipeline will have two stages (Source and build)
We then edit the pipeline and add the manual approval and terraform apply stage (essentially another build stage). 

See relevant guides here[4], [5], [6] and [7] on this. 

References: 

[1] Create a build project in AWS CodeBuild
https://docs.aws.amazon.com/codebuild/latest/userguide/create-project.html

[2] Creating an Amazon SNS topic
https://docs.aws.amazon.com/sns/latest/dg/sns-create-topic.html

[3] Subscribing to an Amazon SNS topic
https://docs.aws.amazon.com/sns/latest/dg/sns-create-subscribe-endpoint-to-topic.html

[4] Create a pipeline in CodePipeline
https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-create.html

[5] Edit a pipeline in CodePipeline
https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-edit.html

[6] Add a manual approval action to a pipeline in CodePipeline
https://docs.aws.amazon.com/codepipeline/latest/userguide/approvals-action-add.html

[7] Add another stage to your pipeline
https://docs.aws.amazon.com/codepipeline/latest/userguide/tutorials-four-stage-pipeline.html#tutorials-four-stage-pipeline-add-stage






