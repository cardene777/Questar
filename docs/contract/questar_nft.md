# questar_nft

## Import Module

<details><summary>code</summary>

```rust
use questar_addr::questar_404;
use std::error;
use std::option::{Self, Option};
use std::string::{Self, String};
use std::signer;
use aptos_framework::object::{Self, ConstructorRef, Object};
use aptos_framework::object::ExtendRef;
use aptos_token_objects::collection;
use aptos_token_objects::property_map;
use aptos_token_objects::royalty;
use aptos_token_objects::token;
```

モジュールのインポート宣言。
他のモジュールで定義された型や関数を現在のモジュールで使用するために、use キーワードを使ってインポートしています。

- `use questar_addr::questar_404;`

  - `questar_addr`アドレスの`questar_404`モジュールをインポートしています。
  - `questar_nft`と`questar_asset`を橋渡しするモジュール。

- `use std::error;`

  - 標準ライブラリの`error`モジュールをインポートしています。
  - このモジュールには、エラー処理に関連する型や関数が定義されています。

- `use std::option::{Self, Option};`

  - 標準ライブラリの`option`モジュールから`Option`型をインポートしています。
  - `Option`型は、値が存在する場合と存在しない場合を表現するために使用されます。

- `use std::string::{Self, String};`

  - 標準ライブラリの`string`モジュールから`String`型をインポートしています。
  - `String`型は、文字列を表現するために使用されます。

- `use std::signer;`

  - 標準ライブラリの`signer`モジュールをインポートしています。
  - このモジュールには、トランザクションの署名者に関連する型や関数が定義されています。

- `use aptos_framework::object::{Self, ConstructorRef, Object};`

  - Aptos Framework の`object`モジュールから`ConstructorRef`型と`Object`型をインポートしています。
  - これらの型は、オブジェクトの作成と操作に使用されます。

- `use aptos_framework::object::ExtendRef;`

  - Aptos Framework の`object`モジュールから`ExtendRef`型をインポートしています。
  - この型は、オブジェクトの拡張に使用されます。

- `use aptos_token_objects::collection;`

  - Aptos Token Objects の`collection`モジュールをインポートしています。
  - このモジュールには、コレクションに関連する型や関数が定義されています。

- `use aptos_token_objects::property_map;`

  - Aptos Token Objects の`property_map`モジュールをインポートしています。
  - このモジュールには、プロパティマップに関連する型や関数が定義されています。
  - プロパティとは、トークンに付加的な情報を与えるために使用される、キーと値のペアのこと。

- ~~`use aptos_token_objects::royalty;`~~

  - ~~Aptos Token Objects の`royalty`モジュールをインポートしています。~~
  - ~~このモジュールには、ロイヤリティに関連する型や関数が定義されています。~~
  - ロイヤリティの導入は複雑になるため削除。

- `use aptos_token_objects::token;`
  - Aptos Token Objects の`token`モジュールをインポートしています。
  - このモジュールには、トークンに関連する型や関数が定義されています。

</details>

## Constants

<details><summary>code</summary>

```rust
const APP_OBJECT_SEED: vector<u8> = b"QUESTAR NFT";
const QUESTAR_COLLECTION_NAME: vector<u8> = b"QUESTAR NFT";
const QUESTAR_COLLECTION_DESCRIPTION: vector<u8> = b"QUESTAR NFT Collection";
const QUESTAR_COLLECTION_URI: vector<u8> = b"https://res.cloudinary.com/travary/image/upload/c_fill,h_400,w_400/v1/prd-akindo-public/communities/icon/4eBKpBw83T333gVK.png";
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
```

- `APP_OBJECT_SEED: vector<u8> = b"QUESTAR NFT";`

  - アプリケーションオブジェクトのシードを定義しています。
  - `b"QUESTAR NFT"`は、バイト文字列リテラルを使用して、文字列を`vector<u8>`型に変換しています。

- `QUESTAR_COLLECTION_NAME: vector<u8> = b"QUESTAR NFT";`

  - Questar コレクションの名前を定義しています。

- `QUESTAR_COLLECTION_DESCRIPTION: vector<u8> = b"QUESTAR NFT Collection";`

  - Questar コレクションの説明を定義しています。

