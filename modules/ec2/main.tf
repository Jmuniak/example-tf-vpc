################################################################################
# EC2 Instance Module
################################################################################
# The service itself runs on Windows and should run on a Windows EC2 instance
# Microsoft Windows Server 2022 Base
# ami-09301a37d119fe4c5 (64-bit (x86))
# The application running on the instance listens on ports 443 and 7000-7010


data "aws_ami" "amazon_windows" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]
  }
}

resource "aws_instance" "windows_instance" {
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  ami                    = data.aws_ami.amazon_windows.id
  count                  = var.instance_count
  instance_type          = "t2.micro"
  user_data              = <<EOF
    <powershell>
    # Install dependencies
    # Complete Setup Tasks
    </powershell>
    EOF
  # provisioner "remote-exec" {
  #   inline = [
  #     "echo Hello from the Windows instance!",
  #   ]
  # }

  # Open ports 443 and 7000-7010 for incoming traffic
  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["10.0.0.0/16"]
  # }

  # ingress {
  #   from_port   = 7000
  #   to_port     = 7010
  #   protocol    = "tcp"
  #   cidr_blocks = ["10.0.0.0/16"]
  # }
  tags = var.tags
}




