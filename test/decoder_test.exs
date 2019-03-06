defmodule DecoderTest do
  alias Membrane.Pipeline
  use ExUnit.Case

  def make_pipeline(in_path, out_path) do
    Pipeline.start_link(
      DecodingPipeline,
      %{in: in_path, out: out_path, pid: self()},
      []
    )
  end

  def assert_files_equal(file_a, file_b) do
    assert {:ok, a} = File.read(file_a)
    assert {:ok, b} = File.read(file_b)
    assert a == b
  end

  def prepare_paths(filename) do
    in_path = "fixtures/input-#{filename}.aac" |> Path.expand(__DIR__)
    reference_path = "fixtures/reference-#{filename}.raw" |> Path.expand(__DIR__)
    out_path = "/tmp/output-decoding-#{filename}.raw"
    File.rm(out_path)
    on_exit(fn -> File.rm(out_path) end)
    {in_path, reference_path, out_path}
  end

  describe "Decoding Pipeline should" do
    test "Decode AAC file" do
      {in_path, reference_path, out_path} = prepare_paths("sample")
      assert {:ok, pid} = make_pipeline(in_path, out_path)

      assert Pipeline.play(pid) == :ok
      assert_receive :eos, 500
      assert_files_equal(out_path, reference_path)
    end
  end
end