defmodule Bugoverflow.Comment do
  use Bugoverflow.Web, :model

  schema "comments" do
    field :body, :string
    belongs_to :article, Bugoverflow.Article
    belongs_to :user, Bugoverflow.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body])
    |> validate_required([:body])
  end
end
