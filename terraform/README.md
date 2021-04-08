# Infrastructure

# Account
For each account you need to create:
- ops user with AdministratorAccess
- ops role with AdministratorAccess and AssumeRole for ops user
```bash
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::329054710135:user/liya@tikalk.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

# Terraform

## Create resources for remote state backend
```bash
cd backend
terraform init -var 'aws_profile=XXX' -var 'aws_region=YYY'
terraform apply -var 'aws_profile=XXX' -var 'aws_region=YYY' [--auto-approve]
cd -
```

## Create a workspace for environment and run
For staging
```bash
cd dummy
terraform init --var-file ../envs/prod.tfvars
terraform workspace new prod
terraform plan --var-file ../envs/prod.tfvars --out prod.tfplan
terraform apply "prod.tfplan" [--auto-approve]
cd -
```

## Switch workspace
Create a new workspace and switch:
```bash
cd dummy
terraform workspace new staging
terraform workspace select staging
```

## Destroy
For staging
```bash
cd dummy
terraform destroy --var-file ../envs/prod.tfvars [--auto-approve]
cd -
```

# EKS cluster
Connect to the cluster
```bash
aws eks update-kubeconfig --name <cluster name> --region <region> --role-arn <Role ARN>
like:
aws eks update-kubeconfig --name polyrize-prod --region eu-central-1 --role-arn arn:aws:iam::329054710135:role/liya-ops
```
