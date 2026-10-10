resource "vault_database_secret_backend_role" "quote_service" {
  backend = "database"
  name    = "quote-service"
  db_name = "quote-postgres"

  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT SELECT, INSERT, UPDATE ON quotes TO \"{{name}}\";",
  ]
  revocation_statements = [
    "DROP ROLE IF EXISTS \"{{name}}\";",
  ]

  default_ttl = 3600
  max_ttl     = 86400
}