- `QUESTAR_COLLECTION_URI: vector<u8> = b"https://res.cloudinary.com/travary/image/upload/c_fill,h_400,w_400/v1/prd-akindo-public/communities/icon/4eBKpBw83T333gVK.png";`

  - Questar コレクションの画像 URI を定義しています。

- `ECOLLECTION_DOES_NOT_EXIST: u64 = 1;`

  - コレクションが存在しない場合のエラーコードを定義しています。

- `ETOKEN_DOES_NOT_EXIST: u64 = 2;`

  - トークンが存在しない場合のエラーコードを定義しています。

- `ENOT_CREATOR: u64 = 3;`

  - 提供された署名者がコレクションまたはトークンの作成者でない場合のエラーコードを定義しています。

- `EFIELD_NOT_MUTABLE: u64 = 4;`

  - 変更しようとしているフィールドが変更不可能な場合のエラーコードを定義しています。

- `ETOKEN_NOT_BURNABLE: u64 = 5;`

  - バーンしようとしているトークンがバーン不可能な場合のエラーコードを定義しています。

- `EPROPERTIES_NOT_MUTABLE: u64 = 6;`
  - プロパティマップが変更不可能な場合のエラーコードを定義しています。

</details>

## QuestarCollection

<details><summary>code</summary>

```rust
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
```

`QuestarCollection`という構造体で、コレクションの状態を管理するために使用されます。

- `#[resource_group_member(group = aptos_framework::object::ObjectGroup)]`

  - この属性は、`QuestarCollection`構造体が Aptos フレームワークの`ObjectGroup`リソースグループに属することを示しています。

- `struct QuestarCollection has key`

  - `QuestarCollection`構造体を定義し、`has key`という修飾子を付けています。これにより、この構造体がグローバルストレージに保存され、キーを持つことを示しています。

- `mutator_ref: Option<collection::MutatorRef>`

  - コレクションのフィールドを変更するために使用される`MutatorRef`を保持するオプション型のフィールドです。

- `mutable_description: bool`

  - コレクションの作成者が説明を変更できるかどうかを示すブール値のフィールドです。

- `mutable_uri: bool`

  - コレクションの作成者が URI を変更できるかどうかを示すブール値のフィールドです。

- `mutable_token_description: bool`

  - コレクションの作成者がトークンの説明を変更できるかどうかを示すブール値のフィールドです。

- `mutable_token_name: bool`

  - コレクションの作成者がトークンの名前を変更できるかどうかを示すブール値のフィールドです。

- `mutable_token_properties: bool`

  - コレクションの作成者がトークンのプロパティを変更できるかどうかを示すブール値のフィールドです。

- `mutable_token_uri: bool`

  - コレクションの作成者がトークンの URI を変更できるかどうかを示すブール値のフィールドです。

- `tokens_burnable_by_creator: bool`

  - コレクションの作成者がトークンをバーンできるかどうかを示すブール値のフィールドです。

- `tokens_freezable_by_creator: bool`
  - コレクションの作成者がトークンをフリーズできるかどうかを示すブール値のフィールドです。

</details>

## QuestarNft

<details><summary>code</summary>

```rust
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
```

`QuestarNft`構造体は、トークンの状態を管理するために使用されます。

- `#[resource_group_member(group = aptos_framework::object::ObjectGroup)]`

  - この属性は、`QuestarNft`構造体が Aptos フレームワークの`ObjectGroup`リソースグループに属することを示しています。

- `struct QuestarNft has key`

  - `QuestarNft`構造体を定義し、`has key`という修飾子を付けています。
  - これにより、この構造体がグローバルストレージに保存され、キーを持つことを示しています。

- `burn_ref: Option<token::BurnRef>`

  - トークンをバーンするために使用される`BurnRef`を保持するオプション型のフィールドです。

- `transfer_ref: Option<object::TransferRef>`

  - トークンの転送を制御するために使用される`TransferRef`を保持するオプション型のフィールドです。
  - これは、トークンのフリーズ機能に関連しています。

