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
    naming_patterns = {
        for key, val in var.var.QA.checks : key => {
            
            data_scan_id = replace(
                lower(
                "qa-scan--${each.value.bigquery.dataset_id}-${each.value.bigquery.table_id}--${var.ENV}--${random_string.random_suffix[each.key].result}"
                ),
                "_",
                "-"
            )
            
        }
    }
}