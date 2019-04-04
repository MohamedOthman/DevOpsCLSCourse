# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------



variable AWS_ACCESS_KEY_ID { default = "AKIA3JDLJD2E2VV6QAOY" } 
variable AWS_SECRET_ACCESS_KEY { default =  "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" } 

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------


variable "amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-b374d5a5"
    "us-west-2" = "ami-4b32be2b"
  }
}

variable "region" {
  default = "us-east-1"
}


variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}