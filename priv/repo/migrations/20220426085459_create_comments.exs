defmodule CutTheBullshit.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :text, null: false
      add :votes, :integer, null: false, default: 1
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :post_id, references(:posts, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:post_id])
  end
end
