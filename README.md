# framework-thesis
Develop a framework based on infrastructure as code for developing scalable microservices in cloud environment using container orchestration based technologies

Install the azure cli

Get an azure subscription and generate a service principal to create resources
az login

az ad sp create-for-rbac --name myServicePrincipalName1 --role contributor --scopes /subscriptions/<subscription-id>

It will generate a json like this:

{
  "appId": "************",
  "displayName": ""************",
  "password": "************",
  "tenant": "************"
}

These values map to the Terraform variables like so:

appId is the client_id defined above.
password is the client_secret defined above.
tenant is the tenant_id defined above.

Turn it like this:

{
    "clientSecret":  "<password>",
    "subscriptionId":  "<subscription-id>",
    "tenantId":  "<tenant>",
    "clientId":  "<app-id>"
}

Add the json result as a secret in the github repository called AZURE_CREDENTIALS

Create a Github PAT TOKEN and store it as a secret called PAT_TOKEN
