defmodule TaskTrackerWeb.TimeBlockView do
  use TaskTrackerWeb, :view
  alias TaskTrackerWeb.TimeBlockView

  def render("index.json", %{blocks: blocks}) do
    %{data: render_many(blocks, TimeBlockView, "time_block.json")}
  end

  def render("show.json", %{time_block: time_block}) do
    %{data: render_one(time_block, TimeBlockView, "time_block.json")}
  end

  def render("time_block.json", %{time_block: time_block}) do
    %{id: time_block.id}
  end
end
