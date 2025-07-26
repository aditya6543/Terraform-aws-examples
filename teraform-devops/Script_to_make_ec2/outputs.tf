#outputs for count

output "ec2_public_ip" {
    value = aws_instance.my_instance[*].public_ip  #giver public ip as output
}

output "ec2_public_dns" {
    value = aws_instance.my_instance[*].public_dns #gives public dns as output

  
}

#outputs for for_each
# output "aws_instance" {
#     value = [
#     for instance in aws_instance.my_instance : instance.public_ip

#     ]
# }