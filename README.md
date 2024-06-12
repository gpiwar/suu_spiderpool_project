# suu_spiderpool_project

Spiderpool - RDMA network solution for the Kubernetes [LINK](https://spidernet-io.github.io/spiderpool/v0.9/#license). 
Spiderpool is an underlay and RDMA network solution for the Kubernetes. 
It enhances the capabilities of Macvlan CNI, ipvlan CNI, SR-IOV CNI, fulfills various networking needs, 
and supports to run on bare metal, virtual machine, and public cloud environments. 
Spiderpool delivers exceptional network performance, particularly benefiting network I/O-intensive and 
low-latency applications like storage, middleware, and AI. It could refer to website for more details.

# Overview

The Spiderpool project aims to manage IP addresses in a Kubernetes cluster using Spiderpool and Multus CNI plugin. 
This project utilizes Terraform for infrastructure provisioning on AWS and Ansible for configuration management.

# Installation Method
## Prerequisites:

  1.   AWS account with necessary permissions.
  2.   Terraform installed (v0.12 or later).
  3.   Ansible installed (v2.9 or later).
  4.   SSH key pair for accessing EC2 instances.

## Steps:
### Clone the Repository:

    git clone https://github.com/gpiwar/suu_spiderpool_project.git
    cd suu_spiderpool_project

### Configure AWS Credentials:
Ensure your AWS credentials are configured in your environment. Place them in ~/.aws/credentials.

### Run the Deployment Script:

    chmod +x run.sh
    ./run.sh

This script will execute the necessary Terraform and Ansible commands to set up the environment, 
deploy Kubernetes, Spiderpool, and the applications.

### Verify Application:
Access the Kubernetes cluster via kubectl and verify node and pod statuses.

    kubectl get nodes
    kubectl get pods -A

Check that Spiderpool has correctly assigned IPs from the defined pools to the pods.
