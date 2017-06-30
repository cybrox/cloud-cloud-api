defmodule Cloud do
  @moduledoc """
  Cloud core module, provides meta functionality
  """

  @version Mix.Project.config[:version]

  def version do
    @version
  end

  def hostname do
    case :inet.gethostname do
      {:ok, hostname} -> hostname
      _ -> "unknown"
    end
  end
end
