module questar_addr::questar_asset_tests {
    // Tests
    #[test_only]
    use aptos_framework::account;

    #[test_only]
    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]

    struct TestToken has key {}

    #[test_only]
    public fun create_test_token(creator: &signer): (ConstructorRef, Object<TestToken>) {
        account::create_account_for_test(signer::address_of(creator));
        let creator_ref = object::create_named_object(creator, b"TEST");
        let object_signer = object::generate_signer(&creator_ref);
        move_to(&object_signer, TestToken {});

        let token = object::object_from_constructor_ref<TestToken>(&creator_ref);
        (creator_ref, token)
    }

    #[test_only]
    public fun init_test_metadata(constructor_ref: &ConstructorRef): (MintRef, TransferRef, BurnRef) {
        add_fungibility(
            constructor_ref,
            option::some(100) /* max supply */,
            string::utf8(b"TEST"),
            string::utf8(b"@@"),
            0,
            string::utf8(b"http://www.example.com/favicon.ico"),
            string::utf8(b"http://www.example.com"),
        );
        let mint_ref = generate_mint_ref(constructor_ref);
        let burn_ref = generate_burn_ref(constructor_ref);
        let transfer_ref = generate_transfer_ref(constructor_ref);
        (mint_ref, transfer_ref, burn_ref)
    }

    #[test_only]
    public fun create_fungible_asset(
        creator: &signer
    ): (MintRef, TransferRef, BurnRef, Object<Metadata>) {
        let (creator_ref, token_object) = create_test_token(creator);
        let (mint, transfer, burn) = init_test_metadata(&creator_ref);
        (mint, transfer, burn, object::convert(token_object))
    }

    #[test_only]
    public fun create_test_store<T: key>(owner: &signer, metadata: Object<T>): Object<FungibleStore> {
        let owner_addr = signer::address_of(owner);
        if (!account::exists_at(owner_addr)) {
            account::create_account_for_test(owner_addr);
        };
        create_store(&object::create_object_from_account(owner), metadata)
    }

    #[test(creator = @0xcafe)]
    fun test_metadata_basic_flow(creator: &signer) acquires Metadata, Supply, ConcurrentSupply {
        let (creator_ref, metadata) = create_test_token(creator);
        init_test_metadata(&creator_ref);
        assert!(supply(metadata) == option::some(0), 1);
        assert!(maximum(metadata) == option::some(100), 2);
        assert!(name(metadata) == string::utf8(b"TEST"), 3);
        assert!(symbol(metadata) == string::utf8(b"@@"), 4);
        assert!(decimals(metadata) == 0, 5);

        increase_supply(&metadata, 50);
        assert!(supply(metadata) == option::some(50), 6);
        decrease_supply(&metadata, 30);
        assert!(supply(metadata) == option::some(20), 7);
    }

    #[test(creator = @0xcafe)]
    #[expected_failure(abort_code = 0x20005, location = Self)]
    fun test_supply_overflow(creator: &signer) acquires Supply, ConcurrentSupply {
        let (creator_ref, metadata) = create_test_token(creator);
        init_test_metadata(&creator_ref);
        increase_supply(&metadata, 101);
    }

    #[test(creator = @0xcafe)]
    fun test_create_and_remove_store(creator: &signer) acquires FungibleStore, FungibleAssetEvents {
        let (_, _, _, metadata) = create_fungible_asset(creator);
        let creator_ref = object::create_object_from_account(creator);
        create_store(&creator_ref, metadata);
        let delete_ref = object::generate_delete_ref(&creator_ref);
        remove_store(&delete_ref);
    }

    #[test(creator = @0xcafe, aaron = @0xface)]
    fun test_e2e_basic_flow(
        creator: &signer,
        aaron: &signer,
    ) acquires FungibleStore, Supply, ConcurrentSupply, DispatchFunctionStore {
        let (mint_ref, transfer_ref, burn_ref, test_token) = create_fungible_asset(creator);
        let metadata = mint_ref.metadata;
        let creator_store = create_test_store(creator, metadata);
        let aaron_store = create_test_store(aaron, metadata);

        assert!(supply(test_token) == option::some(0), 1);
        // Mint
        let fa = mint(&mint_ref, 100);
        assert!(supply(test_token) == option::some(100), 2);
        // Deposit
        deposit(creator_store, fa);
        // Withdraw
        let fa = withdraw(creator, creator_store, 80);
        assert!(supply(test_token) == option::some(100), 3);
        deposit(aaron_store, fa);
        // Burn
        burn_from(&burn_ref, aaron_store, 30);
        assert!(supply(test_token) == option::some(70), 4);
        // Transfer
        transfer(creator, creator_store, aaron_store, 10);
        assert!(balance(creator_store) == 10, 5);
        assert!(balance(aaron_store) == 60, 6);

        set_frozen_flag(&transfer_ref, aaron_store, true);
        assert!(is_frozen(aaron_store), 7);
    }

    #[test(creator = @0xcafe)]
    #[expected_failure(abort_code = 0x50003, location = Self)]
    fun test_frozen(
        creator: &signer
    ) acquires FungibleStore, Supply, ConcurrentSupply, DispatchFunctionStore {
        let (mint_ref, transfer_ref, _burn_ref, _) = create_fungible_asset(creator);

        let creator_store = create_test_store(creator, mint_ref.metadata);
        let fa = mint(&mint_ref, 100);
        set_frozen_flag(&transfer_ref, creator_store, true);
        deposit(creator_store, fa);
    }

    #[test(creator = @0xcafe, aaron = @0xface)]
    fun test_transfer_with_ref(
        creator: &signer,
        aaron: &signer,
    ) acquires FungibleStore, Supply, ConcurrentSupply {
        let (mint_ref, transfer_ref, _burn_ref, _) = create_fungible_asset(creator);
        let metadata = mint_ref.metadata;
        let creator_store = create_test_store(creator, metadata);
        let aaron_store = create_test_store(aaron, metadata);

        let fa = mint(&mint_ref, 100);
        set_frozen_flag(&transfer_ref, creator_store, true);
        set_frozen_flag(&transfer_ref, aaron_store, true);
        deposit_with_ref(&transfer_ref, creator_store, fa);
        transfer_with_ref(&transfer_ref, creator_store, aaron_store, 80);
        assert!(balance(creator_store) == 20, 1);
        assert!(balance(aaron_store) == 80, 2);
        assert!(!!is_frozen(creator_store), 3);
        assert!(!!is_frozen(aaron_store), 4);
    }

    #[test(creator = @0xcafe)]
    fun test_merge_and_exact(creator: &signer) acquires Supply, ConcurrentSupply {
        let (mint_ref, _transfer_ref, burn_ref, _) = create_fungible_asset(creator);
        let fa = mint(&mint_ref, 100);
        let cash = extract(&mut fa, 80);
        assert!(fa.amount == 20, 1);
        assert!(cash.amount == 80, 2);
        let more_cash = extract(&mut fa, 20);
        destroy_zero(fa);
        merge(&mut cash, more_cash);
        assert!(cash.amount == 100, 3);
        burn(&burn_ref, cash);
    }

    #[test(creator = @0xcafe)]
    #[expected_failure(abort_code = 0x10012, location = Self)]
    fun test_add_fungibility_to_deletable_object(creator: &signer) {
        account::create_account_for_test(signer::address_of(creator));
        let creator_ref = &object::create_object_from_account(creator);
        init_test_metadata(creator_ref);
    }

    #[test(creator = @0xcafe, aaron = @0xface)]
    #[expected_failure(abort_code = 0x10006, location = Self)]
    fun test_fungible_asset_mismatch_when_merge(creator: &signer, aaron: &signer) {
        let (_, _, _, metadata1) = create_fungible_asset(creator);
        let (_, _, _, metadata2) = create_fungible_asset(aaron);
        let base = FungibleAsset {
            metadata: metadata1,
            amount: 1,
        };
        let addon = FungibleAsset {
            metadata: metadata2,
            amount: 1
        };
        merge(&mut base, addon);
        let FungibleAsset {
            metadata: _,
            amount: _
        } = base;
    }

    #[test(fx = @aptos_framework, creator = @0xcafe)]
    fun test_fungible_asset_upgrade(
        fx: &signer,
        creator: &signer
    ) acquires Supply, ConcurrentSupply, FungibleStore {
        let feature = features::get_concurrent_fungible_assets_feature();
        let agg_feature = features::get_aggregator_v2_api_feature();
        features::change_feature_flags_for_testing(fx, vector[], vector[feature, agg_feature]);

        let (creator_ref, token_object) = create_test_token(creator);
        let (mint_ref, transfer_ref, _burn) = init_test_metadata(&creator_ref);
        let test_token = object::convert<TestToken, Metadata>(token_object);
        let creator_store = create_test_store(creator, test_token);

        let fa = mint(&mint_ref, 30);
        assert!(supply(test_token) == option::some(30), 2);

        deposit_with_ref(&transfer_ref, creator_store, fa);

        features::change_feature_flags_for_testing(fx, vector[feature, agg_feature], vector[]);

        let extend_ref = object::generate_extend_ref(&creator_ref);
        upgrade_to_concurrent(&extend_ref);

        let fb = mint(&mint_ref, 20);
        assert!(supply(test_token) == option::some(50), 3);

        deposit_with_ref(&transfer_ref, creator_store, fb);
    }
}
