terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "EC2Instance" {
    ami = "ami-0953476d60561c955"
    instance_type = "t2.micro"
    key_name = "piyush"
    availability_zone = "us-east-1b"
    tenancy = "default"
    subnet_id = "subnet-54720975"
    ebs_optimized = false
    vpc_security_group_ids = [
        "${aws_security_group.EC2SecurityGroup.id}"
    ]
    source_dest_check = true
    root_block_device {
        volume_size = 8
        volume_type = "gp3"
        delete_on_termination = true
    }
    tags = {}
}

resource "aws_instance" "EC2Instance2" {
    ami = "ami-02457590d33d576c3"
    instance_type = "t3.medium"
    key_name = "docutech"
    availability_zone = "us-east-1c"
    tenancy = "default"
    subnet_id = "subnet-cee3ee83"
    ebs_optimized = true
    vpc_security_group_ids = [
        "${aws_security_group.EC2SecurityGroup8.id}",
        "${aws_security_group.EC2SecurityGroup7.id}"
    ]
    source_dest_check = true
    root_block_device {
        volume_size = 8
        volume_type = "gp3"
        delete_on_termination = true
    }
    iam_instance_profile = "s3-access"
    tags = {
        Name = "docutech-1"
    }
}

resource "aws_lb" "ElasticLoadBalancingV2LoadBalancer" {
    name = "docutech-alb"
    internal = false
    load_balancer_type = "application"
    subnets = [
        "subnet-b7a0ddd1",
        "subnet-cee3ee83"
    ]
    security_groups = [
        "${aws_security_group.EC2SecurityGroup2.id}"
    ]
    ip_address_type = "ipv4"
    access_logs {
        enabled = false
        bucket = ""
        prefix = ""
    }
    idle_timeout = "60"
    enable_deletion_protection = "false"
    enable_http2 = "true"
    enable_cross_zone_load_balancing = "true"
}

resource "aws_lb_listener" "ElasticLoadBalancingV2Listener" {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:456297142581:loadbalancer/app/docutech-alb/6151cfde61866640"
    port = 443
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
    certificate_arn = "arn:aws:acm:us-east-1:456297142581:certificate/3bb31484-bb3b-4ac2-953d-4752a662363a"
    default_action {
        target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:456297142581:targetgroup/app-target-group/501cecd2784d9f34"
        type = "forward"
    }
}

resource "aws_lb_listener_rule" "ElasticLoadBalancingV2ListenerRule" {
    priority = "1"
    listener_arn = "arn:aws:elasticloadbalancing:us-east-1:456297142581:listener/app/docutech-alb/6151cfde61866640/1b78b458fd76e292"
    condition {
        host_header {
            values = [
                "api.docutech.io"
            ]
        }
    }
    action {
        type = "forward"
        target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:456297142581:targetgroup/api-target-group/d4fc8d1423754c85"
        forward {
            target_group = [
                {
                    arn = "arn:aws:elasticloadbalancing:us-east-1:456297142581:targetgroup/api-target-group/d4fc8d1423754c85"
                    weight = 1
                }
            ]
            stickiness {
                duration = 3600
                enabled = false
            }
        }
    }
    tags = 
}

resource "aws_lb_listener_rule" "ElasticLoadBalancingV2ListenerRule2" {
    priority = "2"
    listener_arn = "arn:aws:elasticloadbalancing:us-east-1:456297142581:listener/app/docutech-alb/6151cfde61866640/1b78b458fd76e292"
    condition {
        host_header {
            values = [
                "app.docutech.io"
            ]
        }
    }
    action {
        type = "forward"
        target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:456297142581:targetgroup/app-target-group/501cecd2784d9f34"
        forward {
            target_group = [
                {
                    arn = "arn:aws:elasticloadbalancing:us-east-1:456297142581:targetgroup/app-target-group/501cecd2784d9f34"
                    weight = 1
                }
            ]
            stickiness {
                duration = 3600
                enabled = false
            }
        }
    }
    tags = 
}

resource "aws_lb_listener" "ElasticLoadBalancingV2Listener2" {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:456297142581:loadbalancer/app/docutech-alb/6151cfde61866640"
    port = 80
    protocol = "HTTP"
    default_action {
        redirect {
            host = "#{host}"
            path = "/#{path}"
            port = "443"
            protocol = "HTTPS"
            query = "#{query}"
            status_code = "HTTP_301"
        }
        type = "redirect"
    }
}

resource "aws_lb_target_group" "ElasticLoadBalancingV2TargetGroup" {
    health_check {
        interval = 30
        path = "/public/openapi.json"
        port = "8080"
        protocol = "HTTP"
        timeout = 5
        unhealthy_threshold = 2
        healthy_threshold = 5
        matcher = "200"
    }
    port = 8080
    protocol = "HTTP"
    target_type = "instance"
    vpc_id = "vpc-00fa737d"
    name = "api-target-group"
}

resource "aws_lb_target_group" "ElasticLoadBalancingV2TargetGroup2" {
    health_check {
        interval = 30
        path = "/public/openapi.json"
        port = "8080"
        protocol = "HTTP"
        timeout = 5
        unhealthy_threshold = 2
        healthy_threshold = 5
        matcher = "200"
    }
    port = 3000
    protocol = "HTTP"
    target_type = "instance"
    vpc_id = "vpc-00fa737d"
    name = "app-target-group"
}

resource "aws_ebs_volume" "EC2Volume" {
    availability_zone = "us-east-1c"
    encrypted = false
    size = 8
    type = "gp3"
    snapshot_id = "snap-02a7d2e0660b6814e"
    tags = {}
}

