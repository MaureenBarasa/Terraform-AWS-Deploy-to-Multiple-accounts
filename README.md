# This Repository is for an Automation Project to deploy resources from an AWS account in another AWS account.

It provides a step by step guide on how to do this. 

The Project will make use of:

1.IAM
2. Parameter-Store
3. CodeCommit
4. CodeBuild
5. CodePipeline
6. S3
7. SNS 

1. SET UP CREDENTIALS ON PARAMETER STORE

- Create a user Terraform/Git on the AWS account (DevOps Account) that will host the CodePipeline.
- Generate Access Keys and Secret Keys for the user.
- Store the credentials to Parameter store. I stored mine as; 

    . devops-access-key
    . devops-secret-key

SET IAM PERMISSIONS

CREATE BUILDSPEC FILES

CREATE TERRAFORM FILES

CREATE BUILD PROJECTS

CREATE PIPELINE






