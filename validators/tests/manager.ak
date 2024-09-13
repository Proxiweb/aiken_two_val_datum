//// proofs & merke_roots

use aiken/interval
use cardano/address.{from_script}
use cardano/assets
use cardano/script_context.{ScriptContext}
use cardano/transaction.{InlineDatum, NoDatum, OutputReference}
use manager as manager_validator
use manager.{Issuer, IssuerDatum, SpendingDatum, State, StateDatum}
use tx_util/builder.{
  add_asset_to_tx_output, add_tx_input, add_tx_output, build_txn_context,
  mint_assets, new_tx_input, new_tx_output, with_asset_of_tx_input,
}

const admin_key = #"6af53ff4f054348ad825c692dd9db8f1760a8e0eacf9af9f99306513"

const manager_policy_id =
  #"76bf2457a842c931403c77579cc5fa359f5c280fe2d317504bc43234"

const param_utxo = OutputReference { transaction_id: "#00", output_index: 0 }

test mint_first_singularity_issuer_asset() {
  let state_input =
    new_tx_input(
      param_utxo.transaction_id,
      from_script(manager_policy_id),
      2_000_000,
      InlineDatum(State { issued: 0, merkle_root: None }),
    )

  let state_output =
    new_tx_output(
      from_script(manager_policy_id),
      2_000_000,
      InlineDatum(
        State {
          issued: 1,
          merkle_root: Some(
            #"2f369b92f7320cd36dc5a971295a24c4b06c272b8ad19afc0e419c44e1aec259",
          ),
        },
      ),
    )

  let ctx =
    interval.between(1, 2)
      |> build_txn_context()
      |> add_tx_input(state_input)
      |> add_tx_output(state_output)
      |> builder.add_signatory(admin_key)

  let result =
    manager_validator.manager.spend(
      admin_key,
      param_utxo,
      Some(StateDatum(SpendingDatum { issued, meSpendingDatumrkle_root: None })),
      minint_rdmr,
      manager_state_input.output_reference,
      ctx.transaction,
    )

  result
}
