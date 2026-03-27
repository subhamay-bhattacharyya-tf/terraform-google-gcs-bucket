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

// TestGCSBucketLifecycle tests a bucket with lifecycle transition and expiry rules.
func TestGCSBucketLifecycle(t *testing.T) {
	t.Parallel()

	unique := strings.ToLower(random.UniqueId())
	baseName := fmt.Sprintf("gcs-lc-%s", unique)

	tfOptions := rootModuleOptions(t, map[string]interface{}{
		"base_name":     baseName,
		"location":      testLocation,
		"force_destroy": true,
		"storage_class": "STANDARD",
		"versioning":    map[string]interface{}{"enabled": true},
		"lifecycle_rule": []interface{}{
			map[string]interface{}{
				"action":    map[string]interface{}{"type": "Delete"},
				"condition": map[string]interface{}{"age": 365},
			},
		},
	})

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)
	time.Sleep(5 * time.Second)

	require.Equal(t, expectedBucketName(baseName), terraform.Output(t, tfOptions, "bucket_name"))

	client := newGCSClient(t)
	attrs := fetchBucketAttrs(t, client, expectedBucketName(baseName))
	require.Len(t, attrs.Lifecycle.Rules, 1)
	require.Equal(t, "Delete", attrs.Lifecycle.Rules[0].Action.Type)
}
