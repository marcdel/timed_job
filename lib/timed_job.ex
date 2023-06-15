defmodule TimedJob do
  def run(job_id, actual_time \\ 200, max_time \\ 100) do
    IO.puts("Job ##{job_id} should complete in #{max_time}ms")

    DynamicSupervisor.start_child(TimedJob.Supervisor.JobTimer, {TimedJob.Timer, {job_id, max_time}})

    Process.sleep(actual_time)

    IO.puts("Job ##{job_id} completed in #{actual_time}ms")
    :ok
  end
end
