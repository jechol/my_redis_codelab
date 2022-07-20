defmodule MyRedis do
  use Agent
  # 아래와 같은 API 를 가지는 MyRedis 를 Agent 기반으로 구현하세요.
  # mix test 를 통과하면 구현이 완료된 것입니다.

  # Returns {:ok, pid}
  def start_link() do
  end

  # Returns {:ok, value} or :error
  def get(pid, key) do
  end

  # Returns :ok
  def set(pid, key, value) do
  end

  # Returns :ok
  def delete(pid, key) do
  end
end
