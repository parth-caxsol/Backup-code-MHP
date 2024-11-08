# EKS Terraform Module

This project provides a modular approach to setting up an Amazon EKS cluster using Terraform. The modules are designed to handle the setup of core components such as VPC, EKS cluster, ALB ingress, RBAC, and OIDC configurations. This allows for a scalable and customizable infrastructure that can be easily managed and maintained.

## Table of Contents
- [Overview](overview)
- [Project Structure](project-structure)
- [Prerequisites](prerequisites)
- [Getting Started](getting-started)
- [Modules](modules)
  - [VPC Module](vpc-module)
  - [EKS Module](eks-module)
  - [ALB Ingress Module](alb-ingress-module)
  - [OIDC Module](oidc-module)
  - [RBAC Module](rbac-module)
- [Usage](#usage)
- [Configuration](configuration)

## Overview
This repository provides a complete infrastructure setup for an Amazon EKS cluster using modularized Terraform scripts. Each module is independently responsible for provisioning specific components of the cluster, enabling better modularity and reusability.

## Project Structure

![image](https://github.com/user-attachments/assets/e1ffe31f-40ed-49df-b4f5-a65ec24a8291)



# Prerequisites

Terraform v0.12+
AWS CLI
An AWS account with appropriate permissions to create IAM roles, EKS clusters, and VPCs.
Basic knowledge of Terraform and AWS EKS.

# Getting Started

## Clone the Repository:

``` 
git clone https://github.com/caxsolindia/eks-terraform-module.git
```
``` 
cd eks-terraform-module
```

## Configure AWS CLI: Make sure the AWS CLI is configured with the necessary permissions.
```
aws configure
```
## Initialize Terraform: Initialize the project to install necessary providers.
```
terraform init
```
## Apply the Terraform Configuration: Apply the configuration to provision the infrastructure.
```
terraform apply
```
# Modules

## VPC Module
The vpc module is responsible for creating a custom Virtual Private Cloud (VPC) with public and private subnets. This module provides isolation and security for the EKS cluster components.

## EKS Module
The eks module provisions an Amazon Elastic Kubernetes Service (EKS) cluster, including node groups and configurations for the cluster.

## ALB Ingress Module
The alb-ingress module sets up the Application Load Balancer (ALB) for handling external traffic to Kubernetes services. It includes an ALB policy and associated settings.

## OIDC Module
The oidc module configures OpenID Connect (OIDC) to enable integration with AWS IAM roles, enhancing security and enabling fine-grained access control.

## RBAC Module
The rbac module configures Role-Based Access Control (RBAC) to define user roles and permissions within the Kubernetes cluster.

## Usage
Update terraform.tfvars with your desired configuration values, such as VPC CIDR range, EKS cluster name, and node group details.
Run terraform plan to review the resources to be created.
Run terraform apply to create the resources.

## Configuration
provider.tf: Specifies the AWS provider configuration.
variables.tf: Contains the input variables required for the configuration.
terraform.tfvars: This file is used to define the values for the input variables.
