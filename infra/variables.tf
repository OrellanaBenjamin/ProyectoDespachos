variable "aws_region" {
  description = "Región de AWS"
  default     = "us-east-1" # Cambia esto si usas otra región
}

variable "instance_type" {
  description = "Tipo de instancia gratuita de AWS"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Ubuntu Server 22.04 LTS (Asegúrate de que este ID sea válido en tu región)"
  default     = "ami-0e001c9271cf7f3b9" # Ubuntu 22.04 en us-east-1
}

variable "key_name" {
  description = "Nombre de tu par de claves (.pem) de AWS"
  default     = "vockey" 
}
 
variable "key_pair_name" {}
variable "db_password" {}
variable "db_name" {}