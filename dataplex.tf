resource "google_dataplex_datascan" "qa_checks" {

  for_each = var.QA.checks

  location = var.GCP.region
  data_scan_id = local.namings[each.key].data_scan_id

  labels = {
    environment = lower(var.ENV)
    solution    = "data-quality-checks"
  }

  data {
    resource = "//bigquery.googleapis.com/projects/${var.GCP.id}/datasets/${each.value.bigquery.dataset_id}/tables/${each.value.bigquery.table_id}"
  }

  # Define the execution spec for the data scan
  # if the var.QA.trigger is not provided, the scan will be run on-demand
  # else, the scan will be scheduled to run at the specified interval

  execution_spec {
    field = try(each.value.execution_spec.field, null)

    dynamic "trigger" {
      for_each = [each.value.execution_spec.trigger]
      content {
        dynamic "schedule" {
          for_each = try(each.value.execution_spec.trigger, null) != null ? [each.value.execution_spec.trigger.schedule.cron] : []
          content {
            cron = trigger.value.schedule.cron
          }
        }
        dynamic "on_demand" {
          for_each = try(each.value.execution_spec.trigger, null) == null ? [""] : []
          content {}
        }
      }
    }
  }

  # Custom logic to parse out rules metadata from a local rules.yaml file
  data_quality_spec {

    sampling_percent = try(each.value.sampling_percent, null)
    row_filter       = try(each.value.row_filter, null)

    post_scan_actions {
      bigquery_export {
        results_table = "//bigquery.googleapis.com/projects/${var.GCP.id}/datasets/${var.QA.result.dataset_id}/tables/${var.QA.result.table_id}"
      }
    }

    dynamic "rules" {
      for_each = local.checks[each.key].rules
      content {
        column      = try(rules.value.column, null)
        ignore_null = try(rules.value.ignore_null, null)
        dimension   = rules.value.dimension
        description = try(rules.value.description, null)
        name        = try(rules.value.name, null)
        threshold   = try(rules.value.threshold, null)

        dynamic "non_null_expectation" {
          for_each = try(rules.value.non_null_expectation, null) != null ? [""] : []
          content {
          }
        }

        dynamic "range_expectation" {
          for_each = try(rules.value.range_expectation, null) != null ? [""] : []
          content {
            min_value          = try(rules.value.range_expectation.min_value, null)
            max_value          = try(rules.value.range_expectation.max_value, null)
            strict_min_enabled = try(rules.value.range_expectation.strict_min_enabled, null)
            strict_max_enabled = try(rules.value.range_expectation.strict_max_enabled, null)
          }
        }

        dynamic "set_expectation" {
          for_each = try(rules.value.set_expectation, null) != null ? [""] : []
          content {
            values = rules.value.set_expectation.values
          }
        }

        dynamic "uniqueness_expectation" {
          for_each = try(rules.value.uniqueness_expectation, null) != null ? [""] : []
          content {
          }
        }

        dynamic "regex_expectation" {
          for_each = try(rules.value.regex_expectation, null) != null ? [""] : []
          content {
            regex = rules.value.regex_expectation.regex
          }
        }

        dynamic "statistic_range_expectation" {
          for_each = try(rules.value.statistic_range_expectation, null) != null ? [""] : []
          content {
            min_value          = try(rules.value.statistic_range_expectation.min_value, null)
            max_value          = try(rules.value.statistic_range_expectation.max_value, null)
            strict_min_enabled = try(rules.value.statistic_range_expectation.strict_min_enabled, null)
            strict_max_enabled = try(rules.value.statistic_range_expectation.strict_max_enabled, null)
            statistic          = rules.value.statistic_range_expectation.statistic
          }
        }

        dynamic "row_condition_expectation" {
          for_each = try(rules.value.row_condition_expectation, null) != null ? [""] : []
          content {
            sql_expression = rules.value.row_condition_expectation.sql_expression
          }
        }

        dynamic "table_condition_expectation" {
          for_each = try(rules.value.table_condition_expectation, null) != null ? [""] : []
          content {
            sql_expression = rules.value.table_condition_expectation.sql_expression
          }
        }

      }
    }
  }

  project = var.GCP.id

}
