defmodule TimedJobTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  test "fast enough" do
    stdout =
      capture_io(fn ->
        assert TimedJob.run(1, 100, 200) == :ok
      end)

    assert stdout =~ ~r"Job #1 should complete in 200ms"
    assert stdout =~ ~r"Job #1 completed in 100ms"
  end

  test "too slow" do
    stdout =
      capture_io(fn ->
        assert TimedJob.run(1, 200, 100) == :ok
      end)

    assert stdout =~ ~r"Job #1 should complete in 100ms"
    assert stdout =~ ~r"Times up for job #1 after 200ms"
    assert stdout =~ ~r"Job #1 completed in 200ms"
  end
end
