variable "master_private_key" {
  description = "Path to private SSH key"
  type        = string
  default     = "../id_ed25519"
}

variable "master_public_key" {
  description = "Path to public SSH key"
  type        = string
  default     = "../id_ed25519.pub"
}

resource "aws_key_pair" "master" {
  key_name   = "master-ec2"
  public_key = file(var.master_public_key)
}

resource "aws_eip" "nat_gw_eip" {
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  subnet_id         = aws_subnet.public.id
  allocation_id     = aws_eip.nat_gw_eip.id
  connectivity_type = "public"
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = var.azs[1]

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = element(aws_subnet.private, count.index).id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "cluster" {
  vpc_id = aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "this" {
  for_each                = local.interfaces
  subnet_id               = each.value.subnet_id
  private_ip_list_enabled = true
  private_ip_list         = each.value.ip_list
  security_groups = [
    aws_security_group.main.id,
    aws_security_group.cluster.id,
  ]
}

resource "aws_instance" "workers" {
  for_each      = local.workers
  ami           = each.value.ami
  instance_type = each.value.instance_type
  key_name      = aws_key_pair.master.key_name

  dynamic "network_interface" {
    for_each = { for idx, id in each.value.interfaces : idx => id }
    content {
      network_interface_id = network_interface.value
      device_index         = network_interface.key
    }
  }
  tags = {
    Name = each.key
  }
}
