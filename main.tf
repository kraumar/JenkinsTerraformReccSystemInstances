resource "tls_private_key" "ssh" {
	algorithm = "RSA"
	rsa_bits = "4096"
}

resource "aws_key_pair" "key-to-pc"{
	key_name = "key-to-pc"
	public_key = tls_private_key.ssh.public_key_openssh
  	
	provisioner "local-exec" { 
    		command = "echo '${tls_private_key.ssh.private_key_pem}' > /home/marek-ubu/Documents/IAC/key-to-pc.pem"
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

resource "aws_instance" "slave-node-1a" {
	count = "${var.ec2-1a-instance_count}"
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
        count = "${var.ec2-1b-instance_count}"
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
        count = "${var.ec2-1c-instance_count}" 
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

resource "aws_ebs_volume" "ebs-eu-central-1a" {
	count = "${var.ec2-1a-instance_count}"
	availability_zone = "eu-central-1a"
	size = 16
	type = "gp2"
	lifecycle {
		prevent_destroy = true
	}
	tags = {
		Name = "ebs-eu-central-1a-${count.index + 1}"
	}
}

resource "aws_volume_attachment" "ebs-eu-central-1a-attachement" {
	count = "${var.ec2-1a-instance_count}"
	device_name = "/dev/sda1"
	volume_id = "{aws_ebs_volume.ebs-eu-central-1a.*.id[count.index]}"
	instance_id = "${aws_instance.slave-node-1a.*.id[count.index]}"
}
