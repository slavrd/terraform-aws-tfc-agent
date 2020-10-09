# An complete deployment of the TERRAFORM-AWS-TFC-AGENT module

In this Terraform configuration the `terraform-aws-tfc-agent` module is used in conjunction with other Terraform modules to deploy TFC Agents on AWS ECS without having any pre-existing AWS configuration.

## Prerequisites

* Have Terraform `>= 0.13` installed.
* AWS Credentials

## Run

Follow the steps below to deploy the Terraform configuration.

* Copy the `example.tfvars` file to `example.auto.tfvars`
* Replace the variable values in `example.auto.tfvars` with ones appropriate for your environment
* Set up AWS Credentials according to the AWS SDK e.g. via environment variables or AWS credentials file.
* Set up the AWS region e.g. `export AWS_REGION=eu-central-1`
* Initialize Terraform

  ```
  terraform init
  ```

* Deploy the infrastructure 

  ```
  terraform apply
  ```

  After the command completes TFC Agent containers will be started on AWS ECS and will register with the appropriate Terraform Cloud agent pool.

* Clean up
  
  ```
  terraform destroy
  ```
