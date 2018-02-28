defmodule TaskTrackerWeb.ManageView do
  use TaskTrackerWeb, :view
  alias TaskTrackerWeb.ManageView

  def render("index.json", %{manages: manages}) do
    %{data: render_many(manages, ManageView, "manage.json")}
  end

  def render("show.json", %{manage: manage}) do
    %{data: render_one(manage, ManageView, "manage.json")}
  end

  def render("manage.json", %{manage: manage}) do
    %{id: manage.id}
  end
end
