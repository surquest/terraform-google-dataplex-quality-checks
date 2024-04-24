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
module "data_quality_checks" {
    source = "git@github.com:surquest/terraform-google-dataplex-quality-checks.git//terraform/modules/data-quality-checks"
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
                checks_specification = "path/to/check.specification.yaml"   # Path to the check specification file
                execution_spec = {} 
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