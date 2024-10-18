resource "harness_platform_template" "echo_input_step" {
  identifier    = "Echo_Input"
  org_id        = var.org_id
  project_id    = harness_platform_project.this.id
  name          = "Echo Input"
  comments      = "comments"
  version       = "v1"
  is_stable     = true
  template_yaml = <<-EOT
template:
  name: Echo Input
  identifier: Echo_Input
  versionLabel: v1
  projectIdentifier: ${var.project_id}
  orgIdentifier: ${var.org_id}
  type: Step
  tags: {}
  spec:
    timeout: 10m
    type: ShellScript
    spec:
      shell: Bash
      onDelegate: true
      source:
        type: Inline
        spec:
          script: echo $${input}
      environmentVariables:
        - name: input
          type: String
          value: <+input>
      outputVariables: []
EOT
}

resource "harness_platform_template" "echo_input_stage" {
  name          = "Echo Input Stage"
  identifier    = "Echo_Input_Stage"
  org_id        = var.org_id
  project_id    = harness_platform_project.this.id
  comments      = "comments"
  version       = "v1"
  is_stable     = true
  template_yaml = <<-EOT
template:
  name: Echo Input Stage
  identifier: Echo_Input_Stage
  versionLabel: v1
  projectIdentifier: ${var.project_id}
  orgIdentifier: ${var.org_id}
  type: Stage
  tags: {}
  spec:
    type: Custom
    spec:
      execution:
        steps:
          - step:
              name: Echo Input
              identifier: Echo_Input
              template:
                templateRef: ${harness_platform_template.echo_input_step.id}
                versionLabel: v1
                templateInputs:
                  type: ShellScript
                  spec:
                    environmentVariables:
                      - name: input
                        type: String
                        value: <+input>
EOT
}

resource "harness_platform_template" "echo_input_pipeline" {
  name          = "Echo Input Pipeline"
  identifier    = "Echo_Input_Pipeline"
  org_id        = var.org_id
  project_id    = harness_platform_project.this.id
  comments      = "comments"
  version       = "v1"
  is_stable     = true
  template_yaml = <<-EOT
template:
  name: Echo Input Pipeline
  identifier: Echo_Input_Pipeline
  versionLabel: v1
  projectIdentifier: ${var.project_id}
  orgIdentifier: ${var.org_id}
  type: Pipeline
  tags: {}
  spec:
    stages:
      - stage:
          name: Echo Input
          identifier: Echo_Input
          template:
            templateRef: ${harness_platform_template.echo_input_stage.id}
            versionLabel: v1
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
EOT
}