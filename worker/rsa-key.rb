# frozen_string_literal: true

# Lago signs webhooks with an RSA key (LAGO_RSA_PRIVATE_KEY, base64 PEM) that
# the API, the worker and the clock must share and keep across redeploys.
# Railway can't generate an RSA key as a template variable, so the first
# service to boot generates one and stores it in Postgres (schema
# railway_template); every later boot, on any service, reads the same key.
# Prints the base64 key on stdout. Logs go to stderr.
require "pg"
require "openssl"
require "base64"

url = ENV.fetch("DATABASE_URL")
attempts = Integer(ENV.fetch("RAILWAY_TEMPLATE_DB_WAIT_SECONDS", "120")) / 2

attempts.times do
  conn = PG.connect(url)
  conn.exec("SET client_min_messages TO warning")
  conn.exec("CREATE SCHEMA IF NOT EXISTS railway_template")
  conn.exec("CREATE TABLE IF NOT EXISTS railway_template.secrets (name text PRIMARY KEY, value text NOT NULL)")
  conn.exec_params(
    "INSERT INTO railway_template.secrets (name, value) VALUES ($1, $2) ON CONFLICT (name) DO NOTHING",
    ["lago_rsa_private_key", OpenSSL::PKey::RSA.new(2048).to_pem]
  )
  pem = conn.exec_params("SELECT value FROM railway_template.secrets WHERE name = $1", ["lago_rsa_private_key"]).getvalue(0, 0)
  conn.close
  print Base64.strict_encode64(pem)
  exit 0
rescue PG::Error => e
  warn "[railway-template] waiting for Postgres: #{e.message.lines.first&.strip}"
  sleep 2
end

warn "[railway-template] Postgres did not answer, giving up"
exit 1
