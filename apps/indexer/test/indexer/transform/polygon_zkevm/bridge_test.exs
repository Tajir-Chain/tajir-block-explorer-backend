defmodule Indexer.Transform.PolygonZkevm.BridgeTest do
  use ExUnit.Case, async: false
  use Utils.CompileTimeEnvHelper, chain_type: [:explorer, :chain_type]

  alias Indexer.Fetcher.PolygonZkevm.{BridgeL1, BridgeL2}
  alias Indexer.Transform.PolygonZkevm.Bridge

  if @chain_type in [:polygon_zkevm, :optimism_agglayer] do
    describe "parse/2" do
      setup do
        old_bridge_l2 = Application.get_env(:indexer, BridgeL2)
        old_bridge_l1 = Application.get_env(:indexer, BridgeL1)

        Application.put_env(
          :indexer,
          BridgeL2,
          Keyword.merge(old_bridge_l2 || [],
            start_block: 1,
            rollup_network_id_l2: 1,
            rollup_index_l2: 0,
            bridge_contract: "0x0000000000000000000000000000000000000001"
          )
        )

        Application.put_env(
          :indexer,
          BridgeL1,
          Keyword.merge(old_bridge_l1 || [],
            rpc: "http://localhost:8545",
            rollup_network_id_l1: 0,
            rollup_index_l1: 0
          )
        )

        on_exit(fn ->
          if is_nil(old_bridge_l2) do
            Application.delete_env(:indexer, BridgeL2)
          else
            Application.put_env(:indexer, BridgeL2, old_bridge_l2)
          end

          if is_nil(old_bridge_l1) do
            Application.delete_env(:indexer, BridgeL1)
          else
            Application.put_env(:indexer, BridgeL1, old_bridge_l1)
          end
        end)

        :ok
      end

      test "returns empty list when blocks is empty" do
        assert Bridge.parse([], []) == []
      end
    end
  end
end
