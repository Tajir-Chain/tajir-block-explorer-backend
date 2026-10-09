defmodule Explorer.Chain.Import.Stage.ChainTypeSpecificTest do
  use ExUnit.Case, async: true
  use Utils.CompileTimeEnvHelper, chain_type: [:explorer, :chain_type]

  alias Explorer.Chain.Import.Runner
  alias Explorer.Chain.Import.Stage.ChainTypeSpecific

  if @chain_type == :optimism_agglayer do
    describe "runners/0" do
      test "includes optimism runners and polygon zkevm bridge runners only" do
        runners = ChainTypeSpecific.runners()

        optimism_runners = [
          Runner.Optimism.FrameSequences,
          Runner.Optimism.FrameSequenceBlobs,
          Runner.Optimism.TransactionBatches,
          Runner.Optimism.OutputRoots,
          Runner.Optimism.DisputeGames,
          Runner.Optimism.Deposits,
          Runner.Optimism.Withdrawals,
          Runner.Optimism.WithdrawalEvents,
          Runner.Optimism.EIP1559ConfigUpdates,
          Runner.Optimism.InteropMessages
        ]

        bridge_runners = [
          Runner.PolygonZkevm.BridgeL1Tokens,
          Runner.PolygonZkevm.BridgeOperations
        ]

        zk_batch_runners = [
          Runner.PolygonZkevm.LifecycleTransactions,
          Runner.PolygonZkevm.TransactionBatches,
          Runner.PolygonZkevm.BatchTransactions
        ]

        Enum.each(optimism_runners ++ bridge_runners, fn runner ->
          assert runner in runners
        end)

        Enum.each(zk_batch_runners, fn runner ->
          refute runner in runners
        end)
      end
    end
  end
end
