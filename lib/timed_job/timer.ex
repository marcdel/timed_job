defmodule TimedJob.Timer do
  use GenServer

  def start_link({job_id, max_time}) do
    GenServer.start_link(__MODULE__, {job_id, max_time})
  end

  def child_spec({job_id, max_time}) do
    %{
      id: {__MODULE__, {job_id, max_time}},
      start: {__MODULE__, :start_link, [{job_id, max_time}]},
      restart: :temporary
    }
  end

  def init({job_id, max_time}) do
    Process.send_after(self(), :times_up, max_time)
    {:ok, {job_id, max_time}}
  end

  def handle_info(:times_up, {job_id, max_time}) do
    IO.puts("Times up for job ##{job_id} after #{max_time}ms")
    {:noreply, {job_id, max_time}}
  end
end
