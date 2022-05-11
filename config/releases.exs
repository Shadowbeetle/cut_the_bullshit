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

smtp_server =
  System.get_env("SMTP_SERVER") ||
    raise """
    environment variable SMTP_SERVER is missing.
    For example: smtp.avengers.com
    """

smtp_username =
  System.get_env("SMTP_USERNAME") ||
    raise """
    environment variable SMTP_USERNAME is missing.
    """

smtp_password =
  System.get_env("SMTP_PASSWORD") ||
    raise """
    environment variable SMTP_PASSWORD is missing.
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
  # Comment this out for running the release locally
  ssl: true,
  pool_size: 2

config :cut_the_bullshit, CutTheBullshit.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: smtp_server,
  username: smtp_username,
  password: smtp_password,
  ssl: true,
  tls: :always,
  auth: :always,
  retries: 2
