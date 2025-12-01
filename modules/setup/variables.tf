variable "daily_limit" {
    type = string
    description = "Defines the daily limit for cost alerting"    
}

variable "daily_threshold" {
    type = number
    description = "Defines the daily threshold for cost alerting"    
}

variable "monthly_limit" {
    type = string
    description = "Defines the monthly limit for cost alerting"    
}

variable "monthly_threshold" {
    type = number
    description = "Defines the monthly threshold for cost alerting"    
}

variable "budget_notification_email" {
  type        = string
  description = "Email Address Required for Budget/Billing Notifications"
}
