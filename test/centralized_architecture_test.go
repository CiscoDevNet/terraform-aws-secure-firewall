package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesBasic(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/gwlb_centralized_architecture",
		VarFiles:     []string{"terraform.tfvars"},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
