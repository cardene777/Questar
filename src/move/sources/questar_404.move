module questar_addr::questar_404 {
    use questar_addr::questar_asset::{Self};
    use questar_addr::questar_nft::{Self};
    use aptos_framework::primary_fungible_store;
    use aptos_framework::object::{Self, Object};
    use aptos_framework::fungible_asset::{Self, Metadata};
    use std::error;
    use std::signer;
    use std::string::utf8;
    use std::string::{Self, String};
    use std::option;

    const APP_OBJECT_SEED: vector<u8> = b"QUESTAR 404";

    const THRESHOLD: u64 = 100;

    public entry fun mint_nft(
        creator: &signer,
        asset: Object<Metadata>,
        collection: String,
        description: String,
        name: String,
        uri: String,
        property_keys: vector<String>,
        property_types: vector<String>,
        property_values: vector<vector<u8>>,
    ) {
        let creator_address = signer::address_of(creator);
        let token_balance = primary_fungible_store::balance(creator_address, asset);
        let nft_balance = questar_nft::balance(creator_address);

        let token_threshold = token_balance / THRESHOLD;

        if (token_threshold > nft_balance) {
            let num_tokens_to_mint = token_threshold - nft_balance;
            questar_nft::bulk_mint(
                creator,
                collection,
                description,
                name,
                uri,
                property_keys,
                property_types,
                property_values,
                num_tokens_to_mint,
            );
        }
    }

    // public entry fun mint_token(
    //     creator: &signer,
    //     to: address,
    //     amount: u64,
    //     collection: String,
    //     description: String,
    //     name: String,
    //     uri: String,
    //     property_keys: vector<String>,
    //     property_types: vector<String>,
    //     property_values: vector<vector<u8>>,
    // ) {
    //     let creator_address = signer::address_of(creator);
    //     questar_asset::mint(
    //         creator,
    //         to,
    //         amount,
    //         collection,
    //         description,
    //         name,
    //         uri,
    //         property_keys,
    //         property_types,
    //         property_values,
    //     );
    // }

    public entry fun burn_nft<T: key>(
        creator: &signer,
        tokens: vector<Object<T>>,
        asset: Object<Metadata>,
    ) {
        let creator_address = signer::address_of(creator);
        let token_balance = primary_fungible_store::balance(creator_address, asset);
        let nft_balance = questar_nft::balance(creator_address);

        let token_threshold = (token_balance - THRESHOLD) / THRESHOLD;

        if (nft_balance > token_threshold) {
            let num_tokens_to_burn = nft_balance - token_threshold;
            questar_nft::bulk_burn(
                creator,
                tokens,
                num_tokens_to_burn,
            );
        }
    }

    // public entry fun burn_token(
    //     creator: &signer,
    //     from: address,
    //     amount: u64,
    // ) {
    //     let creator_address = signer::address_of(creator);
    //     questar_asset::burn(creator, from, amount);
    // }
}
