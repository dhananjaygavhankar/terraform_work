variable "pip_name" {
  type = string
}

variable "rg_name" {
  type = string
}
variable "location_rg" {
  type = string
}
variable "subnets" {
  type = map(object({
    name = string
    cidr = string
  }))
}