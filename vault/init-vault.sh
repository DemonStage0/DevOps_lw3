#!/bin/sh
# Ждём готовности Vault API (а не CLI)
echo "Waiting for Vault API..."
until wget --spider --quiet http://vault:8200/v1/sys/health 2>/dev/null; do
  sleep 2
done

echo "Vault is ready. Logging in..."
export VAULT_ADDR='http://vault:8200'
vault login devops-lw3-root-token

echo "Writing secrets..."
vault kv put secret/db \
  DB_HOST=db \
  DB_PORT=5432 \
  DB_USER=postgres \
  DB_PASS=postgres \
  DB_NAME=glass_db

echo "Vault secrets initialized successfully."