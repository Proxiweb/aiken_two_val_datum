use aiken/crypto.{VerificationKeyHash}
use cardano/assets.{PolicyId}
use cardano/transaction.{OutputReference, Transaction} as tx

pub type State {
  issued: Int,
  merkle_root: Option<ByteArray>,
}

pub type Issuer {
  issued: Int,
  did: ByteArray,
  issuer: VerificationKeyHash,
  allowed_policies: List<PolicyId>,
}

pub type SpendingDatum {
  StateDatum(State)
  IssuerDatum(Issuer)
}

validator manager(_admin: VerificationKeyHash, _utxo_ref: OutputReference) {
  spend(
    maybe_datum: Option<SpendingDatum>,
    _rdmr: Void,
    _own_ref: OutputReference,
    _self: Transaction,
  ) {
    expect Some(datum) = maybe_datum

    when datum is {
      StateDatum(_state) -> True
      IssuerDatum(_issuer) -> False
    }
  }

  else(_) {
    fail
  }
}
