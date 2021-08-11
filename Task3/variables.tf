variable public_key {
    type        = string
    default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCIZpCdwxp8nxlBw27py+Fy+hC6bc7zw3H/eag0s8MeGoUrlnQc065svqiatlOBZEZVLbt8aLLZl4+NvZZ3LJRGMFI4caf5BLsKWjAFowGUHjfj009eVw0hzk0newlIBhH3O6pI60hNeWrAllXPs2S2pRtMhwwnr0wqXhta0GNJ2FM+5RLC46IBozSJ/1TEZz35fXwWvnCckCXLrs5ZECIhzqlOAjHaZqCSY2goIOXEaGaRBn468Lq+4QO59neDzM6xdsH5CnZ8EY8EfoTZKpxlgoARBvv+dys1VhIAz0wwawA0w9X+MaozztbQNdIq0hVQeXsclo2jXFB1lVcj2Qt3 Frankfurt"
    description = "public key for all hosts"
}

variable public_key_name {
    type        = string
    default     = "Frankfurt.pem"
}

variable instance_type_ubuntu {
    type        = string
    default     = "t2.micro"
}

variable ami_ubuntu {
    type        = string
    default     = "ami-05f7491af5eef733a"
}

variable instance_type_red_hat {
    type        = string
    default     = "t2.micro"
}

variable ami_red_hat {
    type        = string
    default     = "ami-06ec8443c2a35b0ba"
}

variable vpc_cidr_block {
    type       = string
    default    = "10.0.0.0/16"
}

variable public_subnet_cidr_block {
    type        = string
    default     = "10.0.0.0/24"
}

variable private_subnet_cidr_block {
    type        = string
    default     = "10.0.1.0/24"
}

variable internet {
    type        = string
    default     = "0.0.0.0/0"
}

variable ports {
    type        = list
    default     = ["443", "80", "22"]
}

variable icmp {
    type        = number
    default     = -1
}

variable network_interface_ip {
    type        = string
    default     = "10.0.0.110"
}

variable network_interface_ip_cidr {
    type        = string
    default     = "10.0.0.110/32"
}