- `mutator_ref: Option<token::MutatorRef>`

  - トークンのフィールドを変更するために使用される`MutatorRef`を保持するオプション型のフィールドです。

- `property_mutator_ref: property_map::MutatorRef`
  - トークンのプロパティを変更するために使用される`MutatorRef`を保持するフィールドです。

この構造体は、トークンの様々な操作や設定を管理するために使用されます。具体的には以下の機能を提供します。

- トークンのバーン（破棄）機能
- トークンの転送制御（フリーズ）機能
- トークンのフィールド（名前、説明、URI）の変更機能
- トークンのプロパティ（カスタムデータ）の変更機能

トークンがバーン不可能な場合、`burn_ref`フィールドは`None`になります。

</details>

## ObjectController

<details><summary>code</summary>

```rust
// We need a contract signer as the creator of the aptogotchi collection and aptogotchi token
// Otherwise we need admin to sign whenever a new aptogotchi token is minted which is inconvenient
struct ObjectController has key {
    // This is the extend_ref of the app object, not the extend_ref of collection object or token object
    // app object is the creator and owner of aptogotchi collection object
    // app object is also the creator of all aptogotchi token (NFT) objects
    // but owner of each token object is aptogotchi owner (i.e. user who mints aptogotchi)
    app_extend_ref: ExtendRef,
}
```

`ObjectController`という構造体は、コントラクトの署名者（signer）を管理するために使用されます。

- `struct ObjectController has key`

  - `ObjectController`構造体を定義し、`has key`という修飾子を付けています。
  - これにより、この構造体がグローバルストレージに保存され、キーを持つことを示しています。

- `app_extend_ref: ExtendRef`
  - アプリケーションオブジェクトの`ExtendRef`を保持するフィールドです。
  - これは、コレクションオブジェクトやトークンオブジェクトの`ExtendRef`ではありません。

コントラクトの署名者（signer）が必要な理由は、NFT コレクションとトークンの作成者として機能するためです。
通常、新しい NFT がミントされるたびに管理者（admin）が署名する必要があり不便です。
アプリケーションオブジェクトは、NFT コレクションオブジェクトの作成者および所有者です。
アプリケーションオブジェクトは、すべての NFT オブジェクトの作成者であり、各トークンオブジェクトの所有者は、NFT をミントしたユーザーです。

この構造体は、コントラクトの署名者を一元的に管理し、新しいトークンのミント時に管理者の署名を必要とせずに、コントラクト自体が署名者として機能できるようにするために使用されます。
これにより、ユーザーはより簡単にトークンをミントできるようになります。

</details>

## init_module

<details><summary>code</summary>

```rust
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
```

`init_module`関数は、モジュールが初めて公開されたときに一度だけ呼び出されます。

- `fun init_module(account: &signer)`

  - `init_module`関数を定義し、`account`パラメータを`&signer`型で受け取ります。

- `let constructor_ref = object::create_named_object(account, APP_OBJECT_SEED);`

  - `object::create_named_object`関数を呼び出し、`account`と`APP_OBJECT_SEED`を渡して、新しいオブジェクトを作成します。
  - 返された`ConstructorRef`は、`constructor_ref`変数に格納されます。

- `let extend_ref = object::generate_extend_ref(&constructor_ref);`

  - `object::generate_extend_ref`関数を呼び出し、`constructor_ref`からの`ExtendRef`を生成します。
  - 生成された`ExtendRef`は、`extend_ref`変数に格納されます。

- `let app_signer = &object::generate_signer(&constructor_ref);`

  - `object::generate_signer`関数を呼び出し、`constructor_ref`から署名者（signer）を生成します。
  - 生成された署名者へのリファレンスは、`app_signer`変数に格納されます。

- `move_to(app_signer, ObjectController { app_extend_ref: extend_ref, });`

  - `move_to`関数を使用して、`ObjectController`構造体のインスタンスを`app_signer`の下のグローバルストレージに移動します。
  - `ObjectController`のフィールド`app_extend_ref`には、先ほど生成した`extend_ref`が格納されます。

- `let name = string::utf8(QUESTAR_COLLECTION_NAME);`

  - `string::utf8`関数を使用して、`QUESTAR_COLLECTION_NAME`バイト文字列を UTF-8 エンコードされた文字列に変換し、`name`変数に格納します。

