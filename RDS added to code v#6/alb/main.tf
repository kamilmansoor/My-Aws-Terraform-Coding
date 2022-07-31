
#Security Group for Application Load balancer
resource "aws_security_group" "alb_sg" {
  name        = var.alb_sg_name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

#The ALB-SG-ingress port needs to be same as of ALB-Listener

#The ALB-SG-igress is open for all ports and protocols  

  ingress {
    description = "allow http"
    from_port   = 0
    to_port     = 0
    #The -1 below in protocol at ALB-SG-ingress, means all protocol 
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.alb_sg_name
  }
}



#Application Load Balancer

resource "aws_lb" "application_load_balancer" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            =  var.public_subnet
}

################AWS Target Group AND LISTENER # 1:  ########################


#Application Load Balancer Target Group # 1:
#Traffic will be routed to target web server instances on HTTP port 80 

resource "aws_lb_target_group" "alb_tg_1" {
  name     = var.alb_tg_1_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


#Application Load Balancer Listener # 1:
resource "aws_lb_listener" "alb_listener_http_1" {
  # for_each = var.lb-trgtgrps-listener-rules-http
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_1.arn
  }
}

#################################################

################AWS Target Group AND LISTENER # 2:  ########################


#Application Load Balancer Target Group # 2:
#Traffic will be routed to target web server instances on HTTP port 50

resource "aws_lb_target_group" "alb_tg_2" {
  # for_each = var.lb-trgtgrps-listener-rules-http
  name     = var.alb_tg_2_name
  port     = 50
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}



#Application Load Balancer Listener # 2:

#The ALB-SG-ingress port needs to be same as of ALB-Listener
resource "aws_lb_listener" "alb_listener_http_2" {
  # for_each = var.lb-trgtgrps-listener-rules-http
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "50"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_2.arn
  }
}

