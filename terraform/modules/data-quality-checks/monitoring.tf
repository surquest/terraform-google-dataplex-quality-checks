locals {

}

resource "google_monitoring_alert_policy" "alert_policies" {

    # Create an alert policy for each QA check that has alert_policy set to true
    for_each = { for k, v in var.QA.checks : k => v if try(v.alert_policy, false) == true }
  
    display_name = "Data QA Scan: ${each.value.bigquery.dataset_id}.${each.value.bigquery.table_id} (${var.ENV}) ${random_string.random_suffix[each.key].result}"
    enabled = true
    severity = "WARNING"
    notification_channels = [
        var.QA.notification_channel
    ]

    alert_strategy {
        auto_close = "604800s"  # 7 days
    }

    combiner     = "OR"
    conditions {
        display_name = "Data QA scans: no failed rule"
        condition_threshold {
            aggregations {
                alignment_period   = "86400s"           # 1 day
                per_series_aligner = "ALIGN_COUNT"      # Count the number of log entries
            }
            comparison = "COMPARISON_GE"
            duration   = "0s"
            filter     = "resource.type = \"dataplex.googleapis.com/DataScan\" AND resource.labels.datascan_id = \"${local.namings[each.key].data_scan_id}\" AND metric.type = \"logging.googleapis.com/log_entry_count\" AND metric.labels.severity = one_of(\"WARNING\")"
            trigger {
                count = 1
            }   
        }
    }

    user_labels = {
        solution = "data-quality-checks"
        environment = var.ENV
    }
}