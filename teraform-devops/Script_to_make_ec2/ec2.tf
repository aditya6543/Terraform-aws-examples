#cnfigure aws credentials
#add private and public keys for ec2
resource aws_key_pair make_key {

  
  key_name = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")

}

#set a vpc or change it from default
resource "aws_default_vpc" "default" {
  
}

#add a security group to your instance
resource "aws_security_group" "my_security_group" {
    name = "automate-sg"
    description = "this will add a tf generated security group"
    vpc_id = aws_default_vpc.default.id

#incoming traffic
ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ssh open"
    }

ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "http open"

    }

ingress{
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "flask_aap"
}   

#outgoing trafic
egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "all access open outbound"
}
    tags={
      Name = "automate-sg"
    }
}

#make an instance
resource "aws_instance" "my_instance" {
  key_name = aws_key_pair.make_key.key_name
  security_groups = [ aws_security_group.my_security_group.name ]
  instance_type = var.aws_instance
  ami = var.aws_ami_id
  root_block_device {
    volume_size = var.aws_root_storage
    volume_type = "gp3"
  }

  tags = {
    Name = "tera-automate"
  }
  
}