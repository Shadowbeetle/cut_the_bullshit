import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :cut_the_bullshit, CutTheBullshitWeb.Endpoint,
  server: true,
  # Needed for Phoenix 1.2 and 1.4. Doesn't hurt for 1.3.
  http: [port: System.get_env("PORT")],
  secret_key_base: secret_key_base,
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443]
  # For starting the release locally
  # url: [host: "localhost", port: 4001]

config :cut_the_bullshit, CutTheBullshit.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: database_url,
  database: "",
  ssl: true, # Comment this out for running the release locally
  pool_size: 2