resource "aws_volume_attachment" "EC2VolumeAttachment" {
    volume_id = "vol-02e2a8315c1c2fc31"
    instance_id = "i-0e185455f4648e0cb"
    device_name = "/dev/xvda"
}

resource "aws_ebs_volume" "EC2Volume2" {
    availability_zone = "us-east-1b"
    encrypted = false
    size = 8
    type = "gp3"
    snapshot_id = "snap-0066a3d98840265c3"
    tags = {}
}

resource "aws_volume_attachment" "EC2VolumeAttachment2" {
    volume_id = "vol-0ba920e6cdc81036e"
    instance_id = "i-0c226008af191775b"
    device_name = "/dev/xvda"
}

resource "aws_network_interface" "EC2NetworkInterface" {
    description = ""
    private_ips = [
        "172.31.17.204"
    ]
    subnet_id = "subnet-cee3ee83"
    source_dest_check = true
    security_groups = [
        "${aws_security_group.EC2SecurityGroup8.id}",
        "${aws_security_group.EC2SecurityGroup7.id}"
    ]
}

resource "aws_network_interface_attachment" "EC2NetworkInterfaceAttachment" {
    network_interface_id = "eni-0aeacd067f944104f"
    device_index = 0
    instance_id = "i-0e185455f4648e0cb"
}

resource "aws_network_interface" "EC2NetworkInterface2" {
    description = "ELB app/docutech-alb/6151cfde61866640"
    private_ips = [
        "172.31.18.72"
    ]
    subnet_id = "subnet-cee3ee83"
    source_dest_check = true
    security_groups = [
        "${aws_security_group.EC2SecurityGroup2.id}"
    ]
}

resource "aws_network_interface" "EC2NetworkInterface3" {
    description = ""
    private_ips = [
        "172.31.94.114"
    ]
    subnet_id = "subnet-54720975"
    source_dest_check = true
    security_groups = [
        "${aws_security_group.EC2SecurityGroup.id}"
    ]
}

resource "aws_network_interface_attachment" "EC2NetworkInterfaceAttachment2" {
    network_interface_id = "eni-031cc419c7c4bcc81"
    device_index = 0
    instance_id = "i-0c226008af191775b"
}

resource "aws_network_interface" "EC2NetworkInterface4" {
    description = "ELB app/docutech-alb/6151cfde61866640"
    private_ips = [
        "172.31.2.245"
    ]
    subnet_id = "subnet-b7a0ddd1"
    source_dest_check = true
    security_groups = [
        "${aws_security_group.EC2SecurityGroup2.id}"
    ]
}

resource "aws_security_group" "EC2SecurityGroup" {
    description = "launch-wizard-5 created 2025-05-17T18:56:15.526Z"
    name = "launch-wizard-5"
    tags = {}
    vpc_id = "vpc-00fa737d"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup2" {
    description = "Allows HTTP and HTTPS"
    name = "docutech-alb-sg"
    tags = {}
    vpc_id = "vpc-00fa737d"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 80
        protocol = "tcp"
        to_port = 80
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 443
        protocol = "tcp"
        to_port = 443
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 80
        protocol = "tcp"
        to_port = 80
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 8080
        protocol = "tcp"
        to_port = 8080
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 3000
        protocol = "tcp"
        to_port = 3000
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 443
        protocol = "tcp"
        to_port = 443
    }
}

resource "aws_security_group" "EC2SecurityGroup3" {
    description = "launch-wizard-3 created 2025-05-15T14:37:29.501Z"
    name = "launch-wizard-3"
    tags = {}
    vpc_id = "vpc-00fa737d"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup4" {
    description = "launch-wizard-4 created 2025-05-16T16:53:48.654Z"
    name = "launch-wizard-4"
    tags = {}
    vpc_id = "vpc-00fa737d"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup5" {
    description = "launch-wizard-1 created 2025-05-14T22:12:38.153Z"
    name = "launch-wizard-1"
    tags = {}
    vpc_id = "vpc-00fa737d"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 80
        protocol = "tcp"
        to_port = 80
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup6" {
    description = "launch-wizard-2 created 2025-05-15T14:01:16.043Z"
    name = "launch-wizard-2"
    tags = {}
    vpc_id = "vpc-00fa737d"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup7" {
    description = "launch-wizard-6 created 2025-05-19T19:18:16.748Z"
    name = "launch-wizard-6"
    tags = {}
    vpc_id = "vpc-00fa737d"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 80
        protocol = "tcp"
        to_port = 80
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 8080
        protocol = "tcp"
        to_port = 8080
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 3001
        protocol = "tcp"
        to_port = 3001
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 3000
        protocol = "tcp"
        to_port = 3000
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 443
        protocol = "tcp"
        to_port = 443
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup8" {
    description = "Allows docutech-alb-sg"
    name = "docutech-ec2-sg"
    tags = {}
    vpc_id = "vpc-00fa737d"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 8080
        protocol = "tcp"
        to_port = 8080
    }
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup2.id}"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 3000
        protocol = "tcp"
        to_port = 3000
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_key_pair" "EC2KeyPair" {
    public_key = "REPLACEME"
    key_name = "Docutech_EC2"
}

resource "aws_key_pair" "EC2KeyPair2" {
    public_key = "REPLACEME"
    key_name = "opensign"
}

resource "aws_key_pair" "EC2KeyPair3" {
    public_key = "REPLACEME"
    key_name = "Docutech"
}

resource "aws_key_pair" "EC2KeyPair4" {
    public_key = "REPLACEME"
    key_name = "piyush"
}

resource "aws_key_pair" "EC2KeyPair5" {
    public_key = "REPLACEME"
    key_name = "docutech"
}
