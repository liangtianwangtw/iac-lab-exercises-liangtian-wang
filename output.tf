# add output variable of the vpc id created under network.tf
output "vpc_id" {
    value = module.main_vpc.vpc_id
}
