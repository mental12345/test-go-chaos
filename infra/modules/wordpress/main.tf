data "aws_availability_zones" "all" {}

resource "aws_security_group" "wordpress_sg" {
    name = "${var.env}-wordpress-sg"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "wordpress-sg-lb" {
    name = "${var.env}-wordpress-sg-lb"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
}

resource "aws_elb" "wordpress_lb" {
    name = "wordpressLoadBalancer"
    availability_zones = data.aws_availability_zones.all.names
    listener {
        instance_port      = 80
        instance_protocol  = "http"
        lb_port            = 80
        lb_protocol        = "http"
    }
    
    health_check {
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 4
        target              = "HTTP:80/"
        interval            = 30
    }

    cross_zone_load_balancing   = true
    idle_timeout                = 400
    security_groups = [aws_security_group.wordpress-sg-lb.id]

    tags = {
        Name = "wordpress-elb"
    } 
}

resource "aws_launch_configuration" "wordpress_alc" {
  name_prefix = "${var.env}-alc-wordpress"
  image_id      = var.ami
  instance_type = var.ins_type
  security_groups = [aws_security_group.wordpress_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = "${var.env}-aag-wordpress"
  availability_zones = data.aws_availability_zones.all.names

  launch_configuration      = aws_launch_configuration.wordpress_alc.name
 
  min_size = var.min_size
  max_size = var.max_size
  
  lifecycle {
    create_before_destroy = true
  }
  
  tag {
    key                 = "Name"
    value               = "wordpress"
    propagate_at_launch = true
  }  
  
  tag {
    key                 = "env"
    value               = "prod"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  elb  = aws_elb.wordpress_lb.name
}
