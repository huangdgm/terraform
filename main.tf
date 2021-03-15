provider "aws" {
	region = "us-east-2"
}

resource "aws_instance" "example" {
	ami		= "ami-07a0844029df33d7d"
	instance_type	= "t2.micro"

	tags = {
		Name = "terraform-example"
	}
}
