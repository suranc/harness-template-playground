resource "harness_platform_project" "this" {
  org_id     = var.org_id
  identifier = var.project_id
  name       = var.project_id
}