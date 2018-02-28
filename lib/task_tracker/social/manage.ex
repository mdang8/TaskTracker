defmodule TaskTracker.Social.Manage do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTracker.Social.Manage
  alias TaskTracker.Accounts.User


  schema "manages" do
    belongs_to :underling, User
    belongs_to :manager, User

    timestamps()
  end

  @doc false
  def changeset(%Manage{} = manage, attrs) do
    manage
    |> cast(attrs, [:underling_id, :manager_id])
    |> validate_required([:underling_id, :manager_id])
  end
end
