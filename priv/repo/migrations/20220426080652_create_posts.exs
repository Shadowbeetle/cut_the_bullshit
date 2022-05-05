defmodule CutTheBullshit.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string, null: false
      add :description, :text
      add :url, :string
      add :votes, :integer, null: false, default: 1
      add :comment_count, :integer, null: false, default: 0
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:posts, [:user_id])
    create unique_index(:posts, [:title])

    create constraint(:posts, :url_or_description_required,
             check: "(url IS NOT NULL) OR (description IS NOT NULL)"
           )
  end
end
