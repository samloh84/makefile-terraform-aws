variable "owner" {
  type = string
}

variable "project" {
  type = string
}

variable "custom_tags" {
  type = map(string)
  default = {}
}