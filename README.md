# framework-thesis
Develop a framework based on infrastructure as code for developing scalable microservices in cloud environment using container orchestration based technologies

Install the azure cli

Get an azure subscription and generate a service principal to create resources
az login
az ad sp create-for-rbac
Add the json result as a secret in the github repository called AZURE_CREDENTIALS