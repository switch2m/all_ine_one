terraform {

}


variable "ports" {
  type    = list(number)
  default = [1, 4, 6]
}

output "sum" {
  value = sum(var.ports)
}
output "max" {
  value = max(var.ports...)
}
output "min" {
  value = min(var.ports...)
}

