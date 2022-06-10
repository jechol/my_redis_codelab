defmodule MyRedisTest do
  use ExUnit.Case

  setup do
    {:ok, redis} = MyRedis.start_link()
    %{redis: redis}
  end

  test "single", %{redis: redis} do
    # before set
    assert :error == MyRedis.get(redis, :foo)

    # set
    assert :ok == MyRedis.set(redis, :foo, :bar)
    assert {:ok, :bar} == MyRedis.get(redis, :foo)
    assert {:ok, :bar} == MyRedis.get(redis, :foo)

    # delete
    assert :ok == MyRedis.delete(redis, :foo)
    assert :error == MyRedis.get(redis, :foo)
  end

  test "nil is not error", %{redis: redis} do
    # before set
    assert :error == MyRedis.get(redis, :foo)

    # set
    assert :ok == MyRedis.set(redis, :foo, nil)
    assert {:ok, nil} == MyRedis.get(redis, :foo)

    # delete
    assert :ok == MyRedis.delete(redis, :foo)
    assert :error == MyRedis.get(redis, :foo)
  end

  test "multiple", %{redis: redis} do
    # set
    assert :ok == MyRedis.set(redis, :k1, :v1)
    assert :ok == MyRedis.set(redis, :k2, :v2)
    assert :ok == MyRedis.set(redis, :k3, :v3)
    # get
    assert {:ok, :v1} == MyRedis.get(redis, :k1)
    assert {:ok, :v2} == MyRedis.get(redis, :k2)
    assert {:ok, :v3} == MyRedis.get(redis, :k3)
    # delete
    assert :ok == MyRedis.delete(redis, :k1)
    assert :ok == MyRedis.delete(redis, :k2)
    assert :ok == MyRedis.delete(redis, :k3)
    # get
    assert :error == MyRedis.get(redis, :k1)
    assert :error == MyRedis.get(redis, :k2)
    assert :error == MyRedis.get(redis, :k3)
  end
end
