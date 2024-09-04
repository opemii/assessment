# Create new storage bucket in the US
# location with Standard Storage

resource "google_storage_bucket" "static" {
 name          = "BUCKET_NAME"
 location      = "US-CENTRAL1"
 storage_class = "STANDARD"

 uniform_bucket_level_access = true
}