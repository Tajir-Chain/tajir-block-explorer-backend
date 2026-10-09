defmodule EthereumJSONRPC.TransactionTest do
  use ExUnit.Case, async: true
  use Utils.CompileTimeEnvHelper, chain_type: [:explorer, :chain_type]

  doctest EthereumJSONRPC.Transaction

  alias EthereumJSONRPC.Transaction

  describe "to_elixir/1" do
    test "skips unsupported keys" do
      map = %{"key" => "value", "key1" => "value1"}

      assert %{ignore: :ignore} = Transaction.to_elixir(map)
    end
  end

  if @chain_type in [:optimism, :optimism_agglayer] do
    describe "elixir_to_params/1 optimism fields" do
      test "includes blob_versioned_hashes for type 3 transactions" do
        params =
          %{
            "type" => "0x3",
            "hash" => "0x00",
            "blockNumber" => "0x1",
            "nonce" => "0x1",
            "from" => "0x00",
            "gas" => "0x1",
            "gasPrice" => "0x1",
            "input" => "0x",
            "value" => "0x0",
            "transactionIndex" => "0x0",
            "blockHash" => "0x00",
            "v" => "0x0",
            "r" => "0x0",
            "s" => "0x0",
            "blobVersionedHashes" => ["0x01f326"]
          }
          |> Transaction.to_elixir()
          |> Transaction.elixir_to_params()

        assert Map.has_key?(params, :blob_versioned_hashes)
        assert params.blob_versioned_hashes == ["0x01f326"]
      end
    end
  end
end
