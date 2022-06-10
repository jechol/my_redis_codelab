defmodule MyRedisCluster do
  def ensure_joined() do
    :pg.start_link()

    case :pg.get_local_members(:redis) do
      [] ->
        {:ok, redis} = MyRedis.start_link()
        :pg.join(:redis, redis)
        redis

      [redis] ->
        redis
    end
  end

  def get(key) do
    ensure_joined()

    redis_servers = :pg.get_members(:redis)

    redis_servers
    |> Enum.map(fn redis ->
      MyRedis.get(redis, key)
    end)
    |> Enum.filter(fn value -> value != :error end)
    |> case do
      [{:ok, value} | _] -> {:ok, value}
      [] -> :error
    end
  end

  def delete(key) do
    ensure_joined()

    redis_servers = :pg.get_members(:redis)

    redis_servers
    |> Enum.map(fn redis ->
      MyRedis.delete(redis, key)
    end)

    :ok
  end

  def set(key, value) do
    delete(key)

    [redis] = :pg.get_local_members(:redis)
    MyRedis.set(redis, key, value)
  end
end
