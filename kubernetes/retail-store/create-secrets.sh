#!/bin/bash
set -e
NAMESPACE="retail-app"
REGION="us-east-1"

echo "Creating MySQL secret..."
MYSQL_SECRET=$(aws secretsmanager get-secret-value \
  --secret-id "project-bedrock/mysql-credentials" \
  --region "$REGION" \
  --query SecretString \
  --output text)

kubectl create secret generic mysql-credentials \
  --namespace="$NAMESPACE" \
  --from-literal=host=$(echo $MYSQL_SECRET | python3 -c "import sys,json; print(json.load(sys.stdin)['host'])") \
  --from-literal=username=$(echo $MYSQL_SECRET | python3 -c "import sys,json; print(json.load(sys.stdin)['username'])") \
  --from-literal=password=$(echo $MYSQL_SECRET | python3 -c "import sys,json; print(json.load(sys.stdin)['password'])") \
  --from-literal=dbname=$(echo $MYSQL_SECRET | python3 -c "import sys,json; print(json.load(sys.stdin)['dbname'])") \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Creating PostgreSQL secret..."
PG_SECRET=$(aws secretsmanager get-secret-value \
  --secret-id "project-bedrock/postgres-credentials" \
  --region "$REGION" \
  --query SecretString \
  --output text)

kubectl create secret generic postgres-credentials \
  --namespace="$NAMESPACE" \
  --from-literal=host=$(echo $PG_SECRET | python3 -c "import sys,json; print(json.load(sys.stdin)['host'])") \
  --from-literal=username=$(echo $PG_SECRET | python3 -c "import sys,json; print(json.load(sys.stdin)['username'])") \
  --from-literal=password=$(echo $PG_SECRET | python3 -c "import sys,json; print(json.load(sys.stdin)['password'])") \
  --from-literal=dbname=$(echo $PG_SECRET | python3 -c "import sys,json; print(json.load(sys.stdin)['dbname'])") \
  --dry-run=client -o yaml | kubectl apply -f -

echo "All secrets created successfully!"
