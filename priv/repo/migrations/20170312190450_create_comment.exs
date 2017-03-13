defmodule Bugoverflow.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text
      add :article_id, references(:articles, on_delete: :delete_all)

      timestamps()
    end
    create index(:comments, [:article_id])

  end
end
