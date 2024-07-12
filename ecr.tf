resource "aws_ecr_repository" "api" {
    name = "${var.prefix}-crud-app"
    image_tag_mutability = "MUTABLE"
    force_delete = true
    tags = {
        Name = "${var.prefix}-crud-app"
    }
}