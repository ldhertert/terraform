This module performs the initial setup of an Azure account so that it can be added to Harness as a cloud provider connector.
Custom roles that are required for various Harness functionality within azure are also created, and are bound to the Harness
user in Azure.

This also creates a secret in Harness that contains the azure client secret.  To view the output you can run `terraform output`.
In order to see the client secret, you can run the following commands:


```
HARNESS_PLATFORM_API_KEY='...'
ENDPOINT="https://app.harness.io/gateway"
ACCOUNT_ID="KaZNXe69Qzm8KOo8bGCwwg"
ORG_ID="default"
PROJECT_ID="Default"

CONNECTOR_NAME="New Azure Connector"
CONNECTOR_ID="new_azure_connector"

template='{"connector":{"name":$name,"identifier":$id,"orgIdentifier":$org,"projectIdentifier":$proj,"type":"Azure","spec":{"azureEnvironmentType":"AZURE","executeOnDelegate":false,"credential":{"type":"ManualConfig","spec":{"applicationId":$appId,"tenantId":$tenantId,"auth":{"type":"Secret","spec":{"secretRef":$secretRef}}}}}}}'

body=$(jq --null-input \
  --arg name "$CONNECTOR_NAME" \
  --arg id "$CONNECTOR_ID" \
  --arg appId "$(terraform output -raw application_id)" \
  --arg org "$ORG_ID" \
  --arg proj "$PROJECT_ID" \
  --arg tenantId "$(terraform output -raw tenant_id)" \
  --arg secretRef "account.$(terraform output -raw secretId)" \
  $template | jq -c)



curl -i -X POST "${ENDPOINT}/ng/api/connectors?accountIdentifier=$ACCOUNT_ID" \
  -H 'Content-Type: text/yaml' \
  -H "x-api-key: $HARNESS_PLATFORM_API_KEY" \
  -d $body

```