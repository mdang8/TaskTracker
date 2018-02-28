defmodule TaskTracker.Social.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTracker.Social.Task


  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :title, :string
    belongs_to :user, TaskTracker.Accounts.User
    belongs_to :assigned, TaskTracker.Accounts.User
#    belongs_to :start_time, TaskTracker.Social.TimeBlock
#    belongs_to :end_time, TaskTracker.Social.TimeBlock

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :completed, :user_id, :assigned_id, :start, :end])
    |> validate_required([:title, :description, :completed, :user_id, :assigned_id, :start, :end])
  end
end
