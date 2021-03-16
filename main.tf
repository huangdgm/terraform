provider "aws" {
	region = "us-east-2"
}

resource "aws_instance" "example" {
	ami 				= "ami-07a0844029df33d7d"
	instance_type 			= "t2.micro"
	vpc_security_group_ids 		= [aws_security_group.instance.id]

	user_data = <<-EOF
		    #!/bin/bash
		    sudo yum update -y
                    sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
		    sudo yum install -y httpd mariadb-server
		    sudo systemctl start httpd
		    sudo systemctl enable httpd
		    sudo usermod -a -G apache ec2-user
		    sudo chown -R ec2-user:apache /var/www
		    sudo chmod -R 777 /var/www
		    sudo find /var/www -type d -exec chmod 2775 {} \;
		    sudo find /var/www -type f -exec chmod 0664 {} \;
		    sudo echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
		    EOF

	tags = {
		Name = "terraform-example"
	}
}

resource "aws_security_group" "instance" {
	name = "terraform-example-instance"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}
