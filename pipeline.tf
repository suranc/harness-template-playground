resource "harness_platform_pipeline" "echo_input" {
  identifier = "Echo_Input"
  org_id        = var.org_id
  project_id    = var.project_id
  name       = "Echo Input"
  yaml = <<-EOT
pipeline:
  name: Echo Input
  identifier: Echo_Input
  tags: {}
  template:
    templateRef: Echo_Input_Pipeline
    versionLabel: 1.0.0
    templateInputs:
      stages:
        - stage:
            identifier: Echo_Input
            template:
              templateInputs:
                type: Custom
                spec:
                  execution:
                    steps:
                      - step:
                          identifier: Echo_Input
                          template:
                            templateInputs:
                              type: ShellScript
                              spec:
                                environmentVariables:
                                  - name: input
                                    type: String
                                    value: <+input>
  projectIdentifier: ${var.project_id}
  orgIdentifier: ${var.org_id}
EOT
}
