# ----------------------------------------------------------
#
# Written By Samunashvili Goga
#
# ----------------------------------------------------------

provider "aws" {
    region = "eu-central-1"
}

#                           Create VPC!
resource "aws_vpc" "main" {
    cidr_block  = var.vpc_cidr_block
#                                                                          VPC
    tags = {
        Name = "Exadel VPC"
    }
}

#                          Create Subnets!
resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.main.id
    map_public_ip_on_launch = true
    cidr_block              = var.public_subnet_cidr_block
#                                                                     PUBLIC SUBNET
    tags = {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr_block
#                                                                     PRIVATE SUBNET
    tags = {
        Name = "private_subnet"
    }
}

#                          Create IGW!
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
#                                                                          IGW
    tags = {
        Name = "exadel internet gateway"
    }
}

#                          Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
    vpc        = true
    depends_on = [aws_internet_gateway.igw]
#                                                                       Elastic IP
    tags = {
        Name = "Exadel-Elastic-IP"
    }
}

#                          NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_subnet.id
#                                                                       NAT GATEWAY
    tags = {
        Name = "Exadel-NAT-GW"
    }
}

#                          Route Table For Public Subnet!
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = var.internet
        gateway_id = aws_internet_gateway.igw.id
    }
#                                                                ROUTE TABLE PUBLIC SUBNET
    tags = {
        Name = "exadel_RTB"
    }
}
#                 Associate between Public Subnet and Public Route Table
resource "aws_route_table_association" "public" {
#                                                                  RTB ASSOCIATION PUBLIC
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public.id
}

/*resource "aws_route_table" "network_interface_route" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = var.network_interface_ip_cidr
        gateway_id = aws_nat_gateway.nat_gateway.id
    }
}*/

#                         Route Table for Private Subnet
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = var.internet
        gateway_id = aws_nat_gateway.nat_gateway.id
    }

#                                                                ROUTE TABLE PRIVATE SUBNET
    tags = {
        Name = "route for private subnet"
    }
}

resource "aws_route_table_association" "private" {
#                                                                  RTB ASSOCIATION PRIVATE
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private.id
}

resource "aws_key_pair" "linux" {
    key_name   =  var.public_key_name
    public_key =  var.public_key
}

resource "aws_network_interface" "my_network" {
    subnet_id       = aws_subnet.public_subnet.id
    private_ips     = [var.network_interface_ip]
    security_groups = [aws_security_group.Ubuntu_security.id]

    tags        = {
        Name    = "Ubuntu private IP"
    }
}

#                           First instance Ubuntu!
resource "aws_instance" "Ubuntu_web_server" {
    ami                    = var.ami_ubuntu
    instance_type          = var.instance_type_ubuntu
    key_name               = aws_key_pair.linux.id
    user_data              = file("ubuntu_user_data.sh")
#                                                                         UBUNTU!
    network_interface {
        network_interface_id = aws_network_interface.my_network.id
        device_index         = 0
    }
    tags = {
        Name    = "Ubuntu_server"
        Owner   = "Goga S."
        Project = "Exadel Task 3" 
    }
}

#                           Second Instance Red Hat(CentOS)!
resource "aws_instance" "Red_Hat_web_server" {
    ami                    = var.ami_red_hat
    instance_type          = var.instance_type_red_hat
    vpc_security_group_ids = [aws_security_group.Red_Hat_security.id]
    key_name               = aws_key_pair.linux.id
    subnet_id              = aws_subnet.private_subnet.id
    user_data              = file("red_hat_user_data.sh")
#                                                                          RED_HAT!
    tags = {
        Name    = "Red_Hat_server"
        Owner   = "Goga S."
        Project = "Exadel Task 3" 
    }
}

#                           Security Group for Ubuntu!
resource "aws_security_group" "Ubuntu_security" {
    vpc_id      = aws_vpc.main.id
    name        = "Ubuntu security group"
    description = "task 3/2"

    dynamic "ingress" {
            for_each = var.ports
        content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = [var.internet]
        }
    }
#                                                                       UBUNTU SG
    ingress {
        from_port   = var.icmp
        to_port     = var.icmp
        protocol    = "icmp"
        cidr_blocks = [var.internet]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = [var.internet]
        }

    tags = {
    Name = "allow_http_ssh_icmp_https"
    }
}

#                           Security Group for Red Hat!
resource "aws_security_group" "Red_Hat_security" {
    vpc_id      = aws_vpc.main.id
    name        = "Amazon Linux security group"
    description = "task 3/3"

    dynamic "ingress" {
            for_each = var.ports
        content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = [var.network_interface_ip_cidr]
        }
    }
#                                                                     RED HAT SG
    ingress {
        from_port   = var.icmp
        to_port     = var.icmp
        protocol    = "icmp"
        cidr_blocks = [var.network_interface_ip_cidr]
    }

dynamic "egress" {
            for_each = var.ports
        content {
            from_port   = egress.value
            to_port     = egress.value
            protocol    = "tcp"
            cidr_blocks = [var.network_interface_ip_cidr]
        }
    }

    tags = {
    Name = "allow_http_ssh_icmp_https_private"
    }
}