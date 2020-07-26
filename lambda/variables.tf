variable "source_dir" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "environment_variables" {
  type = map(string)
  default = {
    foo = "bar"
  }
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "function_name" {
  type    = string
  default = ""
}

variable "runtime" {
  type    = string
  default = "nodejs12.x"
}

variable "memory_size" {
  type    = number
  default = 256
}

variable "handler" {
  type    = string
  default = "main.handler"
}

variable "tags" {
  type    = map(string)
  default = {}
}
