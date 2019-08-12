resource "aws_instance" "jks-wrk" {
  instance_type = var.jks-ec2_type
  ami = var.aws_amis[var.jks-ami]
  key_name = "${var.key_name}"
  subnet_id              = "${aws_subnet.jks-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.wrk-sg.id}"]
  user_data              = "${file("jks_install-wrk.sh")}"
  provisioner "remote-exec" { ## non reexecute
    connection {
      type   = "ssh"
      host   = "${aws_instance.jks-wrk.public_dns}"
      user = var.aws_users[var.jks-ami]
      private_key = "${file(var.private_key_path)}"
      timeout = "3m"
    }
    inline = [
      "echo nom du worker :",
      "uname -n",
    ]
  }
  provisioner "local-exec" { ## non reexecute
    command = "scp -p -i ~/.ssh/cle_aws.pem -o 'StrictHostKeyChecking no' ${var.aws_users[var.jks-ami]}@${aws_instance.jks-mst.public_ip}:.ssh/id_rsa.pub /tmp/"
  }
  provisioner "local-exec" { ## non reexecute
    command = "scp -p -i ~/.ssh/cle_aws.pem -o 'StrictHostKeyChecking no' /tmp/id_rsa.pub ${var.aws_users[var.jks-ami]}@${aws_instance.jks-wrk.public_ip}:/tmp/"
  }
  provisioner "local-exec" { ## non reexecute
    command = "ssh -i ~/.ssh/cle_aws.pem ${var.aws_users[var.jks-ami]}@${aws_instance.jks-wrk.public_ip} \"cat /tmp/id_rsa.pub >>.ssh/authorized_keys\""
  }
  provisioner "local-exec" { ## non reexecute
    command = "ssh -i ~/.ssh/cle_aws.pem ${var.aws_users[var.jks-ami]}@${aws_instance.jks-mst.public_ip} \"ssh -o 'StrictHostKeyChecking no' ${aws_instance.jks-wrk.private_ip} rm /tmp/id_rsa.pub\""
  }
  tags = { Contact = var.contact, Project = var.projet }
}

output "wrk_dns" {
  value = "${aws_instance.jks-wrk.public_dns}"
}
output "wrk_ip" {
  value = "${aws_instance.jks-wrk.public_ip}"
}
