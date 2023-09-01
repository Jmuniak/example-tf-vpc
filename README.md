# example-tf-vpc

# Scenario: 
Adroit is looking to deploy a new microservice in our SaaS environment - this will provide a new API endpoint to Adroit's SaaS clients. We want to write a Terraform module(s) to deploy the infrastructure required to host this service. Note that Adroit has many separate environments (some specific to a single client), and we want this module to be created in a way we can reuse it to easily deploy the new service in all environments.

# Requirements:
- The resources for this service should go into an existing VPC/subnet
- The service itself runs on Windows and should run on a Windows EC2 instance
- The instance needs to take a user data powershell script that will perform some setup tasks (you do not need to write the powershell script, but there should be a placeholder for the full script)
- The application running on the instance listens on ports 443 and 7000-7010
- There should be an RDS instance that will be used for the DB backend (use MSSQL Server)
- The application should be behind an Application Load Balancer with appropriate ports exposed
Security groups should be created that allow the minimal required level of access between systems. The service should not be accessible over the internet.
- There should be a VPC endpoint service created to expose this service to clients


# Overview of Solution:
This structure could be improved upon, such as separating the infrastructure components more to make each plan only a few resource items that you might need to redeploy more often for some reason. I'll always be interested in feedback/suggestions but with that that said this is my suggested aproach to a solution.  

Using VPC Endpoints requires the use of a Network Load Balancer or a Gatway Load Balancer not an Application Load Balancer. 

- main.tf demonstrates one way to collect all the modules together for structure. Allows for more modular and maintainable code for different environments as needed with multiple customers per the requirements of our scenario. The NLB, Security Group and VPC Endpoints are also on main.tf to keep it easily readable rather than breaking these tiny pieces into other local modules as demonstrated with EC2 and RDS modules locally. 

- ec2.tf contains relevant resources for the module.
  ``` hcl
  resource "aws_instance" "windows_instance" {
    ...
  }
  ```

- rds.tf contains relevant resources for the module.
  ``` hcl
  resource "aws_db_instance" "db_instance" {
    ...
  }
  ```


# Example extra_vars.tfvars file
```hcl
region            = "us-east-1"
name              = "adroit"
vpc_name          = "adroit-example-project-vpc" # or use existing project vpc name
vpc_cidr          = ["10.0.0.0/16"]              # or use existing project vpc_cidr
vpc_id            = "vpc-0abd21e85991bfdd0"      # must use an existing project vpc_id
private_subnet_id = "subnet-0af4bc02c9223b72b"   # must use anexisting project private_subnet_id

# 10.0.10.0/24 Private Subnet A, 10.0.20.0/24 Private Subnet B, 10.0.30.0/24 Private Subnet C
private_subnet_ids = ["subnet-0af4bc02c9223b72b", "subnet-0d2426210aa29466a", "subnet-001250f0522fbdc29"] # also must replace these with existing subnets in different AZs. 
tags = {
  project     = "adroit",
  environment = "dev"
}
```


# Usage 
1. Export your AWS_PROFILE in your terminal
2. Locally create from the template above and make updates to the file "-var-file=extra_vars.tfvars" ( be sure to replace the VPC and Subnet lines as directed)
3. Run terraform. 
	1.  `terraform init -input=false`
	2.  `terraform validate`
	3.  `terraform plan -input=false -var-file=extra_vars.tfvars -out tfplan.binary`
	4.  `terraform apply -input=false tfplan.binary`