variable "development_email" {
  type        = string
  description = "Email Address used for the Development Account in AWS Organizations"
}

variable "uat_email" {
  type        = string
  description = "Email Address used for the UAT Account in AWS Organizations"
}

variable "production_email" {
  type        = string
  description = "Email Address used for the Production Account in AWS Organizations"
}