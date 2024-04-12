resource "harness_platform_pipeline" "echo_input" {
  identifier = "Echo_Input"
  org_id        = var.org_id
  project_id    = harness_platform_project.this.id
  name       = "Echo Input"
  yaml = <<-EOT
pipeline:
  name: Echo Input
  identifier: Echo_Input
  tags: {}
  template:
    templateRef: ${harness_platform_template.echo_input_pipeline.id}
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
  projectIdentifier: ${harness_platform_project.this.id}
  orgIdentifier: ${var.org_id}
EOT
}
