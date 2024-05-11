# Introduction

This repository contains custom terraform module for deployment of data quality checks for BigQuery tables based on DataPlex service of Google Cloud Platform.
The module is heavily inspired by the [Google DataPlex terraform example](https://github.com/GoogleCloudPlatform/terraform-google-dataplex-auto-data-quality). 

The implementation of the module is designed to be used easily in any infrastructure as code project that uses terraform for Google Cloud Platform.

## Key Features

- **Data Quality Checks**: The module allows you to define data quality checks for one ore more BigQuery tables
- **Results persistance**: The results of the data quality checks are stored in a BigQuery table

# Getting Started

To use the module in your terraform project, you can include the module in your terraform configuration file as follows:

```hcl
module "dataplex_quality_checks" {

    source  = "surquest/dataplex-quality-checks/google"
    version = "0.0.9"
    
    # Google Cloud Platform project configuration 
    GCP = {
        id = "your-gcp-project-id"
        region = "your-gcp-region"
    }
    ENV   = "dev"   # environment slug
    QA = {
        # Specification wher the results of the quality checks will be stored
        result = {
            dataset_id = "adm_quality_assurance"
            table_id   = "quality_checks"
        }
        # Map of quality checks to be executed
        checks = {
            checkIdx1 = {
                # Extra configurations for the quality check
                # sampling_percent = 10 # Percentage of the table to be scanned
                # row_filter = "date >= '2021-01-01'" # Filter to be applied to the table
                rules_specification = "path/to/rules.specification.yaml"   # Path to the check specification file
                execution_spec = {} 
                # Alternative execution specification for scheduled checks
                # execution_spec = {
                #     field = "created_at" # Field to be used for incremental scans
                #     trigger = {
                #         schedule = {
                #             cron = "0 0 * * *"
                #         }
                #     }
                # }
                # BigQuery table to be checked
                bigquery = {
                    dataset_id = "adm_exchange_rates_raw"
                    table_id   = "fx_history"
                }
            }
        }
    }
}
``` 