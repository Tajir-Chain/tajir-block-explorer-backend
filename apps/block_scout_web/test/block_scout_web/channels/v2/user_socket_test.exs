defmodule BlockScoutWeb.V2.UserSocketTest do
  use ExUnit.Case, async: true
  use Utils.CompileTimeEnvHelper, chain_type: [:explorer, :chain_type]

  if @chain_type in [:optimism, :optimism_agglayer] do
    test "registers optimism:* channel" do
      assert {BlockScoutWeb.OptimismChannel, _opts} =
               BlockScoutWeb.V2.UserSocket.__channel__("optimism:new_batch")
    end
  end
end
