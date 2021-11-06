variable "vpc_id" {
	type = string
	default = "vpc-ac19a6c6"
}

variable "vpc_cidr" {
	default = "0.0.0.0/32"
}

variable "subnets"{
	type = map(string)
	default = {
		"eu-central-1a" = "subnet-115b3d7b"
		"eu-central-1b" = "subnet-a70ad7db"
		"eu-central-1c" = "subnet-395dfd75"
	}
}

variable "instance_type"{
	type = map(string)
	default = {
		"slaves-instance_type" = "t2.micro"
		"master-instance_type" = "t2.micro"
	}
}

variable "instance_ami"{
	type = string
	default = "ami-0c8cf723261359d88"
}
