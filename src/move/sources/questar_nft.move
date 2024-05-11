module questar_addr::questar_nft {
    use questar_addr::questar_404;
    use std::error;
    use std::option::{Self, Option};
    use std::string::{Self, String};
    use std::signer;
    use std::vector;
    use aptos_framework::object::{Self, ConstructorRef, Object};
    use aptos_framework::object::ExtendRef;
    use aptos_token_objects::collection;
    use aptos_token_objects::property_map;
    use aptos_token_objects::token;

    const APP_OBJECT_SEED: vector<u8> = b"QUESTAR NFT";
    const QUESTAR_COLLECTION_NAME: vector<u8> = b"QUESTAR NFT";
    const QUESTAR_COLLECTION_DESCRIPTION: vector<u8> = b"QUESTAR NFT Collection";
    const QUESTAR_COLLECTION_URI: vector<u8> = b"https://raw.githubusercontent.com/cardene777/Questar/develop/src/frontend/public/assets/images/questar/questar.png";
    /// The collection does not exist
    const ECOLLECTION_DOES_NOT_EXIST: u64 = 1;
    /// The token does not exist
    const ETOKEN_DOES_NOT_EXIST: u64 = 2;
    /// The provided signer is not the creator
    const ENOT_CREATOR: u64 = 3;
    /// The field being changed is not mutable
    const EFIELD_NOT_MUTABLE: u64 = 4;
    /// The token being burned is not burnable
    const ETOKEN_NOT_BURNABLE: u64 = 5;
    /// The property map being mutated is not mutable
    const EPROPERTIES_NOT_MUTABLE: u64 = 6;

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    /// Storage state for managing the no-code Collection.
    struct QuestarCollection has key {
        /// Used to mutate collection fields
        mutator_ref: Option<collection::MutatorRef>,
        /// Determines if the creator can mutate the collection's description
        mutable_description: bool,
        /// Determines if the creator can mutate the collection's uri
        mutable_uri: bool,
        /// Determines if the creator can mutate token descriptions
        mutable_token_description: bool,
        /// Determines if the creator can mutate token names
        mutable_token_name: bool,
        /// Determines if the creator can mutate token properties
        mutable_token_properties: bool,
        /// Determines if the creator can mutate token uris
        mutable_token_uri: bool,
        /// Determines if the creator can burn tokens
        tokens_burnable_by_creator: bool,
        /// Determines if the creator can freeze tokens
        tokens_freezable_by_creator: bool,
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    /// Storage state for managing the no-code Token.
    struct QuestarNft has key {
        /// Used to burn.
        burn_ref: Option<token::BurnRef>,
        /// Used to control freeze.
        transfer_ref: Option<object::TransferRef>,
        /// Used to mutate fields
        mutator_ref: Option<token::MutatorRef>,
        /// Used to mutate properties
        property_mutator_ref: property_map::MutatorRef,
    }

    struct ObjectController has key {
        app_extend_ref: ExtendRef,
    }

    struct OwnershipInfo has key {
        owned_tokens: u64,
    }

    // This function is only called once when the module is published for the first time.
    fun init_module(account: &signer) {
        let constructor_ref = object::create_named_object(
            account,
            APP_OBJECT_SEED,
        );
        let extend_ref = object::generate_extend_ref(&constructor_ref);
        let app_signer = &object::generate_signer(&constructor_ref);

        move_to(app_signer, ObjectController {
            app_extend_ref: extend_ref,
        });

        let name = string::utf8(QUESTAR_COLLECTION_NAME);
        let description = string::utf8(QUESTAR_COLLECTION_DESCRIPTION);
        let uri = string::utf8(QUESTAR_COLLECTION_URI);
        create_collection_object(
            account,
            description,
            100000,
            name,
            uri,
            true,
            true,
            true,
            true,
            true,
            false,
            true,
            true,
        );
    }

    /// Create a new collection
    public entry fun create_collection(
        creator: &signer,
        description: String,
        max_supply: u64,
        name: String,
        uri: String,
        mutable_description: bool,
        mutable_uri: bool,
        mutable_token_description: bool,
        mutable_token_name: bool,
        mutable_token_properties: bool,
        mutable_token_uri: bool,
        tokens_burnable_by_creator: bool,
        tokens_freezable_by_creator: bool,
    ) {
        create_collection_object(
            creator,
            description,
            max_supply,
            name,
            uri,
            mutable_description,
            mutable_uri,
            mutable_token_description,
            mutable_token_name,
            mutable_token_properties,
            mutable_token_uri,
            tokens_burnable_by_creator,
            tokens_freezable_by_creator,
        );
    }

    public fun create_collection_object(
        creator: &signer,
        description: String,
        max_supply: u64,
        name: String,
        uri: String,
        mutable_description: bool,
        mutable_uri: bool,
        mutable_token_description: bool,
        mutable_token_name: bool,
        mutable_token_properties: bool,
        mutable_token_uri: bool,
        tokens_burnable_by_creator: bool,
        tokens_freezable_by_creator: bool,
    ): Object<QuestarCollection> {
        let creator_addr = signer::address_of(creator);
        let constructor_ref = collection::create_fixed_collection(
            creator,
            description,
            max_supply,
            name,
            option::none(),
            uri,
        );

        let object_signer = object::generate_signer(&constructor_ref);
        let mutator_ref = if (mutable_description || mutable_uri) {
            option::some(collection::generate_mutator_ref(&constructor_ref))
        } else {
            option::none()
        };

        let aptos_collection = QuestarCollection {
            mutator_ref,
            mutable_description,
            mutable_uri,
            mutable_token_description,
            mutable_token_name,
            mutable_token_properties,
            mutable_token_uri,
            tokens_burnable_by_creator,
            tokens_freezable_by_creator,
        };
        move_to(&object_signer, aptos_collection);
        object::object_from_constructor_ref(&constructor_ref)
    }

    /// With an existing collection, directly mint a viable token into the creators account.
    public entry fun mint(
        creator: &signer,
        collection: String,
        description: String,
        name: String,
        uri: String,
        property_keys: vector<String>,
        property_types: vector<String>,
        property_values: vector<vector<u8>>,
    ) acquires QuestarCollection, QuestarNft, OwnershipInfo {
        mint_token_object(creator, collection, description, name, uri, property_keys, property_types, property_values);
    }

    /// Bulk mints NFTs into a specified collection.
    public entry fun bulk_mint(
        creator: &signer,
        collection: String,
        description: String,
        name: String,
        uri: String,
        property_keys: vector<String>,
        property_types: vector<String>,
        property_values: vector<vector<u8>>,
        num_tokens: u64,
    ) acquires QuestarCollection, QuestarNft, OwnershipInfo {
        let i = 0;
        while (i < num_tokens) {
            mint(
                creator,
                collection,
                description,
                name,
                uri,
                property_keys,
                property_types,
                property_values,
            );
            i = i + 1;
        }
    }

    /// Mint a token into an existing collection, and retrieve the object / address of the token.
    public fun mint_token_object(
        creator: &signer,
        collection: String,
        description: String,
        name: String,
        uri: String,
        property_keys: vector<String>,
        property_types: vector<String>,
        property_values: vector<vector<u8>>,
    ): Object<QuestarNft> acquires QuestarCollection, QuestarNft, OwnershipInfo {
        let constructor_ref = mint_internal(
            creator,
            collection,
            description,
            name,
            uri,
            property_keys,
            property_types,
            property_values,
        );

        let collection = collection_object(creator, &collection);

        // If tokens are freezable, add a transfer ref to be able to freeze transfers
        let freezable_by_creator = are_collection_tokens_freezable(collection);
        if (freezable_by_creator) {
            let aptos_token_addr = object::address_from_constructor_ref(&constructor_ref);
            let aptos_token = borrow_global_mut<QuestarNft>(aptos_token_addr);
            let transfer_ref = object::generate_transfer_ref(&constructor_ref);
            option::fill(&mut aptos_token.transfer_ref, transfer_ref);
        };

        object::object_from_constructor_ref(&constructor_ref)
    }

    fun mint_internal(
        creator: &signer,
        collection: String,
        description: String,
        name: String,
        uri: String,
        property_keys: vector<String>,
        property_types: vector<String>,
        property_values: vector<vector<u8>>,
    ): ConstructorRef acquires QuestarCollection, OwnershipInfo {
        let constructor_ref = token::create(creator, collection, description, name, option::none(), uri);

        let object_signer = object::generate_signer(&constructor_ref);

        let collection_obj = collection_object(creator, &collection);
        let collection = borrow_collection(&collection_obj);

        let mutator_ref = if (
            collection.mutable_token_description
                || collection.mutable_token_name
                || collection.mutable_token_uri
        ) {
            option::some(token::generate_mutator_ref(&constructor_ref))
        } else {
            option::none()
        };

        let burn_ref = if (collection.tokens_burnable_by_creator) {
            option::some(token::generate_burn_ref(&constructor_ref))
        } else {
            option::none()
        };

        let aptos_token = QuestarNft {
            burn_ref,
            transfer_ref: option::none(),
            mutator_ref,
            property_mutator_ref: property_map::generate_mutator_ref(&constructor_ref),
        };
        move_to(&object_signer, aptos_token);

        let properties = property_map::prepare_input(property_keys, property_types, property_values);
        property_map::init(&constructor_ref, properties);

        let owner_address = signer::address_of(creator);
        if (!exists<OwnershipInfo>(owner_address)) {
            move_to(creator, OwnershipInfo { owned_tokens: 0 });
        };

        let ownership_info = borrow_global_mut<OwnershipInfo>(owner_address);
        ownership_info.owned_tokens = ownership_info.owned_tokens + 1;

        constructor_ref
    }

    // Transfer

    /// Transfers an NFT from one address to another.
    // public entry fun transfer(
    //     creator: &signer,
    //     token_id: u64,
    //     from_address: address,
    //     to_address: address,
    //     collection_name: String
    // ) acquires QuestarNft {
    //     let from_collection_addr = collection::create_collection_address(&from_address, &collection_name);
    //     let to_collection_addr = collection::create_collection_address(&to_address, &collection_name);

    //     // Ensure the sender owns the token and the token exists
    //     assert!(
    //         exists<Token<QuestarNft>>(from_collection_addr, token_id),
    //         ETOKEN_DOES_NOT_EXIST
    //     );

    //     let token = move_from<Token<QuestarNft>>(from_collection_addr, token_id);
    //     let to_collection = if (!exists<Collection<QuestarNft>>(to_collection_addr)) {
    //         // Create a new collection for the receiver if it does not exist
    //         let new_collection = collection::create_empty_collection<QuestarNft>(
    //             &signer::borrow_global<signer>(to_address),
    //             &collection_name
    //         );
    //         move_to(&signer::borrow_global<signer>(to_address), new_collection);
    //         borrow_global_mut<Collection<QuestarNft>>(to_collection_addr)
    //     } else {
    //         borrow_global_mut<Collection<QuestarNft>>(to_collection_addr)
    //     };

    //     // Add the token to the new owner's collection
    //     collection::add_token(to_collection, token);
    // }

    // Token accessors

    inline fun borrow<T: key>(token: &Object<T>): &QuestarNft {
        let token_address = object::object_address(token);
        assert!(
            exists<QuestarNft>(token_address),
            error::not_found(ETOKEN_DOES_NOT_EXIST),
        );
        borrow_global<QuestarNft>(token_address)
    }

    #[view]
    public fun are_properties_mutable<T: key>(token: Object<T>): bool acquires QuestarCollection {
        let collection = token::collection_object(token);
        borrow_collection(&collection).mutable_token_properties
    }

    #[view]
    public fun is_burnable<T: key>(token: Object<T>): bool acquires QuestarNft {
        option::is_some(&borrow(&token).burn_ref)
    }

    #[view]
    public fun is_freezable_by_creator<T: key>(token: Object<T>): bool acquires QuestarCollection {
        are_collection_tokens_freezable(token::collection_object(token))
    }

    #[view]
    public fun is_mutable_description<T: key>(token: Object<T>): bool acquires QuestarCollection {
        is_mutable_collection_token_description(token::collection_object(token))
    }

    #[view]
    public fun is_mutable_name<T: key>(token: Object<T>): bool acquires QuestarCollection {
        is_mutable_collection_token_name(token::collection_object(token))
    }

    #[view]
    public fun is_mutable_uri<T: key>(token: Object<T>): bool acquires QuestarCollection {
        is_mutable_collection_token_uri(token::collection_object(token))
    }

    #[view]
    public fun balance(owner: address): u64 acquires OwnershipInfo {
        if (!exists<OwnershipInfo>(owner)) {
            return 0
        };
        borrow_global<OwnershipInfo>(owner).owned_tokens
    }

    // Token mutators

    inline fun authorized_borrow<T: key>(token: &Object<T>, creator: &signer): &QuestarNft {
        let token_address = object::object_address(token);
        assert!(
            exists<QuestarNft>(token_address),
            error::not_found(ETOKEN_DOES_NOT_EXIST),
        );

        assert!(
            token::creator(*token) == signer::address_of(creator),
            error::permission_denied(ENOT_CREATOR),
        );
        borrow_global<QuestarNft>(token_address)
    }

    public entry fun burn<T: key>(creator: &signer, token: Object<T>) acquires QuestarNft {
        let aptos_token = authorized_borrow(&token, creator);
        assert!(
            option::is_some(&aptos_token.burn_ref),
            error::permission_denied(ETOKEN_NOT_BURNABLE),
        );
        move aptos_token;
        let aptos_token = move_from<QuestarNft>(object::object_address(&token));
        let QuestarNft {
            burn_ref,
            transfer_ref: _,
            mutator_ref: _,
            property_mutator_ref,
        } = aptos_token;
        property_map::burn(property_mutator_ref);
        token::burn(option::extract(&mut burn_ref));
    }

    public entry fun bulk_burn<T: key>(
        creator: &signer,
        tokens: vector<Object<T>>,
        num_tokens: u64,
    ) acquires QuestarNft {
        let i = 0;
        while (i < num_tokens) {
            let token = vector::pop_back(&mut tokens);
            burn(creator, token);
            i = i + 1;
        }
    }

    public entry fun freeze_transfer<T: key>(creator: &signer, token: Object<T>) acquires QuestarCollection, QuestarNft {
        let aptos_token = authorized_borrow(&token, creator);
        assert!(
            are_collection_tokens_freezable(token::collection_object(token))
                && option::is_some(&aptos_token.transfer_ref),
            error::permission_denied(EFIELD_NOT_MUTABLE),
        );
        object::disable_ungated_transfer(option::borrow(&aptos_token.transfer_ref));
    }

    public entry fun unfreeze_transfer<T: key>(
        creator: &signer,
        token: Object<T>
    ) acquires QuestarCollection, QuestarNft {
        let aptos_token = authorized_borrow(&token, creator);
        assert!(
            are_collection_tokens_freezable(token::collection_object(token))
                && option::is_some(&aptos_token.transfer_ref),
            error::permission_denied(EFIELD_NOT_MUTABLE),
        );
        object::enable_ungated_transfer(option::borrow(&aptos_token.transfer_ref));
    }

    public entry fun set_description<T: key>(
        creator: &signer,
        token: Object<T>,
        description: String,
    ) acquires QuestarCollection, QuestarNft {
        assert!(
            is_mutable_description(token),
            error::permission_denied(EFIELD_NOT_MUTABLE),
        );
        let aptos_token = authorized_borrow(&token, creator);
        token::set_description(option::borrow(&aptos_token.mutator_ref), description);
    }

    public entry fun set_name<T: key>(
        creator: &signer,
        token: Object<T>,
        name: String,
    ) acquires QuestarCollection, QuestarNft {
        assert!(
            is_mutable_name(token),
            error::permission_denied(EFIELD_NOT_MUTABLE),
        );
        let aptos_token = authorized_borrow(&token, creator);
        token::set_name(option::borrow(&aptos_token.mutator_ref), name);
    }

    public entry fun set_uri<T: key>(
        creator: &signer,
        token: Object<T>,
        uri: String,
    ) acquires QuestarCollection, QuestarNft {
        assert!(
            is_mutable_uri(token),
            error::permission_denied(EFIELD_NOT_MUTABLE),
        );
        let aptos_token = authorized_borrow(&token, creator);
        token::set_uri(option::borrow(&aptos_token.mutator_ref), uri);
    }

    public entry fun add_property<T: key>(
        creator: &signer,
        token: Object<T>,
        key: String,
        type: String,
        value: vector<u8>,
    ) acquires QuestarCollection, QuestarNft {
        let aptos_token = authorized_borrow(&token, creator);
        assert!(
            are_properties_mutable(token),
            error::permission_denied(EPROPERTIES_NOT_MUTABLE),
        );

        property_map::add(&aptos_token.property_mutator_ref, key, type, value);
    }

    public entry fun add_typed_property<T: key, V: drop>(
        creator: &signer,
        token: Object<T>,
        key: String,
        value: V,
    ) acquires QuestarCollection, QuestarNft {
        let aptos_token = authorized_borrow(&token, creator);
        assert!(
            are_properties_mutable(token),
            error::permission_denied(EPROPERTIES_NOT_MUTABLE),
        );

        property_map::add_typed(&aptos_token.property_mutator_ref, key, value);
    }

    public entry fun remove_property<T: key>(
        creator: &signer,
        token: Object<T>,
        key: String,
    ) acquires QuestarCollection, QuestarNft {
        let aptos_token = authorized_borrow(&token, creator);
        assert!(
            are_properties_mutable(token),
            error::permission_denied(EPROPERTIES_NOT_MUTABLE),
        );

        property_map::remove(&aptos_token.property_mutator_ref, &key);
    }

    public entry fun update_property<T: key>(
        creator: &signer,
        token: Object<T>,
        key: String,
        type: String,
        value: vector<u8>,
    ) acquires QuestarCollection, QuestarNft {
        let aptos_token = authorized_borrow(&token, creator);
        assert!(
            are_properties_mutable(token),
            error::permission_denied(EPROPERTIES_NOT_MUTABLE),
        );

        property_map::update(&aptos_token.property_mutator_ref, &key, type, value);
    }

    public entry fun update_typed_property<T: key, V: drop>(
        creator: &signer,
        token: Object<T>,
        key: String,
        value: V,
    ) acquires QuestarCollection, QuestarNft {
        let aptos_token = authorized_borrow(&token, creator);
        assert!(
            are_properties_mutable(token),
            error::permission_denied(EPROPERTIES_NOT_MUTABLE),
        );

        property_map::update_typed(&aptos_token.property_mutator_ref, &key, value);
    }

    // Collection accessors

    inline fun collection_object(creator: &signer, name: &String): Object<QuestarCollection> {
        let collection_addr = collection::create_collection_address(&signer::address_of(creator), name);
        object::address_to_object<QuestarCollection>(collection_addr)
    }

    inline fun borrow_collection<T: key>(token: &Object<T>): &QuestarCollection {
        let collection_address = object::object_address(token);
        assert!(
            exists<QuestarCollection>(collection_address),
            error::not_found(ECOLLECTION_DOES_NOT_EXIST),
        );
        borrow_global<QuestarCollection>(collection_address)
    }

    public fun is_mutable_collection_description<T: key>(
        collection: Object<T>,
    ): bool acquires QuestarCollection {
        borrow_collection(&collection).mutable_description
    }

    public fun is_mutable_collection_uri<T: key>(
        collection: Object<T>,
    ): bool acquires QuestarCollection {
        borrow_collection(&collection).mutable_uri
    }

    public fun is_mutable_collection_token_description<T: key>(
        collection: Object<T>,
    ): bool acquires QuestarCollection {
        borrow_collection(&collection).mutable_token_description
    }

    public fun is_mutable_collection_token_name<T: key>(
        collection: Object<T>,
    ): bool acquires QuestarCollection {
        borrow_collection(&collection).mutable_token_name
    }

    public fun is_mutable_collection_token_uri<T: key>(
        collection: Object<T>,
    ): bool acquires QuestarCollection {
        borrow_collection(&collection).mutable_token_uri
    }

    public fun is_mutable_collection_token_properties<T: key>(
        collection: Object<T>,
    ): bool acquires QuestarCollection {
        borrow_collection(&collection).mutable_token_properties
    }

    public fun are_collection_tokens_burnable<T: key>(
        collection: Object<T>,
    ): bool acquires QuestarCollection {
        borrow_collection(&collection).tokens_burnable_by_creator
    }

    public fun are_collection_tokens_freezable<T: key>(
        collection: Object<T>,
    ): bool acquires QuestarCollection {
        borrow_collection(&collection).tokens_freezable_by_creator
    }

    // Collection mutators

    inline fun authorized_borrow_collection<T: key>(collection: &Object<T>, creator: &signer): &QuestarCollection {
        let collection_address = object::object_address(collection);
        assert!(
            exists<QuestarCollection>(collection_address),
            error::not_found(ECOLLECTION_DOES_NOT_EXIST),
        );
        assert!(
            collection::creator(*collection) == signer::address_of(creator),
            error::permission_denied(ENOT_CREATOR),
        );
        borrow_global<QuestarCollection>(collection_address)
    }

    public entry fun set_collection_description<T: key>(
        creator: &signer,
        collection: Object<T>,
        description: String,
    ) acquires QuestarCollection {
        let aptos_collection = authorized_borrow_collection(&collection, creator);
        assert!(
            aptos_collection.mutable_description,
            error::permission_denied(EFIELD_NOT_MUTABLE),
        );
        collection::set_description(option::borrow(&aptos_collection.mutator_ref), description);
    }

    public entry fun set_collection_uri<T: key>(
        creator: &signer,
        collection: Object<T>,
        uri: String,
    ) acquires QuestarCollection {
        let aptos_collection = authorized_borrow_collection(&collection, creator);
        assert!(
            aptos_collection.mutable_uri,
            error::permission_denied(EFIELD_NOT_MUTABLE),
        );
        collection::set_uri(option::borrow(&aptos_collection.mutator_ref), uri);
    }
}
