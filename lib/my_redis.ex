defmodule MyRedis do
  use GenServer
  # 아래와 같은 API 를 가지는 MyRedis 를 GenServer 기반으로 구현하세요.
  # mix test 를 통과하면 구현이 완료된 것입니다.

  def start_link() do
  end

  def get(pid, key) do
  end

  def set(pid, key, value) do
  end

  def delete(pid, key) do
  end
end
