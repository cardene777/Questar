module questar_addr::db404 {
    use std::error;
    use std::option::{Self, Option};
    use std::string::String;
    use std::signer;
    use aptos_framework::object::{Self, DeleteRef, ExtendRef, Object, ObjectCore};
    use aptos_token_objects::property_map;
    use aptos_token_objects::token;
    use questar_addr::questar_token;

    const APP_OBJECT_SEED: vector<u8> = b"QUICK STAR";

    const MAX_PER_WALLET: u64 = 5;
    const NFT_PRICE: u64 = 100;
    const ERR_INVALID_PROOF: u64 = 1;
    const ERR_INVALID_MINT: u64 = 2;
    const ERR_INVALID_PRICE: u64 = 3;
    const ERR_TOTAL_SUPPLY_REACHED: u64 = 4;
    const ERR_NOT_LIVE: u64 = 5;

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    /// Storage state for managing the no-code Collection.
    struct QuestarCollection has key {
        mint_count: u64,
    }

    struct QuestarCollectionLive has key {
        live: bool,
    }

    struct ObjectController has key {
        extend_ref: ExtendRef,
    }

    fun init_module(deployer: &signer) {
        let constructor_ref = object::create_named_object(
            deployer,
            APP_OBJECT_SEED,
        );
        let extend_ref = object::generate_extend_ref(&constructor_ref);
        let app_signer = &object::generate_signer(&constructor_ref);

        move_to(app_signer, ObjectController {
            extend_ref,
        });
    }

    // public fun mint(
    //     owner: &signer,
    //     nft_amount: u64
    // ) acquires NFT, MintInfo {
    //     let nft = borrow_global_mut<NFT<Token>>(Signer::address_of(owner));
    //     assert(nft.live, ERR_NOT_LIVE);
    //     assert(nft.public_price * nft_amount == Coin::balance<Token>(owner), ERR_INVALID_PRICE);
    //     update_mint_count(owner, nft_amount);
    //     update_total_minted(nft, nft_amount);
    //     Coin::mint_to(owner, nft_amount); // Assume Token minting
    // }

    // fun update_total_minted(nft: &mut NFT<Token>, nft_amount: u64) {
    //     let new_total = nft.total_minted + nft_amount;
    //     assert(new_total <= MAX_SUPPLY, ERR_TOTAL_SUPPLY_REACHED);
    //     nft.total_minted = new_total;
    // }

    // fun update_mint_count(owner: &signer, nft_amount: u64) acquires MintInfo {
    //     let info = borrow_global_mut<MintInfo>(Signer::address_of(owner));
    //     let new_count = info.mint_count + nft_amount;
    //     assert(new_count <= MAX_PER_WALLET, ERR_INVALID_MINT);
    //     info.mint_count = new_count;
    // }
}
