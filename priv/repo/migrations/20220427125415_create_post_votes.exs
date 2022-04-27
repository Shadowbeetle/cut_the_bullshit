defmodule CutTheBullshit.Repo.Migrations.CreatePostVotes do
  use Ecto.Migration

  def change do
    create table(:post_votes) do
      add :value, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :post_id, references(:posts, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:post_votes, [:user_id, :post_id])
  end
end
