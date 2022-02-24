resource aws_iam_user "user" {
    for_each = var.user_vars
    name     = each.value.user
}

resource "aws_iam_access_key" "user_key" {
    for_each = var.user_vars
    user     = each.value.user
    depends_on = [
      aws_iam_user.user
    ]
}

data "template_file" "iam_user_a_access_role_policy" {
    template = file("policies/user_a_policy.json")
}

data "template_file" "iam_user_b_access_role_policy" {
    template = file("policies/user_b_policy.json")
}

resource "aws_iam_user_policy" "user_a_policy" {
    user     = var.user_vars.user-a.user
    policy   = data.template_file.iam_user_a_access_role_policy.rendered
    depends_on = [
      aws_iam_user.user
    ]
}

resource "aws_iam_user_policy" "user_b_policy" {
    user     = var.user_vars.user-a.user
    policy   = data.template_file.iam_user_b_access_role_policy.rendered
    depends_on = [
      aws_iam_user.user
    ]
}
