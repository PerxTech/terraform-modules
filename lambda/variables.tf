variable "source_dir" {
  type = string
}

variable "environment_variables" {
  type    = map(string)
  default = null
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

variable "timeout" {
  type    = number
  default = 3
}

variable "enable" {
  type    = bool
  default = true
}

variable "use_unique_suffix" {
  type    = bool
  default = true
}

variable "alarm_sns_topic" {
  type    = string
  default = null
}