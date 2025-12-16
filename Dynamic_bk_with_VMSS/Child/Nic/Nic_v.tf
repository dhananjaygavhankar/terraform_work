 variable "subnets" {
  description = "A map of subnets to be created."
  type = map(object({
    name = string
    cidr = string
  }))
}
variable "rg_name" {
  type = string
}
variable "location_rg" {
  type = string
}
variable "vnet_name" {
  type = string
    }
variable "subnet_output_map" {
    type = map(string)
}