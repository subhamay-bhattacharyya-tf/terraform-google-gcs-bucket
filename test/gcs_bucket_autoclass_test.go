package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestGCSBucketAutoclass tests a bucket with Autoclass storage management enabled.
func TestGCSBucketAutoclass(t *testing.T) {
	t.Parallel()

	unique := strings.ToLower(random.UniqueId())
	baseName := fmt.Sprintf("gcs-ac-%s", unique)

	tfOptions := rootModuleOptions(t, map[string]interface{}{
		"base_name":     baseName,
		"location":      testLocation,
		"force_destroy": true,
		"storage_class": "STANDARD",
		"versioning":    map[string]interface{}{"enabled": false},
		"autoclass": map[string]interface{}{
			"enabled":                true,
			"terminal_storage_class": "ARCHIVE",
		},
	})

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)
	time.Sleep(5 * time.Second)

	require.Equal(t, expectedBucketName(baseName), terraform.Output(t, tfOptions, "bucket_name"))

	client := newGCSClient(t)
	attrs := fetchBucketAttrs(t, client, expectedBucketName(baseName))
	require.True(t, attrs.Autoclass.Enabled)
}
