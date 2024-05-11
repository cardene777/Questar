# Transfer NFT

```mermaid
sequenceDiagram
    actor user as Address
    autonumber
    participant nft as Questar NFT
    participant token as Questar Token(ERC20)
    participant erc404 as Questar 404

    Note over user,erc404: transfer nft
    user->>nft: transfer NFT
    nft->>erc404: burn token
    erc404->>token: burn 100 token
    Note right of token: THRESHOLD = 100
    token->>user: burn 100 token
    user-->>token: burn 100t token
    token-->>erc404: burn 100t token
    erc404-->>nft: burn token
    nft-->>user: transfer nft
```
