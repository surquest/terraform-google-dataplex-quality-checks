# Random suffix for the resource name
resource "random_string" "random_suffix" {

  for_each = var.QA.checks

  length  = 4
  special = false
  upper   = false
  numeric = false
  lower   = true
}

locals {
    namings = {
        for key, val in var.QA.checks : key => {
            
            data_scan_id = coalesce(
                try(val.data_scan_id), # Use the provided data_scan_id if available
                replace( # Otherwise, generate a data_scan_id based on the dataset and table names
                    lower(
                    "qa-scan--${val.bigquery.dataset_id}-${val.bigquery.table_id}--${var.ENV}--${random_string.random_suffix[key].result}"
                    ),
                    "_",
                    "-"
                )
            )
            
        }
    }
}