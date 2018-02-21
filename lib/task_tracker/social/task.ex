defmodule TaskTracker.Social.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTracker.Social.Task


  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :duration, :integer
    field :title, :string
    belongs_to :user, TaskTracker.Accounts.User
    belongs_to :assigned, TaskTracker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :duration, :completed, :user_id, :assigned_id])
    |> validate_required([:title, :description, :duration, :completed, :user_id, :assigned_id])
  end
end
