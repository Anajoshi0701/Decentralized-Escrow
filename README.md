# 🛡️ Decentralized Escrow System

A comprehensive smart contract-based escrow platform built with Solidity and Foundry, enabling secure, trustless transactions with multi-role governance and dispute resolution. Features a factory pattern for scalable escrow management, automated deployment scripts, and full CI/CD integration.

## 📋 Contract Addresses

### Sepolia Testnet
- **EscrowFactory**: [0x2D9b84bcA994cBF3FBCdFc444239f90477580580](https://sepolia.etherscan.io/address/0x2D9b84bcA994cBF3FBCdFc444239f90477580580)
- **Escrow Implementation**: Dynamically deployed through factory

## 🚀 Quick Start

### Prerequisites
- **Foundry**: `curl -L https://foundry.paradigm.xyz | bash && foundryup`
- **Node.js** (v16+ recommended)
- **MetaMask** with Sepolia ETH

### Installation
```bash
git clone git@github.com:Anajoshi0701/Decentralized-Escrow.git
cd Decentralized-Escrow
forge install
```

### Environment Configuration
```bash
cp .env.example .env
# Edit with your credentials
```

**.env Configuration:**
```bash
  #LOCAL NETWORK
RPC_URL=http://127.0.0.1:8545
PRIVATE_KEY_DEPLOYER=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

  #SEPOLIA TESTNET
SEPOLIA_RPC_URL=
ETHERSCAN_API_KEY=
SEPOLIA_PRIVATE_KEY=

PRIVATE_KEY_BUYER0=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
PRIVATE_KEY_ARBITER0=0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a
PRIVATE_KEY_SELLER0=0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d

PRIVATE_KEY_BUYER1=0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6
PRIVATE_KEY_ARBITER1=0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba
PRIVATE_KEY_SELLER1=0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a

```

## 🏗️ Deployment

### Deploy to Sepolia Testnet
```bash
forge script script/DeployFactory.s.sol:DeployFactory \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $SEPOLIA_PRIVATE_KEY \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  -vvvv
```

### Deploy Locally (Anvil)
```bash
# Start local node
anvil

# Deploy factory
forge script script/DeployFactory.s.sol:DeployFactory \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY_DEPLOYER \
  --broadcast \
  -vvvv
```

## 🧪 Testing & Development

### Run Test Suite
```wsl
# Local tests
forge test -vvv

# Forked tests (Sepolia)
forge test --fork-url $SEPOLIA_RPC_URL -vvv

# Gas report
forge test --gas-report

# Coverage report
forge coverage
```

### Code Quality
```bash
# Format code
forge fmt

# Lint and check
forge fmt --check
```

## 📊 Scripts Overview

- **`DeployFactory.s.sol`** - Deploys EscrowFactory contract
- **`CreateEscrows.s.sol`** - Creates multiple escrows through factory
- **`Interactions.s.sol`** - Handles escrow operations (deposit, release, refund)
- **`InteractionsFactory.s.sol`** - Manages factory queries and operations

## 🔄 CI/CD Pipeline

GitHub Actions automatically runs on every push:
- ✅ Code formatting check (`forge fmt --check`)
- ✅ Compilation verification (`forge build`)
- ✅ Comprehensive test suite (`forge test -vvv`)
- ✅ Gas optimization reports

## 🛡️ Security Features

- **Reentrancy Protection**: OpenZeppelin's ReentrancyGuard
- **Access Control**: Role-based modifiers for buyer, seller, arbiter
- **Input Validation**: Comprehensive parameter checks
- **Safe ETH Transfers**: Protected fund transfers
- **Time-based Expiration**: Automatic refund eligibility
- **Dispute Resolution**: Arbiter-mediated conflict resolution

## 📝 License

MIT License - See LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Add tests for new functionality
4. Commit changes (`git commit -m 'feat: add amazing feature'`)
5. Push to branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## 🆘 Support

For issues and questions:
- 📋 Create a [GitHub Issue](https://github.com/Anajoshi0701/Decentralized-Escrow/issues)
- 🐛 Check existing test cases for usage examples
- 📖 Review contract documentation in code comments

---

**⚠️ Important**: Always test with small amounts first on testnet. Ensure all participants understand escrow terms before initiating transactions.

**🔗 Live Deployment**: [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x2D9b84bcA994cBF3FBCdFc444239f90477580580)

**👩💻 Built with ❤️ by Ana Joshi**