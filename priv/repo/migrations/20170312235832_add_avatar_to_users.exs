defmodule Bugoverflow.Repo.Migrations.AddAvatarToUsers do
  use Ecto.Migration

  def change do
    rename table(:users), :photo, to: :avatar_url
  end
end
