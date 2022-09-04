#create aws users and update password later
resource "aws_iam_user" "testadminuser1" {
  name = "admin1"
}

resource "aws_iam_user" "testadminuser2" {
  name = "admin2"
}

#create aws group
resource "aws_iam_group" "admingroup" {
  name = "admingroup"
}

#add user to the group
resource "aws_iam_group_membership" "adminteam" {
  name = "tf-testing-group-membership"

  users = [
    aws_iam_user.testadminuser1.name,
    aws_iam_user.testadminuser2.name,
  ]

  group = aws_iam_group.admingroup.name
}