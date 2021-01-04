variable "region" {
    description = "The AWS region"
    default     = "us-west-2"
}

variable "ami" {
    default     = "ami-0ad9eaee3c8917484"
}

variable "ins_type" {
    default = "t2.micro"
}
variable "env" {
    default = "go-chaos-test"
}

variable "min_size" {
    default = 6
}

variable "max_size" {
    default = 10
} 