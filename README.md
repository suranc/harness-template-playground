# Harness Template Sandbox

## Introduction

The following tutorial will walk you through how to best use versioning in Harness Templates to manage releases.  

## Prerequisites

* OpenTofu/Terraform
* A Harness API Token

In the `tf` directory, copy the `example.terraform.tfvars` file to `terraform.tfvars` and fill in all the values.  Then apply the tutorial project with `tofu init && tofu apply`

## Using Harness Template Versioning

Harness Templates allow for teams to maintain reusable solutions for steps, stage configurations and even entire pipelines.  This provides great value in a central place to govern pipeline contents, and to easily push updates and improvements to multiple app teams at once.

However, this central point of control also creates a central point of failure, so it's important to manage how these changes get released.  To best accomplish this, chagnes can be broken down into two categories.  Breaking changes, and non breaking changes.

### Non Breaking Changes

Non breaking changes can be defined by any change that can be transparently pushed to end  users.  Such as basic bug fixes or minor improvements, which can be safely consumed by the end users without any action on their part.  

### Breaking Changes

Breaking changes can be defined by anything that would require action the part of the end user.  This also includes adding runtime inputs to a template, as well as changing the runtime inputs to a template.  

## Using Template Versioning to manage these changes

The templates in our example are built to the guide in the Harness documentation here: https://developer.harness.io/docs/continuous-delivery/cd-onboarding/new-user/rampup-templates/#template-development-and-release-lifecycle

In the following workshop, we'll look at releasing a non breaking and a breaking change, and see what happens when we release a breaking change the wrong way (as well as the right way).

### Exercise 1: Releasing a non-breaking change

For our first exercise, we'll create a small change to the step template, save it over the same `v1` version the template is using, and see what happens.

* Navigate to the templates in "Project Settings"->"Templates"
* Select the step template "Echo Input" and click to open in the template studio.
* Add a line under the first echo to run `echo test`
* Click "Save" and save this update to `v1`

Now, navigate to the "Echo Input" pipeline in the project, and run the pipeline.  What do you see? Is the new change picked up?

### Exercise 2: Releasing a breaking change under a new version

Navigate to the same "Echo Input" step template, but this time lets add a new variable that takes a runtime input

* Navigate to the "Echo Input" step template
* Click "Optional Configuration" at the bottom of the step template
* Add a second Input Variable called "input2" and set the value to "Runtime Input"
* Add a third line to the shell script contents to echo this input (`echo ${input2}`)
* Click the down arrow directly next to the "Save" button, and select "Save as new version"
* Save this change under the version `v2`

Now run the "Echo input" pipeline again.  Do you see this change?

### Exercise 3: Updating the stage template to consume this new version

Now we have to update our stage template to use this new version of the step template.

* Navigate to the project level stage template "Echo Input Stage" in the template studio
* Click on the "Echo Input" step
* In the blue bar that says "Using template: Echo Input" select `v2` from the dropdown.
* You'll see the inputs are updated to include a second parameter `input2`.  Change the value to "Fixed Value" and set the value to be "output2".
* Click "Apply Changes" on the template menu, and then save the stage template under the same version `v1`

Give the "Echo Input" pipeline another run.  The change in `v2` is to add a third line to output the string "output2".  Do you see this new behavior?  Was there any disruption when you went to run this pipeline?

*Bonus question* If we had not changed the value of the new input parameter in the step template to "fixed" when we updated the version used by the stage template, would this have been a breaking change?  How would you have handled releasing this if you needed to keep this as a runtime input in the stage template, just like the first `input` parameter is set to?

### Exercise 4: Releasing a breaking change the "wrong" way (without updating the version)

To see what happens when we do not follow the above versioning strategy, lets make a breaking change to a template but save it under the same veersion.  To do that, we'll add another input parameter to the step like we did last time, but this time lets save it under the same version and see what happens.

* Navigate to the "Echo Input" step template
* Click "Optional Configuration" at the bottom of the step template
* Add a third Input Variable called "input3" and set the value to "Runtime Input"
* Add a third line to the shell script contents to echo this input (`echo From input3: ${input3}`)
* Click "Save" to save this change under the same `v2` as before.

Now go back to the "Echo Input" pipeline and what do you see?  Skip clicking "Reconcile" for now, and run the pipeline.  Are you able to run it with no disruption?  Do you see any change the console output from the step?  Are you able to use the new functionality to add a second input parameter that will get echoed in the 4th line?

Now click "Reconcile" in the pipeline and add the changes from the menu.  What do you see?  Are you actually able to save and use the new changes?  
