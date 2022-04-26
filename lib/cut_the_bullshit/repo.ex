defmodule CutTheBullshit.Repo do
  use Ecto.Repo,
    otp_app: :cut_the_bullshit,
    adapter: Ecto.Adapters.Postgres
end
