defmodule CutTheBullshit.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      # TODO: add validation to schema for length no longer than 255
      add :title, :string, null: false
      add :description, :text, null: false
      add :url, :string, null: false
      add :votes, :integer, null: false, default: 1
      add :comment_count, :integer, null: false, default: 0
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:posts, [:user_id])
    create unique_index(:posts, [:title])
  end
end
