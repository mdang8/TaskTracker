defmodule TaskTracker.SocialTest do
  use TaskTracker.DataCase

  alias TaskTracker.Social

  describe "tasks" do
    alias TaskTracker.Social.Task

    @valid_attrs %{completed: true, description: "some description", duration: 42, title: "some title"}
    @update_attrs %{completed: false, description: "some updated description", duration: 43, title: "some updated title"}
    @invalid_attrs %{completed: nil, description: nil, duration: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Social.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Social.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Social.create_task(@valid_attrs)
      assert task.completed == true
      assert task.description == "some description"
      assert task.duration == 42
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = Social.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.completed == false
      assert task.description == "some updated description"
      assert task.duration == 43
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_task(task, @invalid_attrs)
      assert task == Social.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Social.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Social.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Social.change_task(task)
    end
  end

  describe "manages" do
    alias TaskTracker.Social.Manage

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def manage_fixture(attrs \\ %{}) do
      {:ok, manage} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_manage()

      manage
    end

    test "list_manages/0 returns all manages" do
      manage = manage_fixture()
      assert Social.list_manages() == [manage]
    end

    test "get_manage!/1 returns the manage with given id" do
      manage = manage_fixture()
      assert Social.get_manage!(manage.id) == manage
    end

    test "create_manage/1 with valid data creates a manage" do
      assert {:ok, %Manage{} = manage} = Social.create_manage(@valid_attrs)
    end

    test "create_manage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_manage(@invalid_attrs)
    end

    test "update_manage/2 with valid data updates the manage" do
      manage = manage_fixture()
      assert {:ok, manage} = Social.update_manage(manage, @update_attrs)
      assert %Manage{} = manage
    end

    test "update_manage/2 with invalid data returns error changeset" do
      manage = manage_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_manage(manage, @invalid_attrs)
      assert manage == Social.get_manage!(manage.id)
    end

    test "delete_manage/1 deletes the manage" do
      manage = manage_fixture()
      assert {:ok, %Manage{}} = Social.delete_manage(manage)
      assert_raise Ecto.NoResultsError, fn -> Social.get_manage!(manage.id) end
    end

    test "change_manage/1 returns a manage changeset" do
      manage = manage_fixture()
      assert %Ecto.Changeset{} = Social.change_manage(manage)
    end
  end

  describe "blocks" do
    alias TaskTracker.Social.TimeBlocks

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def time_blocks_fixture(attrs \\ %{}) do
      {:ok, time_blocks} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_time_blocks()

      time_blocks
    end

    test "list_blocks/0 returns all blocks" do
      time_blocks = time_blocks_fixture()
      assert Social.list_blocks() == [time_blocks]
    end

    test "get_time_blocks!/1 returns the time_blocks with given id" do
      time_blocks = time_blocks_fixture()
      assert Social.get_time_blocks!(time_blocks.id) == time_blocks
    end

    test "create_time_blocks/1 with valid data creates a time_blocks" do
      assert {:ok, %TimeBlocks{} = time_blocks} = Social.create_time_blocks(@valid_attrs)
    end

    test "create_time_blocks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_time_blocks(@invalid_attrs)
    end

    test "update_time_blocks/2 with valid data updates the time_blocks" do
      time_blocks = time_blocks_fixture()
      assert {:ok, time_blocks} = Social.update_time_blocks(time_blocks, @update_attrs)
      assert %TimeBlocks{} = time_blocks
    end

    test "update_time_blocks/2 with invalid data returns error changeset" do
      time_blocks = time_blocks_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_time_blocks(time_blocks, @invalid_attrs)
      assert time_blocks == Social.get_time_blocks!(time_blocks.id)
    end

    test "delete_time_blocks/1 deletes the time_blocks" do
      time_blocks = time_blocks_fixture()
      assert {:ok, %TimeBlocks{}} = Social.delete_time_blocks(time_blocks)
      assert_raise Ecto.NoResultsError, fn -> Social.get_time_blocks!(time_blocks.id) end
    end

    test "change_time_blocks/1 returns a time_blocks changeset" do
      time_blocks = time_blocks_fixture()
      assert %Ecto.Changeset{} = Social.change_time_blocks(time_blocks)
    end
  end
end
