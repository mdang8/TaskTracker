defmodule TaskTracker.Social.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTracker.Social.TimeBlock


  schema "blocks" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    belongs_to :task, TaskTracker.Social.Task

    timestamps()
  end

  @doc false
  def changeset(%TimeBlock{} = time_block, attrs) do
    time_block
    |> cast(attrs, [:start, :end, :task_id])
    |> validate_required([:start, :task_id])
  end
end
