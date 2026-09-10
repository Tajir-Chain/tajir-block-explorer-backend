defmodule EthereumJSONRPC.ReceiptTest do
  use ExUnit.Case, async: true
  use Utils.CompileTimeEnvHelper, chain_type: [:explorer, :chain_type]

  alias EthereumJSONRPC.Receipt

  doctest Receipt

  describe "to_elixir/1" do
    test "ignores new key" do
      assert Receipt.to_elixir(%{
               "new_key" => "new_value",
               "transactionHash" => "0x5c504ed432cb51138bcf09aa5e8a410dd4a1e204ef84bfed1be16dfba1b22060"
             }) == %{
               "transactionHash" => "0x5c504ed432cb51138bcf09aa5e8a410dd4a1e204ef84bfed1be16dfba1b22060"
             }
    end

    # Regression test for https://github.com/poanetwork/blockscout/issues/638
    test ~s|"status" => nil is treated the same as no status| do
      assert Receipt.to_elixir(%{"status" => nil, "transactionHash" => "0x0"}) == %{"transactionHash" => "0x0"}
    end
  end

  test "leaves nil if blockNumber is nil" do
    assert Receipt.to_elixir(%{"blockNumber" => nil, "transactionHash" => "0x0"}) == %{
             "transactionHash" => "0x0",
             "blockNumber" => nil
           }
  end

  if @chain_type in [:optimism, :optimism_agglayer] do
    describe "elixir_to_params/1 optimism L1 fee fields" do
      test "populates l1_fee fields from receipt" do
        params =
          %{
            "transactionHash" => "0x00",
            "transactionIndex" => "0x0",
            "blockHash" => "0x00",
            "blockNumber" => "0x1",
            "contractAddress" => nil,
            "cumulativeGasUsed" => "0x1",
            "gasUsed" => "0x1",
            "status" => "0x1",
            "logs" => [],
            "l1Fee" => "0x64",
            "l1GasPrice" => "0x2",
            "l1GasUsed" => "0x32"
          }
          |> Receipt.to_elixir()
          |> Receipt.elixir_to_params()
          |> Map.take([:l1_fee, :l1_gas_price, :l1_gas_used])

        assert params == %{l1_fee: 100, l1_gas_price: 2, l1_gas_used: 50}
      end
    end
  end
end
