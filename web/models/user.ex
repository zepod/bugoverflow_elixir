defmodule Bugoverflow.User do
  use Bugoverflow.Web, :model

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    field :avatar_url, :string
    field :name, :string
    has_many :articles, Bugoverflow.Article
    has_many :comments, Bugoverflow.Comment

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :provider, :token, :name, :avatar_url])
    |> validate_required([:email, :provider, :token, :name])
  end
end
