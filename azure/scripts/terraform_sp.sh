#!/bin/bash

# Create the Service Principal
sp_output=$(az ad sp create-for-rbac --name "terraform-sp" --role Contributor --scopes /subscriptions/$(az account show --query "id" -o tsv) --sdk-auth)

# Parse the JSON output and extract required values
client_id=$(echo $sp_output | jq -r '.clientId')
client_secret=$(echo $sp_output | jq -r '.clientSecret')
tenant_id=$(echo $sp_output | jq -r '.tenantId')
subscription_id=$(az account show --query "id" -o tsv)

# Output the environment variables for Terraform Cloud
echo "Set the following environment variables in Terraform Cloud:"
echo "ARM_CLIENT_ID = $client_id"
echo "ARM_CLIENT_SECRET = $client_secret"
echo "ARM_SUBSCRIPTION_ID = $subscription_id"
echo "ARM_TENANT_ID = $tenant_id"
