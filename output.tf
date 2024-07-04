# add output variable of the vpc id created under network.tf
output "vpc_id" {
    value = aws_vpc.main.id
}
