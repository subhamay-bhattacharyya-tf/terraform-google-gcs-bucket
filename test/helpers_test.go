// File: test/helpers_test.go
package test

import (
	"context"
	"fmt"
	"os"
	"strings"
	"testing"

	"cloud.google.com/go/storage"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
	"google.golang.org/api/iterator"
)

// Shared test constants.
const (
	testProjectCode = "tt"
	testEnvironment = "devl"
	testLocation    = "US"
	testRegion      = "us-central1"
)

// expectedBucketName returns the deterministic bucket name for a given base name.
func expectedBucketName(baseName string) string {
	return fmt.Sprintf("%s-%s-%s-%s", testProjectCode, baseName, strings.ToLower(testLocation), testEnvironment)
}

// rootModuleOptions builds Terraform options pointing at the root module.
func rootModuleOptions(t *testing.T, gcsConfig map[string]interface{}) *terraform.Options {
	t.Helper()
	return &terraform.Options{
		TerraformDir: "..",
		NoColor:      true,
		Vars: map[string]interface{}{
			"environment":  testEnvironment,
			"project_code": testProjectCode,
			"project_id":   mustEnv(t, "GOOGLE_CLOUD_PROJECT"),
			"region":       testRegion,
			"gcs_config":   gcsConfig,
		},
	}
}

// mustEnv retrieves a required environment variable, failing the test if absent.
func mustEnv(t *testing.T, key string) string {
	t.Helper()
	v := strings.TrimSpace(os.Getenv(key))
	require.NotEmpty(t, v, "Missing required environment variable %s", key)
	return v
}

// newGCSClient creates an authenticated GCS client.
func newGCSClient(t *testing.T) *storage.Client {
	t.Helper()
	ctx := context.Background()
	client, err := storage.NewClient(ctx)
	require.NoError(t, err, "Failed to create GCS client")
	return client
}

// bucketExists reports whether the named bucket is accessible.
func bucketExists(t *testing.T, client *storage.Client, bucketName string) bool {
	t.Helper()
	ctx := context.Background()
	_, err := client.Bucket(bucketName).Attrs(ctx)
	return err == nil
}

// fetchBucketAttrs returns the GCS BucketAttrs for the named bucket.
func fetchBucketAttrs(t *testing.T, client *storage.Client, bucketName string) *storage.BucketAttrs {
	t.Helper()
	ctx := context.Background()
	attrs, err := client.Bucket(bucketName).Attrs(ctx)
	require.NoError(t, err, "Failed to get bucket attributes for %s", bucketName)
	return attrs
}

// listBucketObjects returns the object keys in the named bucket.
func listBucketObjects(t *testing.T, client *storage.Client, bucketName string) []string {
	t.Helper()
	ctx := context.Background()
	var keys []string
	it := client.Bucket(bucketName).Objects(ctx, nil)
	for {
		obj, err := it.Next()
		if err == iterator.Done {
			break
		}
		require.NoError(t, err, "Failed to list objects in bucket %s", bucketName)
		keys = append(keys, obj.Name)
	}
	return keys
}

func stringPtr(s string) *string {
	return &s
}
