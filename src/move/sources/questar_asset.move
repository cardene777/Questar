module questar_addr::questar_asset {
    use std::string;
    use std::option;
    use aptos_framework::fungible_asset::{Self, Metadata, FungibleStore, MintRef, TransferRef, BurnRef};
    use aptos_framework::object::{Self, Object};

    /// The maximum supply of my token.
    const MAX_SUPPLY: u128 = 10000000;

    /// Initialize my token. This can only be called once when the module is published.
    public fun initialize(account: &signer) {
        let constructor_ref = &object::create_object_from_account(account);
        fungible_asset::add_fungibility(
            constructor_ref,
            option::some(MAX_SUPPLY),
            string::utf8(b"My Token"),
            string::utf8(b"MTK"),
            8,
            string::utf8(b"https://example.com/icon.png"),
            string::utf8(b"https://mytoken.example.com"),
        );

        let mint_ref = fungible_asset::generate_mint_ref(constructor_ref);
        let transfer_ref = fungible_asset::generate_transfer_ref(constructor_ref);
        let burn_ref = fungible_asset::generate_burn_ref(constructor_ref);

        let metadata_obj = object::object_from_constructor_ref<Metadata>(constructor_ref);
        let store = fungible_asset::create_store(constructor_ref, metadata_obj);
        fungible_asset::mint_to(&mint_ref, store, (MAX_SUPPLY as u64));
    }

    /// Transfers `amount` of tokens from `from` to `to` with additional processing.
    public entry fun transfer(from: &signer, to: Object<FungibleStore>, amount: u64) {
        let from_store = fungible_asset::create_store(
            &object::create_object_from_account(from),
            fungible_asset::store_metadata(to)
        );
        fungible_asset::transfer(from, from_store, to, amount);
    }

    /// Burns `amount` of tokens from `from` with additional processing.
    public entry fun burn(from: &signer, to: Object<FungibleStore>, amount: u64) {
        let burn_ref = fungible_asset::generate_burn_ref(&object::create_object_from_account(from));
        burn_tokens_internal(&burn_ref, to, amount);
    }

    private fun burn_tokens_internal(burn_ref: &BurnRef, from: Object<FungibleStore>, amount: u64) {
        fungible_asset::burn_from(burn_ref, from, amount);
    }
}
