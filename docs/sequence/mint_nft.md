# Mint NFT

```mermaid
sequenceDiagram
    actor user as Address
    autonumber
    participant nft as Questar NFT
    participant token as Questar Token(ERC20)
    participant erc404 as Questar 404

    Note over user,erc404: mint nft
    user->>nft: mint NFT
    nft->>erc404: mint token
    erc404->>token: mint 100 token
    Note right of token: THRESHOLD = 100
    token->>user: mint 100 token
    user-->>token: mint 100t token
    token-->>erc404: mint 100t token
    erc404-->>nft: mint token
    nft-->>user: mint nft
```
