resource "aws_launch_configuration" "as_conf" {
  name_prefix          = "web_config"
  image_id      = "ami-0fc61db8544a617ed"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_tls.id]
  user_data = file("${path.module}/user_data.sh")
}

resource "aws_autoscaling_group" "bar" {
  name                      = "foobar3-terraform-test"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = data.aws_subnet_ids.example.ids
  load_balancers = [aws_elb.bar.id]

}