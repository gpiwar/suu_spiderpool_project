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
  5.   Helm installed.
  6.   Kubectl installed.

### Addtitional dependencies:

    ansible-galaxy collection install kubernetes.core
    pip install "Jinja2<3.1"
    pip install kubernetes

## Steps:
### Clone the Repository:

    git clone https://github.com/gpiwar/suu_spiderpool_project.git
    cd suu_spiderpool_project

### Configure AWS Credentials:
Ensure your AWS credentials are configured in your environment. Place them in ~/.aws/credentials.

### Run the Deployment Script:

    ./provision_and_deploy.sh

This script will execute the necessary Terraform and Ansible commands to set up the environment, 
deploy Kubernetes, Spiderpool, and the applications.

### Additional manual configuration

Additionaly it's possible to add a new worker in the variables.tf file are set according to your environment requirements. 
Ensure the SpiderIPPool.yaml file is correctly set up to define the network configurations and IP pools.

### Verify deployment:
Access the Kubernetes cluster via kubectl and verify node and pod statuses. Change the item variable according
to output of 'get pods'. Check that Spiderpool has correctly assigned IPs from the defined pools to the pods.

    $ export KUBECONFIG="./kubeconfig"

    $ kubectl get nodes
    NAME      STATUS   ROLES           AGE   VERSION
    master    Ready    control-plane   3m    v1.30.2
    worker1   Ready    <none>          1m    v1.30.2
    worker2   Ready    <none>          1m    v1.30.2
    worker3   Ready    <none>          1m    v1.30.2
    worker4   Ready    <none>          1m    v1.30.2
    
    $ kubectl get spidermultusconfigs.spiderpool.spidernet.io -n kube-system
    NAME          AGE
    ipvlan-eth0   22m
    ipvlan-eth1   22m
    
    $ kubectl get spiderippools
    NAME          VERSION   SUBNET           ALLOCATED-IP-COUNT   TOTAL-IP-COUNT
    172-31-64-0   4         172.31.64.0/20   0                    16
    172-31-96-0   4         172.31.96.0/20   0                    16

    $ kubectl get pods -owide
    NAME                       READY   STATUS    AGE   IP            NODE
    busybox-5dc5cb4bf6-6kv5d   1/1     Running   24m   172.31.65.3   worker1
    busybox-5dc5cb4bf6-9hxxb   1/1     Running   24m   172.31.66.2   worker2
    busybox-5dc5cb4bf6-9jsts   1/1     Running   24m   172.31.68.1   worker4
    busybox-5dc5cb4bf6-9ml79   1/1     Running   24m   172.31.67.4   worker3

    $ kubectl exec -it busybox-5dc5cb4bf6-6kv5d -- ip -4 addr show scope global
    2: eth0@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc noqueue 
        inet 172.31.65.3/20 brd 172.31.79.255 scope global eth0
           valid_lft forever preferred_lft forever
    4: net1@veth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc noqueue 
        inet 172.31.97.3/20 brd 172.31.111.255 scope global net1
           valid_lft forever preferred_lft forever



