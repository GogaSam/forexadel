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
    cidr_block  = "10.0.0.0/16"
#                                                                          VPC
    tags = {
        Name = "Exadel VPC"
    }
}

#                          Create Subnets!
resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.main.id
    map_public_ip_on_launch = true
    cidr_block              = "10.0.0.0/24"
#                                                                     PUBLIC SUBNET
    tags = {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
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
        cidr_block = "0.0.0.0/0"
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

#                         Rute Table for Private Subnet
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
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


#                           First instance Ubuntu!
resource "aws_instance" "Ubuntu_web_server" {
    ami                    = "ami-05f7491af5eef733a"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.Ubuntu_security.id]
    subnet_id              = aws_subnet.public_subnet.id
    user_data              = file("ubuntu_user_data.sh")
#                                                                         UBUNTU!
    tags = {
        Name    = "Ubuntu_server"
        Owner   = "Goga S."
        Project = "Exadel Task 3" 
    }
}

#                           Second Instance Red Hat(CentOS)!
resource "aws_instance" "Red_Hat_web_server" {
    ami                    = "ami-06ec8443c2a35b0ba"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.Red_Hat_security.id]
    subnet_id              = aws_subnet.private_subnet.id
    user_data              = file("red_hat_user_data.sh")
#                                                                          RED_HAT!
    tags = {
        Name    = "Amazon_Linux_server"
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
            for_each = ["80", "443", "22"]
        content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
#                                                                       UBUNTU SG
    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
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
            for_each = ["80", "443", "22"]
        content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
#                                                                     RED HAT SG
    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

dynamic "egress" {
            for_each = ["80", "443", "22"]
        content {
            from_port   = egress.value
            to_port     = egress.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    tags = {
    Name = "allow_http_ssh_icmp_https_private"
    }
}