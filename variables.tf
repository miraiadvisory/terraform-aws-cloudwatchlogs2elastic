variable "vpc_id" {
  type = string
}

variable "es_endpoint" {
  type = string
}

variable "cwl_endpoint" {
  type = string
  default = "logs.eu-west-1.amazonaws.com"
}

variable "cloudwatch_loggroup_name" {
  type = string
  }

variable "cloudwatch_loggroup_retention" {
  type    = string
  default = 30
}

variable "name" {
  type = string
}

variable "subnets" {
  type = list(string)
}