- `let description = string::utf8(QUESTAR_COLLECTION_DESCRIPTION);`

  - `string::utf8`関数を使用して、`QUESTAR_COLLECTION_DESCRIPTION`バイト文字列を UTF-8 エンコードされた文字列に変換し、`description`変数に格納します。

- `let uri = string::utf8(QUESTAR_COLLECTION_URI);`

  - `string::utf8`関数を使用して、`QUESTAR_COLLECTION_URI`バイト文字列を UTF-8 エンコードされた文字列に変換し、`uri`変数に格納します。

- `create_collection_object(...);`
  - `create_collection_object`関数を呼び出し、各種パラメータを渡して、新しいコレクションオブジェクトを作成します。

この関数は、モジュールの初期化時に呼び出され、アプリケーションオブジェクトとコレクションオブジェクトを作成し、グローバルストレージに必要な情報を保存します。

</details>

## create_collection

<details><summary>code</summary>

```rust
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
```

コレクション作成関数。

</details>

## create_collection_object

<details><summary>code</summary>

````rust

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
```

`create_collection_object`関数は、新しいコレクションオブジェクトを作成するために使用されます。

- `public fun create_collection_object(...): Object<QuestarCollection>`
    - `create_collection_object`関数を定義し、各種パラメータを受け取ります。
    - 戻り値の型は`Object<QuestarCollection>`です。

- `let creator_addr = signer::address_of(creator);`
    - `signer::address_of`関数を使用して、`creator`の署名者アドレスを取得し、`creator_addr`変数に格納します。

- `let constructor_ref = collection::create_fixed_collection(...);`
    - `collection::create_fixed_collection`関数を呼び出し、各種パラメータを渡して、新しいコレクションオブジェクトを作成します。
    - 返された`ConstructorRef`は、`constructor_ref`変数に格納されます。

- `let object_signer = object::generate_signer(&constructor_ref);`
    - `object::generate_signer`関数を呼び出し、`constructor_ref`からオブジェクトの署名者を生成します。
    - 生成された署名者は、`object_signer`変数に格納されます。

- `let mutator_ref = if (mutable_description || mutable_uri) { ... } else { ... };`
    - `mutable_description`または`mutable_uri`が`true`の場合、`collection::generate_mutator_ref`関数を呼び出して`MutatorRef`を生成し、`option::some`でラップして`mutator_ref`変数に格納します。
    - そうでない場合は、`option::none`を`mutator_ref`変数に格納します。

- `let aptos_collection = QuestarCollection { ... };`
  - `QuestarCollection`構造体のインスタンスを作成し、各フィールドに対応する値を設定します。

- `move_to(&object_signer, aptos_collection);`
    - `move_to`関数を使用して、`aptos_collection`を`object_signer`の下のグローバルストレージに移動します。

- `object::object_from_constructor_ref(&constructor_ref)`
    - `object::object_from_constructor_ref`関数を呼び出し、`constructor_ref`からオブジェクトを取得して返します。

この関数は、指定されたパラメータを使用して新しいコレクションオブジェクトを作成し、そのオブジェクトをグローバルストレージに移動して、最後にオブジェクトを返します。
コレクションの各種プロパティ（説明、URI、トークンの変更可能性など）は、関数のパラメータを通じて制御されます。

</details>

## mint

<details><summary>code</summary>

```rust
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
) acquires QuestarCollection, QuestarNft {
    mint_token_object(creator, collection, description, name, uri, property_keys, property_types, property_values);
}
```

`mint`関数は、既存のコレクションに新しいトークンを直接ミントするために使用されます。

- `public entry fun mint(...) acquires QuestarCollection, QuestarNft`
    - `mint`関数を定義し、各種パラメータを受け取ります。
    - `entry`修飾子は、この関数がエントリーポイント（つまり、外部から呼び出し可能な関数）であることを示します。
    - `acquires`句は、この関数が`QuestarCollection`と`QuestarNft`のリソースを取得することを示します。

- `creator: &signer`
    - トークンの作成者（ミントを実行する者）の署名者へのリファレンスを受け取ります。

- `collection: String`
    - トークンを追加するコレクションの名前を表す文字列を受け取ります。

- `description: String`
    - ミントするトークンの説明を表す文字列を受け取ります。

- `name: String`
    - ミントするトークンの名前を表す文字列を受け取ります。

- `uri: String`
    - ミントするトークンのURIを表す文字列を受け取ります。

- `property_keys: vector<String>`
    - トークンのプロパティのキーを表す文字列のベクターを受け取ります。

- `property_types: vector<String>`
    - トークンのプロパティの型を表す文字列のベクターを受け取ります。

- `property_values: vector<vector<u8>>`
    - トークンのプロパティの値を表すバイトのベクターのベクターを受け取ります。

- `mint_token_object(...);`
    - `mint_token_object`関数を呼び出し、受け取ったパラメータを渡します。
    - この関数は、実際のトークンのミントを行います。

この関数は、ユーザーがトークンをミントするためのエントリーポイントとして機能します。
ユーザーは、必要なパラメータを提供し、この関数を呼び出すことで、指定されたコレクションに新しいトークンを作成することができます。
トークンのプロパティ（説明、名前、URI、カスタムプロパティなど）は、関数のパラメータを通じて指定されます。

</details>

## mint_token_object

<details><summary>code</summary>

```rust
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
): Object<QuestarNft> acquires QuestarCollection, QuestarNft {
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
```

`mint_token_object`関数は、既存のコレクションに新しいトークンをミントし、ミントされたトークンのオブジェクトまたはアドレスを返します。

- `public fun mint_token_object(...): Object<QuestarNft> acquires QuestarCollection, QuestarNft`
    - `mint_token_object`関数を定義し、各種パラメータを受け取ります。
    - 戻り値の型は`Object<QuestarNft>`です。
    - `acquires`句は、この関数が`QuestarCollection`と`QuestarNft`のリソースを取得することを示します。

- `let constructor_ref = mint_internal(...);`
    - `mint_internal`関数を呼び出し、受け取ったパラメータを渡して、新しいトークンをミントします。
    - 返された`ConstructorRef`は、`constructor_ref`変数に格納されます。

- `let collection = collection_object(creator, &collection);`
    - `collection_object`関数を呼び出し、`creator`と`collection`の名前を渡して、コレクションオブジェクトを取得します。
    - 取得したオブジェクトは、`collection`変数に格納されます。

- `let freezable_by_creator = are_collection_tokens_freezable(collection);`
    - `are_collection_tokens_freezable`関数を呼び出し、`collection`オブジェクトを渡して、そのコレクションのトークンがフリーズ可能かどうかを判定します。
    - 結果は、`freezable_by_creator`変数に格納されます。

- `if (freezable_by_creator) { ... }`
    - トークンがフリーズ可能な場合、以下の処理を行います。
    - `object::address_from_constructor_ref`関数を使用して、`constructor_ref`からトークンのアドレスを取得し、`aptos_token_addr`変数に格納します。
    - `borrow_global_mut`関数を使用して、`aptos_token_addr`から`QuestarNft`リソースを可変で借用し、`aptos_token`変数に格納します。
    - `object::generate_transfer_ref`関数を使用して、`constructor_ref`から`TransferRef`を生成し、`transfer_ref`変数に格納します。
    - `option::fill`関数を使用して、`aptos_token.transfer_ref`フィールドに`transfer_ref`を格納します。

- `object::object_from_constructor_ref(&constructor_ref)`
    - `object::object_from_constructor_ref`関数を呼び出し、`constructor_ref`からオブジェクトを取得して返します。

この関数は、`mint_internal`関数を呼び出して実際のトークンのミントを行い、必要に応じてトークンのフリーズ機能を設定します。
最後に、ミントされたトークンのオブジェクトを返します。

</details>

## mint_internal

<details><summary>code</summary>

```rust
fun mint_internal(
    creator: &signer,
    collection: String,
    description: String,
    name: String,
    uri: String,
    property_keys: vector<String>,
    property_types: vector<String>,
    property_values: vector<vector<u8>>,
): ConstructorRef acquires QuestarCollection {
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

    constructor_ref
}
```

`mint_internal`関数は、実際のトークンのミントを行い、`ConstructorRef`を返します。

- `fun mint_internal(...): ConstructorRef acquires QuestarCollection`
    - `mint_internal`関数を定義し、各種パラメータを受け取ります。
    - 戻り値の型は`ConstructorRef`です。
    - `acquires`句は、この関数が`QuestarCollection`のリソースを取得することを示します。

- `let constructor_ref = token::create(...);`
    - `token::create`関数を呼び出し、受け取ったパラメータを渡して、新しいトークンを作成します。
    - 返された`ConstructorRef`は、`constructor_ref`変数に格納されます。

- `let object_signer = object::generate_signer(&constructor_ref);`
    - `object::generate_signer`関数を呼び出し、`constructor_ref`からオブジェクトの署名者を生成します。
    - 生成された署名者は、`object_signer`変数に格納されます。

- `let collection_obj = collection_object(creator, &collection);`
    - `collection_object`関数を呼び出し、`creator`と`collection`の名前を渡して、コレクションオブジェクトを取得します。
    - 取得したオブジェクトは、`collection_obj`変数に格納されます。

- `let collection = borrow_collection(&collection_obj);`
    - `borrow_collection`関数を呼び出し、`collection_obj`からコレクションリソースを借用します。
    - 借用したリソースは、`collection`変数に格納されます。

- `let mutator_ref = if (...) { ... } else { ... };`
    - コレクションのトークンの説明、名前、またはURIが変更可能な場合、`token::generate_mutator_ref`関数を呼び出して`MutatorRef`を生成し、`option::some`でラップして`mutator_ref`変数に格納します。
    - そうでない場合は、`option::none`を`mutator_ref`変数に格納します。

- `let burn_ref = if (...) { ... } else { ... };`
    - コレクションのトークンがバーン可能な場合、`token::generate_burn_ref`関数を呼び出して`BurnRef`を生成し、`option::some`でラップして`burn_ref`変数に格納します。
    - そうでない場合は、`option::none`を`burn_ref`変数に格納します。

- `let aptos_token = QuestarNft { ... };`
    - `QuestarNft`構造体のインスタンスを作成し、各フィールドに対応する値を設定します。

- `move_to(&object_signer, aptos_token);`
    - `move_to`関数を使用して、`aptos_token`を`object_signer`の下のグローバルストレージに移動します。

- `let properties = property_map::prepare_input(...);`
    - `property_map::prepare_input`関数を呼び出し、受け取ったプロパティのキー、型、値からプロパティマップを作成します。
    - 作成されたマップは、`properties`変数に格納されます。

- `property_map::init(&constructor_ref, properties);`
    - `property_map::init`関数を呼び出し、`constructor_ref`とプロパティマップを渡して、トークンのプロパティを初期化します。

- `constructor_ref`
    - 関数の最後で、`constructor_ref`を返します。

この関数は、トークンの作成、プロパティの設定、各種リソースの管理など、トークンのミントに必要な一連の処理を行います。

</details>

## borrow

<details><summary>code</summary>

```rust
inline fun borrow<T: key>(token: &Object<T>): &QuestarNft {
    let token_address = object::object_address(token);
    assert!(
        exists<QuestarNft>(token_address),
        error::not_found(ETOKEN_DOES_NOT_EXIST),
    );
    borrow_global<QuestarNft>(token_address)
}
```

`borrow`この関数は、トークンオブジェクトから`QuestarNft`リソースを借用します。

- `inline fun borrow<T: key>(token: &Object<T>): &QuestarNft`
    - `borrow`関数を定義し、ジェネリック型`T`をキーとして持つ`Object`への参照を受け取ります。
    - 戻り値の型は`&QuestarNft`（`QuestarNft`リソースへの参照）です。
    - `inline`修飾子は、この関数がインライン展開されることを示します。

- `let token_address = object::object_address(token);`
    - `object::object_address`関数を呼び出し、`token`オブジェクトのアドレスを取得します。
    - 取得したアドレスは、`token_address`変数に格納されます。

- `assert!( ... );`
    - `assert!`マクロを使用して、以下の条件をチェックします。
        - `exists<QuestarNft>(token_address)`
            `token_address`に`QuestarNft`リソースが存在するかどうかを確認します。
        - 条件が満たされない場合、`error::not_found(ETOKEN_DOES_NOT_EXIST)`が呼び出され、トークンが存在しないことを示すエラーがスローされます。

- `borrow_global<QuestarNft>(token_address)`
    - `borrow_global`関数を呼び出し、`token_address`から`QuestarNft`リソースを借用します。
    借用したリソースが関数の戻り値として返されます。

この関数は、指定されたトークンオブジェクトに対応する`QuestarNft`リソースを借用するために使用されます。
借用する前に、トークンオブジェクトのアドレスに`QuestarNft`リソースが存在するかどうかを確認し、存在しない場合はエラーをスローします。

`inline`修飾子が使用されているため、この関数を呼び出すコードは、関数の本体がインライン展開され、関数呼び出しのオーバーヘッドが削減されます。これにより、パフォーマンスが向上する可能性があります。

</details>

##

<details><summary>code</summary>

```rust
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
```

トークンのプロパティやフィールドに関する情報を取得するための複数の関数を定義しています。

1. `are_properties_mutable<T: key>(token: Object<T>): bool acquires QuestarCollection`
    - トークンのプロパティが変更可能かどうかを判定する関数です。
    - `token::collection_object`関数を使用して、トークンに関連付けられたコレクションオブジェクトを取得します。
    - `borrow_collection`関数を使用して、コレクションリソースを借用し、`mutable_token_properties`フィールドの値を返します。

2. `is_burnable<T: key>(token: Object<T>): bool acquires QuestarNft`
    - トークンがバーン可能かどうかを判定する関数です。
    - `borrow`関数を使用して、トークンの`QuestarNft`リソースを借用します。
    - `option::is_some`関数を使用して、`burn_ref`フィールドが`Some`値を持つかどうかを確認します。

3. `is_freezable_by_creator<T: key>(token: Object<T>): bool acquires QuestarCollection`
    - トークンが作成者によってフリーズ可能かどうかを判定する関数です。
    - `token::collection_object`関数を使用して、トークンに関連付けられたコレクションオブジェクトを取得します。
    - `are_collection_tokens_freezable`関数を呼び出して、コレクションのトークンがフリーズ可能かどうかを確認します。

4. `is_mutable_description<T: key>(token: Object<T>): bool acquires QuestarCollection`
    - トークンの説明が変更可能かどうかを判定する関数です。
    - `token::collection_object`関数を使用して、トークンに関連付けられたコレクションオブジェクトを取得します。
    - `is_mutable_collection_token_description`関数を呼び出して、コレクションのトークンの説明が変更可能かどうかを確認します。

5. `is_mutable_name<T: key>(token: Object<T>): bool acquires QuestarCollection`
    - トークンの名前が変更可能かどうかを判定する関数です。
    - `token::collection_object`関数を使用して、トークンに関連付けられたコレクションオブジェクトを取得します。
    - `is_mutable_collection_token_name`関数を呼び出して、コレクションのトークンの名前が変更可能かどうかを確認します。

6. `is_mutable_uri<T: key>(token: Object<T>): bool acquires QuestarCollection`
    - トークンのURIが変更可能かどうかを判定する関数です。
    - `token::collection_object`関数を使用して、トークンに関連付けられたコレクションオブジェクトを取得します。
    - `is_mutable_collection_token_uri`関数を呼び出して、コレクションのトークンのURIが変更可能かどうかを確認します。

これらの関数は、`#[view]`属性が付けられており、読み取り専用の関数として宣言されています。また、必要に応じて`acquires`句が使用され、関数内で借用するリソースを指定しています。

</details>

##

<details><summary>code</summary>



</details>

##

<details><summary>code</summary>



</details>

##

<details><summary>code</summary>



</details>

##

<details><summary>code</summary>



</details>

##

<details><summary>code</summary>



</details>

##

<details><summary>code</summary>



</details>

##

<details><summary>code</summary>



</details>

##

<details><summary>code</summary>



</details>
````
