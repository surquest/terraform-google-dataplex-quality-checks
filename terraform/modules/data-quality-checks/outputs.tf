output "dataplex_qa_checks" {

    description = "Map of QA checks"
    value = google_dataplex_datascan.qa_checks

}

output "monitoring_alert_policies" {

    description = "Map of monitoring alert policies"
    value = google_monitoring_alert_policy.alert_policies
  
}