# -------AWS provider ---------

provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      project     = "secure-microservice"
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }
}
