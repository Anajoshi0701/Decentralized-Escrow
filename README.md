# 🛡️ Decentralized Escrow

A smart contract-based escrow system built with **Solidity** and **Foundry**, enabling secure, trustless transactions between buyers and sellers with an arbiter for dispute resolution. This project includes deployment scripts, interaction logic, automated testing, and GitHub Actions integration.

---

## 📦 Features

- Escrow contract with buyer, seller, and arbiter roles  
- Deposit, release, refund, dispute, and force refund flows  
- Time-based duration for escrow expiration  
- Deployment and interaction scripts using Foundry  
- Environment configuration via `.env`  
- Automated CI with GitHub Actions  
- Testnet-ready (Sepolia)

---

## 🧰 Tech Stack

- **Solidity** `^0.8.20`  
- **Foundry** (Forge & Cast)  
- **GitHub Actions** for CI  
- **Alchemy RPC** for Sepolia  
- **Etherscan API** for contract verification

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone git@github.com:Anajoshi0701/Decentralized-Escrow.git
cd Decentralized-Escrow

2. Install Foundry

curl -L https://foundry.paradigm.xyz | bash
foundryup

3. Set Up Environment Variables

Create a .env file based on .env.example:

RPC_URL=
SEPOLIA_RPC_URL=
ETHERSCAN_API_KEY=

SELLER=
ARBITER=

AMOUNT=
DURATION=

PRIVATE_KEY_BUYER=
PRIVATE_KEY_SELLER=
PRIVATE_KEY_ARBITER=

📜 Contracts

Escrow.sol

Located in src/, this contract handles:

Deposits from buyer

Release of funds to seller

Refunds to buyer

Dispute initiation by buyer/seller

Forced refund by buyer after duration

📂 Scripts

DeployEscrow.s.sol

Deploys the Escrow contract using environment variables.

Interactions.s.sol

Handles all contract interactions:

deposit()

release()

refund()

disputeAsBuyer()

disputeAsSeller()

forceRefund()

🧪 Testing

Run unit tests with:

forge test

Tests are located in test/Escrow.t.sol.

🔐 License

This project is licensed under the MIT License.

🙋‍♀️ Author

Built with ❤️ by Ana JoshiGitHub: @Anajoshi0701
