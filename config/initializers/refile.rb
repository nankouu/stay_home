require "refile/s3"

aws = {
  access_key_id: "AWS_ACCESS_KEY_ID",
  secret_access_key: "AWS_SECRET_ACCESS_KEY",
  region: "us-east-2",
  bucket: "samplebacket405",
}
Refile.cache = Refile::S3.new(prefix: "cache", **aws)
Refile.store = Refile::S3.new(prefix: "store", **aws)