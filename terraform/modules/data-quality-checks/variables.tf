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
    result = object({
      dataset_id = string
      table_id   = string
    })
    checks = map(
      object({
        sampling_percent = optional(number) # Percentage of the table to be scanned
        row_filter       = optional(string) # SQL filter to be applied to the table before scanning
        # Path to the YAML file containing the QA rules
        checks_specification = string
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
