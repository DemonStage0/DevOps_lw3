#!/bin/sh
echo "Waiting for Vault API..."
until wget --spider --quiet http://vault:8200/v1/sys/health 2>/dev/null; do
  sleep 2
done

echo "Vault is ready. Setting VAULT_ADDR..."
export VAULT_ADDR='http://vault:8200'

echo "Logging in with root token..."
echo "devops-lw3-root-token" | vault login - 2>&1 || exit 1

echo "Enabling KV v2 secrets engine..."
vault secrets enable -path=secret kv-v2 2>/dev/null || true

echo "Writing secrets..."
vault kv put secret/db \
  DB_HOST=db \
  DB_PORT=5432 \
  DB_USER=postgres \
  DB_PASS=postgres \
  DB_NAME=glass_db || exit 1

echo "Vault secrets initialized successfully."