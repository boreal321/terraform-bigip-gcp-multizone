# Deploy BIG-IP into GCP with Terraform

## GCP Prerequisites

* Create project
* Add Billing
* Ensure the `bigip-terraform-state-bucket` bucket exists for the terraform state files
* Service account with Editor role

```
gcloud config set account vmg@boreal321.com
gcloud projects create f5-gdm-template-testing
gcloud alpha billing projects link f5-gdm-template-testing --billing-account 01BFC5-060B1D-C8D3CB
gsutil mb -l us-east4 gs://bigip-terraform-state-bucket
gcloud iam service-accounts create terraform --project f5-gdm-template-testing
gcloud projects add-iam-policy-binding f5-gdm-template-testing --member serviceAccount:terraform@f5-gdm-template-testing.iam.gserviceaccount.com --role roles/editor
gcloud iam service-accounts keys create credentials.json --iam-account terraform@f5-gdm-template-testing.iam.gserviceaccount.com
```

* Add your SSH keys to the Compute -> Metadata section of the web console

### Credentials
A service account is required to execute the API calls in GCP. The Terraform Google provider accepts a JSON encoded key file for authenticating to GCP. The file `credentials.json` should be located in the root of this build repo.

### Persistent Storage and GCP Instance Scopes

The following scopes are required on all OCP nodes to allow access to create persistent volumes and interact with the docker registry in Google Cloud Storage:

* compute-rw
* storage-rw

## Installation Steps

### Environment Variables

If you want to see everything Terraform is doing and get more verbose output if an error occurs then

`export TF_LOG=TRACE`

### Terraform Variables

Variables need to be edited in the following files:

* variables.tf
* main.tf

### Terraform commands

* `terraform init`
* `terraform plan -out bigp-gcp.plan`
* `terraform apply bigip-gcp.plan`

