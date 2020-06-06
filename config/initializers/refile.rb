require "refile/s3"

aws = {
  access_key_id: 'AKIA2OCGFRDX4MRDBOSN',
  secret_access_key: 'fxFtxlh937gAGG3yu/N5Sgze3aqCh9D2Z3w9Zjjf',
  region: "us-east-2",
  bucket: "samplebacket405",
}
Refile.cache = Refile::S3.new(prefix: "cache", **aws)
Refile.store = Refile::S3.new(prefix: "store", **aws)