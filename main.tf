resource "tls_private_key" "ssh" {
	algorithm = "RSA"
	rsa_bits = "4096"
}

resource "aws_key_pair" "key-to-pc"{
	key_name = "key-to-pc"
	public_key = tls_private_key.ssh.public_key_openssh
  	
	provisioner "local-exec" { 
    		command = "echo '${tls_private_key.ssh.private_key_pem}' > ./key-to-pc.pem"
  	}
}

resource "aws_security_group_rule" "allow_ssh_access" {
	security_group_id = aws_security_group.ssh_pc.id
	type = "ingress"
	description = "allow ssh access for my local pc on port 22"
	from_port = 22
	to_port = 22
	protocol = "TCP"
	cidr_blocks = [ "89.64.44.23/32"]
} 

resource "aws_security_group" "ssh_pc" {
	name = "ssh_security_group"
	description = "security group for ssh access"
	vpc_id = var.vpc_id
	tags = {
		Name = "ssh_security_group"
	}
}

resource "aws_instance" "master-node" {
	ami = var.instance_ami
	instance_type = var.instance_type["master-instance_type"]
	subnet_id = var.subnets["eu-central-1a"]
	availability_zone = "eu-central-1a"
	key_name = aws_key_pair.key-to-pc.key_name
	associate_public_ip_address = true
	vpc_security_group_ids = [aws_security_group.ssh_pc.id]
	tags = {
		Name = "master-node-1a"
	}
}

resource "aws_instance" "slave-node-1a" {
	count = 1
	ami = var.instance_ami
	instance_type = var.instance_type["slaves-instance_type"]
	subnet_id = var.subnets["eu-central-1a"]
	availability_zone = "eu-central-1a"
	key_name = aws_key_pair.key-to-pc.key_name	
	associate_public_ip_address = true
	vpc_security_group_ids = [aws_security_group.ssh_pc.id]

	tags = {
		Name = "slave-node-1a-${count.index + 1}"

	}
}

resource "aws_instance" "slave-node-1b" {
        count = 1
        ami = var.instance_ami
        instance_type = var.instance_type["slaves-instance_type"]
        subnet_id = var.subnets["eu-central-1b"]
        availability_zone = "eu-central-1b"
        key_name = aws_key_pair.key-to-pc.key_name
        associate_public_ip_address = true
        vpc_security_group_ids = [aws_security_group.ssh_pc.id]

        tags = {
                Name = "slave-node-1b-${count.index + 1}"

        }
}

resource "aws_instance" "slave-node-1c" {
        count = 1
        ami = var.instance_ami
        instance_type = var.instance_type["slaves-instance_type"]
        subnet_id = var.subnets["eu-central-1c"]
        availability_zone = "eu-central-1c"
        key_name = aws_key_pair.key-to-pc.key_name
        associate_public_ip_address = true
        vpc_security_group_ids = [aws_security_group.ssh_pc.id]

        tags = {
                Name = "slave-node-1c-${count.index + 1}"

        }
}
