resource "aws_lb" "lb" {
    name               = "${var.prefix}-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.lb_sg.id]
    subnets = aws_subnet.public_subnets[*].id

    tags = {
        Name = "${var.prefix}-lb"
    }
}

resource "aws_lb_target_group" "tg" {
    name        = "${var.prefix}-tg"
    port        = 8000
    protocol    = "HTTP"
    vpc_id      = aws_vpc.main.id
    target_type = "ip"
    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200,302"
        path                = "/users"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }

    tags = {
        Name = "${var.prefix}-tg"
    }
}

resource "aws_lb_listener" "listener" {
    port              = 80
    protocol          = "HTTP"
    load_balancer_arn = aws_lb.lb.arn

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tg.arn
    }
}

resource "aws_security_group" "lb_sg" {
    name        = "lb_sg"
    description = "Security group for load balancer"

    vpc_id = aws_vpc.main.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        self        = true
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}