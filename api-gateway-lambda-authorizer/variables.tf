variable "lambda_arn" {
  type = string
}

variable "rest_api_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "ttl_in_seconds" {
  type    = number
  default = 0
}
