# 🛡️ Decentralized Escrow

A smart contract-based escrow system built with Solidity and Foundry, enabling secure, trustless transactions between buyers and sellers with an arbiter for dispute resolution. The project now includes a Factory pattern for creating multiple escrows, deployment & interaction scripts, automated testing, and GitHub Actions integration.

## 📦 Features

Escrow Contract with buyer, seller, and arbiter roles

Deposit, Release, Refund, Dispute, Force Refund flows

Time-based expiration for escrow completion

Escrow Factory for deploying and managing multiple escrow contracts

Mappings to track escrows by buyer, seller, arbiter, and deployer

Deployment & Interaction Scripts using Foundry

Environment configuration via .env

Automated CI with GitHub Actions

Testnet-ready (Sepolia)

## 🧰 Tech Stack

Solidity ^0.8.20

Foundry (Forge & Cast)

OpenZeppelin-contracts
Foundry DevOps for deployment helpers

GitHub Actions for CI

Alchemy RPC for Sepolia

Etherscan API for contract verification

## 🚀 Getting Started
1. Clone the Repository

```
git clone git@github.com:Anajoshi0701/Decentralized-Escrow.git
cd Decentralized-Escrow
```

2. Install Foundry

```
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

3. Set Up Environment Variables

Create a .env file based on .env.example:

```
RPC_URL=http://127.0.0.1:8545
PRIVATE_KEY_DEPLOYER=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

PRIVATE_KEY_BUYER0=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
PRIVATE_KEY_ARBITER0=0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a
PRIVATE_KEY_SELLER0=0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d

PRIVATE_KEY_BUYER1=0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6
PRIVATE_KEY_ARBITER1=0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba
PRIVATE_KEY_SELLER1=0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a

```

4. Create a escrows.json File for Factory
Use the following as reference:

```
{
  "escrows": [
    {
      "buyer": "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
      "seller": "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
      "arbiter": "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC",
      "amount": "1000000000000000000",
      "duration": "604800"
    },
    {
      "buyer": "0x90F79bf6EB2c4f870365E785982E1f101E93b906",
      "seller": "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65",
      "arbiter": "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc",
      "amount": "1000000000000000000",
      "duration": "1209600"
    }
  ],
  "count": 2
}
```

📜 Contracts

Escrow.sol
Core escrow logic:

Buyer deposits funds

Seller receives release

Buyer can be refunded

Buyer/seller can raise disputes

Forced refund available after expiration

EscrowFactory.sol

Deploys new Escrow contracts

Tracks escrows by buyer, seller, arbiter, and deployer

Emits EscrowCreated events for monitoring

📂 Scripts

DeployEscrow.s.sol → Deploy a single Escrow contract

DeployFactory.s.sol → Deploy the EscrowFactory contract

CreateEscrows.s.sol → Use the factory to create escrows

Interactions.s.sol → Interact with Escrow.sol (deposit, release, refund, dispute, forceRefund)

InteractionsFactory.s.sol → Interact with EscrowFactory (query and manage escrows)

🧪 Testing

Run unit tests with:

```
forge test -vvv
```

Tests are located in:

test/Escrow.t.sol → Unit tests for Escrow.sol

test/EscrowFactoryTest.t.sol → Unit tests for EscrowFactory.sol

🔄 Continuous Integration

GitHub Actions automatically run formatting and tests on every push.
Formatting is enforced via:

```
forge fmt --check
```

🔐 License

This project is licensed under the MIT License.

🙋‍♀️ Author

Built with ❤️ by Ana Joshi
GitHub: @Anajoshi0701