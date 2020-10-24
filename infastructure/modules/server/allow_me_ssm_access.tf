data "aws_caller_identity" "current" {}
# This does not return username...

data "aws_iam_user" "known_user_name" {
    user_name = "macos"
    # cannot look up based on anything returned by data.aws_caller_identity.current
}

resource "aws_iam_user_policy" "allow_current_user_ssm_to_vpn" {
  name = "allow-ssm-to-vpn-server"
  user = "macos"
  policy = data.aws_iam_policy_document.allow_access_to_vpn_server.json
}

data "aws_iam_policy_document" "allow_access_to_vpn_server" {
    statement {
    
            effect = "Allow"
            actions = [
                "ssm:StartSession"
            ]
            resources = [
               aws_instance.vpn.arn
            ]
        }
       statement  {
            effect = "Allow"
            actions = [
                "ssm:TerminateSession"
            ]
            resources = [
                "arn:aws:ssm:*:*:session/*"
            ]
        }
}
