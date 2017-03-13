defmodule Bugoverflow.Article do
  use Bugoverflow.Web, :model

  schema "articles" do
    field :title, :string
    field :summary, :string
    field :content, :string
    has_many :comments, Bugoverflow.Comment
    belongs_to :user, Bugoverflow.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :summary, :content])
    |> validate_required([:title, :summary, :content])
  end
end
