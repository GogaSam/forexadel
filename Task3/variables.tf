
variable owner_id {
    type        = string
    default     = "475468823417"
}

variable public_key_name {
    type        = string
    default     = "Frankfurt.pem"
}

variable instance_type_ubuntu {
    type        = string
    default     = "t2.micro"
}

variable instance_type_red_hat {
    type        = string
    default     = "t2.micro"
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

variable red_hat_ami {
    type        = string
    default     = "red hat ami"
}

variable ubuntu_ami {
    type        = string
    default     = "ubuntu ami"
}