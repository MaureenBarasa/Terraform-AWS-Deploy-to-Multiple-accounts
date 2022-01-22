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


SET IAM PERMISSIONS

CREATE BUILDSPEC FILES

CREATE TERRAFORM FILES

CREATE BUILD PROJECTS

CREATE PIPELINE






