resource "aws_security_group_rule" "allow_ssh_access_ingress" {
	security_group_id = aws_security_group.ssh_pc.id
	type = "ingress"
	description = "allow ssh access for my local pc on port 22"
	from_port = 22
	to_port = 22
	protocol = "TCP"
	cidr_blocks = [ "172.31.25.235/32"]
}

resource "aws_security_group_rule" "allow_ssh_access_egress" {
        security_group_id = aws_security_group.ssh_pc.id
        type = "egress"
        description = "allow ssh access for my local pc on port 22"
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = [ "172.31.25.235/32"]
} 

resource "aws_security_group" "ssh_pc" {
	name = "ssh_security_group"
	description = "security group for ssh access"
	vpc_id = var.vpc_id
	tags = {
		Name = "ssh_security_group"
	}
}

resource "aws_security_group_rule" "ubuntu_archives" {
	security_group_id = aws_security_group.cloud_init.id
	type = "egress"
	description = "outbound rule for ubuntu archive files"
	from_port = 80
	to_port = 80
	protocol = "TCP"
	cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_resources" {
	security_group_id = aws_security_group.cloud_init.id
	type = "egress"
	description = "outbound rule for https resources from internet (wget)"
	from_port = 443
	to_port = 443
	protocol = "TCP"
	cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "cloud_init"{
	name = "cloud_init"
	description = "security groups for cloud init commands"
	vpc_id = var.vpc_id
	tags = {
		Name = "cloud_init"
	}

}

resource "aws_security_group_rule" "master_ingress"{
	security_group_id = aws_security_group.apache.id
	type = "ingress"
	description = "ingress for master"
	from_port =  -1
	to_port = -1
	protocol = "TCP"
	cidr_blocks = ["172.31.25.235/32"]
}

resource "aws_security_group_rule" "master_egress"{
	security_group_id = aws_security_group.apache.id
	type = "egress"
	description = "egress to master"
	from_port = -1
	to_port = -1
	protocol = "TCP"
	cidr_blocks = ["172.31.25.235/32"]
}

resource "aws_security_group_rule" "slaves_ingress"{
	security_group_id = aws_security_group.apache.id
	type = "ingress"
	description = "ingress for slave"
	from_port = -1
	to_port = -1
	protocol = "TCP"
	cidr_blocks = ["172.31.0.0/16"]
}

resource "aws_security_group_rule" "slaves_egress"{
	security_group_id = aws_security_group.apache.id
	type = "egress"
	description = "egress for slave"
	from_port = 54311
	to_port = 54311
	protocol = "TCP"
	cidr_blocks = ["172.31.0.0/16"]
}

resource "aws_security_group" "apache" {
	name = "apache"
	description = "security group for apache frameworks"
	vpc_id = var.vpc_id
	tags = {
		Name = "apache"
	}
}

resource "aws_instance" "slave-node-1a" {
	count = "${var.ec2-1a-instance_count}"
	ami = var.instance_ami
	instance_type = var.instance_type["slaves-instance_type"]
	subnet_id = var.subnets["eu-central-1a"]
	availability_zone = "eu-central-1a"
	associate_public_ip_address = true
	vpc_security_group_ids = [
				aws_security_group.ssh_pc.id, 
				aws_security_group.cloud_init.id,
				aws_security_group.apache.id
				]
	
	user_data = file("slave-init")

	root_block_device {
		volume_size = 50
	}

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
	associate_public_ip_address = true
	vpc_security_group_ids = [
				aws_security_group.ssh_pc.id, 
				aws_security_group.cloud_init.id,
				aws_security_group.apache.id
				]
	
	user_data = file("slave-init")

	root_block_device {
		volume_size = 50
	}

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
	associate_public_ip_address = true
	vpc_security_group_ids = [
				aws_security_group.ssh_pc.id, 
				aws_security_group.cloud_init.id,
				aws_security_group.apache.id
				]

	user_data = file("slave-init")

	root_block_device {
		volume_size = 50
	}

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

resource "aws_volume_attachment" "ebs-eu-central-1a-attachment" {
	count = "${var.ec2-1a-instance_count}"
	device_name = "/dev/sdg"
	volume_id = element(aws_ebs_volume.ebs-eu-central-1a.*.id, count.index)
	instance_id = element(aws_instance.slave-node-1a.*.id, count.index)
	provisioner "local-exec" {
		command = "echo '${aws_instance.slave-node-1a[count.index].public_dns}'  >> slave-public-dns"
	}
}

resource "aws_ebs_volume" "ebs-eu-central-1b" {
	count = "${var.ec2-1b-instance_count}"
	availability_zone = "eu-central-1b"
	size = 16
	type = "gp2"
	lifecycle {
		prevent_destroy = true
	}
	tags = {
		Name = "ebs-eu-central-1b-${count.index + 1}"
	}
}

resource "aws_volume_attachment" "ebs-eu-central-1b-attachment" {
	count = "${var.ec2-1b-instance_count}"
	device_name = "/dev/sdg"
	volume_id = element(aws_ebs_volume.ebs-eu-central-1b.*.id, count.index)
	instance_id = element(aws_instance.slave-node-1b.*.id, count.index)
	provisioner "local-exec" {
		command = "echo '${aws_instance.slave-node-1b[count.index].public_dns}'  >> slave-public-dns"
	}
}

resource "aws_ebs_volume" "ebs-eu-central-1c" {
	count = "${var.ec2-1c-instance_count}"
	availability_zone = "eu-central-1c"
	size = 16
	type = "gp2"
	lifecycle {
		prevent_destroy = true
	}
	tags = {
		Name = "ebs-eu-central-1c-${count.index + 1}"
	}
}

resource "aws_volume_attachment" "ebs-eu-central-1c-attachment" {
	count = "${var.ec2-1c-instance_count}"
	device_name = "/dev/sdg"
	volume_id = element(aws_ebs_volume.ebs-eu-central-1c.*.id, count.index)
	instance_id = element(aws_instance.slave-node-1c.*.id, count.index)
	provisioner "local-exec" {
		command = "echo '${aws_instance.slave-node-1c[count.index].public_dns}'  >> slave-public-dns"
	}
}
