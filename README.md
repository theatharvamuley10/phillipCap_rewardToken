### [Click for Demo of the Dapp](https://www.loom.com/share/47aa757a7a154934b999fe945df448f3)

### Overview

This DApp implements an ERC-20 Token “Phillip Reward Token” (PRT) on the Ethereum Sepolia Testnet, allowing an admin (owner) to reward users and users to transfer tokens.
It is comprised of a Solidity smart contract (RewardToken.sol), a React frontend, and Ethers.js integration.

### Deployed Contract

- **Deployed contract address:** `0xb0F09328a0973861EaBfaFc40B42E3b5F346bB85`
- **Deployment transaction hash:** `0xa1ac195881087b36a74de56a73e274390b25e43d528b2107aff6bf0b0b7e8cf1`
- **[View Transactions happening on Reward Token Contract on Sepolia Etherscan](https://sepolia.etherscan.io/address/0xb0F09328a0973861EaBfaFc40B42E3b5F346bB85)**

### Tech Stack

- **Smart Contracts:** Solidity (OpenZeppelin libraries, Foundry dev tooling)
- **Frontend:** React.js (vite)
- **Web3 Integration:** Ethers.js
- **Deployment:** Remix IDE (Sepolia Testnet)

### Setup & Run Instructions

#### 1. Clone the Repository

```sh
git clone https://github.com/theatharvamuley10/phillipCap_rewardToken
```

#### 2. Install Dependencies

- For the smart contract: Ensure [Foundry](https://book.getfoundry.sh/) is installed.

  ```sh
  cd contract
  forge install
  ```

- For the React frontend:
  ```sh
  cd frontend
  npm install
  ```

#### 3. Compile & Deploy Contract

- To compile using Foundry: Run the following command in contracts directory
  ```sh
  forge build
  ```
- Deploy on Sepolia using Remix IDE (RewardToken.sol).

#### 4. Configure Frontend

- Update `CONTRACT_ADDRESS` in `frontend/src/constants.js` to your deployed address:

  ```
  export const CONTRACT_ADDRESS = "YOUR_CONTRACT_ADDRESS";
  ```

#### 5. Run the Frontend

```sh
npm run dev
```

Visit `http://localhost:5173`, connect MetaMask, and interact with the DApp.

---

## Smart Contract & Security Design Notes

### Contract Design Choices

- Built on OpenZeppelin’s ERC20 and ERC20Permit for strong security and easy DeFi integration
- Uses a two-step ownership transfer to prevent loss or hijack of admin rights
- Pausable by the owner to halt all token transfers in emergencies

### Gas Optimisation

- Custom Solidity errors reduce revert gas costs
- ERC20Permit enables gasless approvals, lowering user transaction fees with of chain signing ability

### Security Checks

- All admin actions (mint, rewardUser, pause, etc.) are restricted to the owner
- Pausable modifier disables transfers during emergencies like attacks, rug pulls
- Validates that owner cannot self-reward and blocks invalid addresses

### Important Features

- Owner can reward users directly, supporting points/reward use cases
- Complete event logging for rewards, ownership changes, and admin actions
- Fully compatible with wallets, explorers, and future integrations

### Future Scope According to me

A system can be created with automatic reward system that rewards users on certain actions like repaying loans, buying a policy, extending a contract with phillip capital. It can also be used to measure their credit score and provide services accordingly. Simple example - more rewards earned by a user indicates more usage of our services and thus that user should have more benefits from us.
