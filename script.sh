#!/bin/bash

#This Script is used to create two resources group and two Storage Accounts and one Container in each Storage Account in Azure usnig Azure CLI
RESOURCE_GROUP_NAME=terraform-rg
STORAGE_ACCOUNT_NAME=tfaksstorage
CONTAINER_NAME=tfstate
LOCATION=spaincentral

az group create --name dev-$RESOURCE_GROUP_NAME --location $LOCATION && echo "Created resource group: dev-$RESOURCE_GROUP_NAME"

az group create --name staging-$RESOURCE_GROUP_NAME --location $LOCATION && echo "Created resource group: staging-$RESOURCE_GROUP_NAME"

az storage account create --name dev$STORAGE_ACCOUNT_NAME --resource-group dev-$RESOURCE_GROUP_NAME --allow-blob-public-access true --location $LOCATION --sku Standard_LRS  --encryption-services blob && echo "Created storage account: dev$STORAGE_ACCOUNT"

az storage account create --name staging$STORAGE_ACCOUNT_NAME --resource-group staging-$RESOURCE_GROUP_NAME --allow-blob-public-access true --location $LOCATION --sku Standard_LRS  --encryption-services blob && echo "Created storage account: staging$STORAGE_ACCOUNT"

az storage container create --name dev-$CONTAINER_NAME --account-name dev$STORAGE_ACCOUNT_NAME --public-access blob && echo "Created container: dev-$CONTAINER_NAME"

az storage container create --name staging-$CONTAINER_NAME --account-name staging$STORAGE_ACCOUNT_NAME --public-access blob && echo "Created container: staging-$CONTAINER_NAME"
