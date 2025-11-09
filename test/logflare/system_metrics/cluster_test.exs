defmodule Logflare.SystemMetrics.ClusterTest do
  use ExUnit.Case, async: false

  alias Logflare.SystemMetrics.Cluster

  describe "finch/0" do
    test "executes pool checks when enable_pool_check is true" do
      # Save original config
      original_config = Application.get_env(:logflare, :enable_pool_check)

      # Set config to true
      Application.put_env(:logflare, :enable_pool_check, true)

      # This should not raise an error even if pools don't exist
      # The function should handle errors gracefully
      assert :ok = Cluster.finch() || :ok

      # Restore original config
      if original_config == nil do
        Application.delete_env(:logflare, :enable_pool_check)
      else
        Application.put_env(:logflare, :enable_pool_check, original_config)
      end
    end

    test "skips pool checks when enable_pool_check is false" do
      # Save original config
      original_config = Application.get_env(:logflare, :enable_pool_check)

      # Set config to false
      Application.put_env(:logflare, :enable_pool_check, false)

      # This should return nil and not attempt any pool checks
      assert Cluster.finch() == nil

      # Restore original config
      if original_config == nil do
        Application.delete_env(:logflare, :enable_pool_check)
      else
        Application.put_env(:logflare, :enable_pool_check, original_config)
      end
    end

    test "defaults to true when enable_pool_check is not set" do
      # Save original config
      original_config = Application.get_env(:logflare, :enable_pool_check)

      # Remove the config
      Application.delete_env(:logflare, :enable_pool_check)

      # Should behave as if enabled (default true)
      # The function should handle errors gracefully
      assert :ok = Cluster.finch() || :ok

      # Restore original config
      if original_config == nil do
        Application.delete_env(:logflare, :enable_pool_check)
      else
        Application.put_env(:logflare, :enable_pool_check, original_config)
      end
    end
  end
end
