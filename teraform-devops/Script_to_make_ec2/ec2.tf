#cnfigure aws credentials
#add private and public keys for ec2
resource aws_key_pair my_key {

  
  key_name = "${var.env}-terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
  tags={
    Environment = var.env
  }

}

#set a vpc or change it from default
resource "aws_default_vpc" "default" {
  
}

#add a security group to your instance
resource "aws_security_group" "my_security_group" {
    name ="${var.env}-automate-sg"

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
      # Environment = var.env
    Name = "${var.env}-automate-sg"

    }
}

#make an instance
resource "aws_instance" "my_instance" {
#to create more than one ec2 instances
  for_each = tomap({
    my_t2micro = "t2.micro"
    # my_t2medium = "t2.medium"
    # # my_t2small = "t2.large"
  })
  # count = 1 #number of instances to be formed
  depends_on = [ aws_key_pair.my_key , aws_security_group.my_security_group ]
  key_name = aws_key_pair.my_key.key_name
  security_groups = [ aws_security_group.my_security_group.name ]
  instance_type = var.aws_instance #if using for_each replace this with  instance_type = each.value
  ami = var.aws_ami_id
  user_data = file("install_nginx.sh")
  root_block_device {
    volume_size = var.aws_root_storage
    volume_type = "gp3"
    
  }
  tags = {
  Name = "My_instance"   #if using for_each replace this with Name = each.key
  Environment = var.env
  }
  
}

# resource "aws_instance" "my_new_instance" {
#   ami = "unkown"
#   instance_type = "unkown"
  
# }