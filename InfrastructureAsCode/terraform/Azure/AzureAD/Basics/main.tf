resource "azuread_user" "user" {
  user_principal_name = "terraformuser@sandboxcomp.onmicrosoft.com"
  display_name        = "Terraform User"
  mail_nickname       = "terraformuser"
  department          = "HashiCorp"
  password            = "Terraform2022"
  company_name        = "HashiCorp"
}

resource "azuread_group" "group" {
  display_name     = "TerraformAdmin"
  security_enabled = true
}

resource "azuread_group_member" "groupmember" {
  group_object_id  = azuread_group.group.id
  member_object_id = azuread_user.user.id
}