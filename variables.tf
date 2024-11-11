variable "GCP" {

  description = "Google Cloud Platform project configuration details"

  type = object({
    id     = string
    region = string
  })

  validation {
    condition     = length(var.GCP.id) > 0 && length(var.GCP.region) > 0
    error_message = "The GCP variable must have non-empty values for id, region."
  }

}

variable "ENV" {

  description = "Environment configuration details (DEV/TEST/STG/UAT/PROD)"
  type        = string
  validation {
    condition     = contains(["DEV", "TEST", "STG", "UAT", "PROD"], var.ENV)
    error_message = "The ENV variable must be 'DEV', 'TEST', 'STG', 'UAT', or 'PROD'."
  }

}

variable "QA" {

  description = "Collection of Quality Assurance checks to be run on the BigQuery table"

  type = object({
    
    # Notification channel to be used for alerting: syntax: projects/[PROJECT_ID]/notificationChannels/[CHANNEL_ID]
    notification_channel = optional(string)
    
    # Identification of the BigQuery table to store the QA results
    result = object({
      dataset_id = string
      table_id   = string
    })
    
    checks = map(
      object({
        alert_policy_enabled = optional(bool)       # Flag to enable alerting for the QA checks
        sampling_percent = optional(number) # Percentage of the table to be scanned
        row_filter       = optional(string) # SQL filter to be applied to the table before scanning
        
        # Path to the YAML file containing the QA rules
        rules_specification = string
        data_scan_id        = optional(string) # Unique identifier for the QA scan
        
        # Identification of the BigQuery table to be scanned
        bigquery = object({
          dataset_id = string
          table_id   = string
        })
        
        # Optional schedule for the QA checks (if not provided, the checks will be run on-demand)
        execution_spec = object({
          field = optional(string) # Field to be used for incremental scans
          trigger = optional(
            object({
              schedule = object({
                cron = string
              })
            })
          )
        })
      })
    )

  })
  
}
