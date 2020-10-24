resource "aws_iam_instance_profile" "server_instance_profile" {
  name = "server-profile"
  role = aws_iam_role.server_iam_role.name
}

data "aws_iam_policy_document" "allow_ec2_to_assume_roles" {
    statement {
        actions = [
            "sts:AssumeRole"
        ]

        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "server_iam_role" {
  name = "vpn-server-role"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.allow_ec2_to_assume_roles.json
}

# resource "aws_iam_role_policy_attachment" "server_privileges" {
#     role = aws_iam_role.server_iam_role.name
#     policy_arn = aws_iam_role_policy.server_privileges.arn
# }

resource "aws_iam_role_policy" "server_privileges" {
  name        = "vpn-server-privileges"
#   path        = "/"
  policy = data.aws_iam_policy_document.server_privileges.json
  role = aws_iam_role.server_iam_role.name
}

data "aws_iam_policy_document" "server_privileges" {
  statement {
    sid = "1"

    effect = "Allow"

    actions = [
        "ssm:DescribeAssociation",
        "ssm:GetDeployablePatchSnapshotForInstance",
        "ssm:GetDocument",
        "ssm:DescribeDocument",
        "ssm:GetManifest",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:ListAssociations",
        "ssm:ListInstanceAssociations",
        "ssm:PutInventory",
        "ssm:PutComplianceItems",
        "ssm:PutConfigurePackageResult",
        "ssm:UpdateAssociationStatus",
        "ssm:UpdateInstanceAssociationStatus",
        "ssm:UpdateInstanceInformation"
    ]

    resources = [
      "*"
    ]
  }

   statement {

       sid = 2
     effect =  "Allow"
      actions = [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ]
            resources = ["*"]
        }

         statement {
            effect = "Allow"
            actions = [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ]
            resources = ["*"]
        }
}

resource "aws_eip" "public_ip" {
  instance = aws_instance.vpn.id
  vpc      = true
}

output "public_ip" {
  value = aws_eip.public_ip.public_ip
}

data "aws_ami" "amazonlinux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "vpn" {
  ami           = data.aws_ami.amazonlinux.id
  instance_type = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.server_instance_profile.id

  tags = {
    Name = "wiregaurd-vpn"
  }
}

output "instance_id" {
  value = aws_instance.vpn.id
}
