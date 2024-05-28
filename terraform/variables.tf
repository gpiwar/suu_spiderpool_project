variable "net_cidr" {
  type        = string
  description = "Network CIDR"
  default     = "172.31.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public Subnet CIDR"
  default     = "172.31.0.0/20"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDRs"
  default     = ["172.31.16.0/20", "172.31.32.0/20"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

locals {
  bastion = {
    ami           = data.aws_ami.this.id
    instance_type = "t2.micro"
  }
  interfaces = {
    master_eth0 = {
      subnet_id = aws_subnet.private[0].id
    }
    master_eth1 = {
      subnet_id = aws_subnet.private[1].id
    }
    worker1_eth0 = {
      subnet_id = aws_subnet.private[0].id
    }
    worker1_eth1 = {
      subnet_id = aws_subnet.private[1].id
    }
    worker2_eth0 = {
      subnet_id = aws_subnet.private[0].id
    }
    worker2_eth1 = {
      subnet_id = aws_subnet.private[1].id
    }
  }
  master = {
    ami           = data.aws_ami.this.id
    instance_type = "t2.micro"
    interfaces = [
      aws_network_interface.this["master_eth0"].id,
      aws_network_interface.this["master_eth1"].id,
    ]
  }
  workers = {
    worker1 = {
      ami           = data.aws_ami.this.id
      instance_type = "t2.micro"
      interfaces = [
        aws_network_interface.this["worker1_eth0"].id,
        aws_network_interface.this["worker1_eth1"].id
      ]
    }
    worker2 = {
      ami           = data.aws_ami.this.id
      instance_type = "t2.micro"
      interfaces = [
        aws_network_interface.this["worker2_eth0"].id,
        aws_network_interface.this["worker2_eth1"].id
      ]
    }
  }
}