#!/bin/bash

# ==== REQUIRED VALUES ==========================
ORG="GovTechCloud"
REPO="infra"
ENV="production"
APP_NAME="github-oidc-$REPO"
ROLE="Contributor"
# ===============================================

SUBJECT="repo:${ORG}/${REPO}:environment:${ENV}"

echo "Creating App Registration..."
APP_ID=$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)

echo "Creating Service Principal..."
az ad sp create --id "$APP_ID" --only-show-errors

TENANT_ID=$(az account show --query tenantId -o tsv)
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

echo "Adding Federated Credential..."
az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters "{
      \"name\": \"github-oidc-production\",
      \"issuer\": \"https://token.actions.githubusercontent.com\",
      \"subject\": \"${SUBJECT}\",
      \"audiences\": [\"api://AzureADTokenExchange\"]
  }"

echo "Assigning subscription role..."
az role assignment create \
  --assignee "$APP_ID" \
  --role "$ROLE" \
  --scope "/subscriptions/$SUBSCRIPTION_ID"

echo ""
echo "======= COPY THESE TO GITHUB SECRETS ======="
echo "AZURE_CLIENT_ID=$APP_ID"
echo "AZURE_TENANT_ID=$TENANT_ID"
echo "AZURE_SUBSCRIPTION_ID=$SUBSCRIPTION_ID"
echo "============================================"
