variable "project" {
  type= string
  description = "This defines the name of the project"
}

variable "environment" {
  type= string
  description = "This defines the name of the environment"
}

variable "region" {
  type= string
  description = "This defines the name of region"
}


variable "domain" {
  type= string
  description = "This defines the name of this domain name"
}

variable "zone_id" {
  type= string
  description = "This defines the name of zone id"
}

variable "ec2_instance_type" {
  type= string
  description = "This defines type of EC2 instance"
}

variable "ami_id" {
  type= string
  description = "This defines id of ec2 AMI(AmazonLinux Server)"
}

variable "iam_arn" {
  type= string
  description = "This defines role arn"
}

variable "select_network" {
  type= number
  description = "This variable can select network count 0 or 1"
}

variable "not_select_network" {
  type= number
  description = "This variable can not select network count 0 or 1"
}



