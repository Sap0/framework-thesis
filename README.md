# framework-thesis

## Overview
This project provides a framework based on Infrastructure as Code (IaC) for developing scalable microservices in a cloud environment using container orchestration technologies. The framework leverages Azure, Kubernetes, and GitHub Actions to automate the deployment and management of cloud resources.

## Prerequisites
Before setting up the framework, ensure you have the following:
- An [Azure subscription](https://azure.microsoft.com/en-us/free/)
- The [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed on your local machine
- A [GitHub account](https://github.com/)

## Setup Instructions
### 1. Install Azure CLI
Ensure you have Azure CLI installed. If not, install it by following the official guide [here](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).

### 2. Authenticate with Azure
Login to your Azure account:
```sh
az login
```

### 3. Create a Service Principal
Generate a Service Principal to create and manage resources:
```sh
az ad sp create-for-rbac --name myServicePrincipalNameOwner --role owner --scopes /subscriptions/<subscription-id>
```
This command will generate a JSON output similar to the following:
```json
{
  "appId": "************",
  "displayName": "************",
  "password": "************",
  "tenant": "************"
}
```

### 4. Map Azure Credentials to Terraform Variables
The values from the generated JSON should be mapped to Terraform variables as follows:
```json
{
    "clientSecret":  "<password>",
    "subscriptionId":  "<subscription-id>",
    "tenantId":  "<tenant>",
    "clientId":  "<app-id>"
}
```

### 5. Add Azure Credentials as a GitHub Secret
Store the generated JSON as a secret in your GitHub repository:
1. Navigate to your repository on GitHub.
2. Go to **Settings** > **Secrets and variables** > **Actions**.
3. Click **New repository secret**.
4. Name the secret `AZURE_CREDENTIALS`.
5. Paste the JSON content and save it.

### 6. Create a GitHub PAT Token
A GitHub Personal Access Token (PAT) is required for repository authentication:
1. Go to [GitHub Personal Access Tokens](https://github.com/settings/tokens).
2. Generate a new token with the required scopes.
3. Store the token as a secret in your repository:
   - **Secret name**: `PAT_TOKEN`
   - **Secret value**: Your generated token

## Next Steps
Once the setup is complete, every time you push to the `main` branch, a GitHub Action will be triggered to:
- Deploy an Azure Kubernetes Service (AKS) cluster using Terraform
- Install an Nginx Ingress Controller to Kubernetes cluster using Helm
- Build a Frontend Docker image and push it to a container registry
- Build a Backend Docker image and push it to a container registry
- Deploy a Kubernetes application made of the two images previously built to the cluster, making it accessible from the internet
