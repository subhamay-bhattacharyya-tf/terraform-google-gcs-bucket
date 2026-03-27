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

// TestGCSBucketWebsite tests a bucket configured for static website hosting with CORS.
func TestGCSBucketWebsite(t *testing.T) {
	t.Parallel()

	unique := strings.ToLower(random.UniqueId())
	baseName := fmt.Sprintf("gcs-web-%s", unique)

	tfOptions := rootModuleOptions(t, map[string]interface{}{
		"base_name":     baseName,
		"location":      testLocation,
		"force_destroy": true,
		"storage_class": "STANDARD",
		"versioning":    map[string]interface{}{"enabled": false},
		"website": map[string]interface{}{
			"main_page_suffix": "index.html",
			"not_found_page":   "404.html",
		},
		"cors": map[string]interface{}{
			"allow_get": map[string]interface{}{
				"origin":          []string{"https://example.com"},
				"method":          []string{"GET", "HEAD"},
				"response_header": []string{"Content-Type"},
				"max_age_seconds": 3600,
			},
		},
	})

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)
	time.Sleep(5 * time.Second)

	require.Equal(t, expectedBucketName(baseName), terraform.Output(t, tfOptions, "bucket_name"))

	client := newGCSClient(t)
	require.True(t, bucketExists(t, client, expectedBucketName(baseName)))
}
