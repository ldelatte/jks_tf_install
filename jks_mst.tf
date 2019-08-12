resource "aws_instance" "jks-mst" {
  instance_type = var.jks-ec2_type
  ami = var.aws_amis[var.jks-ami]
  key_name = "${var.key_name}"
  subnet_id              = "${aws_subnet.jks-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.mst-sg.id}"]
  user_data              = "${file("jks_install-mst.sh")}"
  provisioner "remote-exec" { ## non reexecute
    connection {
      type   = "ssh"
      host   = "${aws_instance.jks-mst.public_dns}"
      user = var.aws_users[var.jks-ami]
      private_key = "${file(var.private_key_path)}"
      timeout = "6m"
    }
    inline = [
      "ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''",
      "echo ''",
      "echo 'cle SSH du maitre a configurer:'",
      "cat .ssh/id_rsa",
      "echo ''",
      "i=0; while [ 12 -ge $i ]; do sleep 20; ((i=i+1)); curl localhost:8080 && break; done",
      "sleep 20",
      "echo ''",
      "echo 'cle d acces web maitre:'",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
      "echo ''",
    ]
  }
  provisioner "local-exec" { ## non reexecute
    command = "curl ${aws_instance.jks-mst.public_ip}:8080"
  }
  tags = { Contact = var.contact, Project = var.projet }
}

output "mst_dns" {
  value = "${aws_instance.jks-mst.public_dns}"
}
output "mst_ip" {
  value = "${aws_instance.jks-mst.public_ip}"
}
