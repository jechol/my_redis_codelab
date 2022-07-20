defmodule MyRedisCluster do
  # Returns local redis pid
  def ensure_joined() do
    :pg.start_link()

    case :pg.get_local_members(:redis) do
      [] ->
        {:ok, pid} = MyRedis.start_link()
        :pg.join(:redis, pid)
        pid

      [pid] ->
        pid
    end
  end

  # Returns {:ok, value} or :error
  def get(key) do
    ensure_joined()

    redis_servers = :pg.get_members(:redis)

    redis_servers
    |> Enum.map(fn redis ->
      MyRedis.get(redis, key)
    end)
    |> Enum.filter(fn result -> result != :error end)
    |> case do
      [{:ok, val}] -> {:ok, val}
      [] -> :error
    end
  end

  # Returns :ok
  def set(key, value) do
    delete(key)

    [local_redis] = :pg.get_local_members(:redis)

    MyRedis.set(local_redis, key, value)
  end

  # Returns :ok
  def delete(key) do
    ensure_joined()

    redis_servers = :pg.get_members(:redis)

    redis_servers
    |> Enum.map(fn redis ->
      MyRedis.delete(redis, key)
    end)

    :ok
  end
end
