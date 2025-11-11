import React, { useState } from "react";
import { ethers } from "ethers";
import Header from "./components/Header";
import BalanceOf from "./components/BalanceOf";
import TransferToken from "./components/TransferToken";
import RewardMe from "./components/RewardMe";
import { CONTRACT_ADDRESS, CONTRACT_ABI } from "./constants.js";
import "./App.css";

function App() {
  const [account, setAccount] = useState(null);
  const [contract, setContract] = useState(null);
  const [balance, setBalance] = useState("0");

  const connectWallet = async () => {
    try {
      if (!window.ethereum) {
        alert("MetaMask not found. Please install it.");
        return;
      }

      const provider = new ethers.BrowserProvider(window.ethereum);
      const accounts = await provider.send("eth_requestAccounts", []);
      const signer = await provider.getSigner();

      const _contract = new ethers.Contract(
        CONTRACT_ADDRESS,
        CONTRACT_ABI,
        signer
      );

      setAccount(accounts[0]);
      setContract(_contract);

      // Fetch balance on connect
      fetchBalance(_contract, accounts[0]);
    } catch (error) {
      console.error(error);
    }
  };

  const fetchBalance = async (contractInstance, address) => {
    try {
      if (!contractInstance || !address) return;
      const bal = await contractInstance.balanceOf(address);
      setBalance(ethers.formatUnits(bal, 18));
    } catch (err) {
      console.error("Error fetching balance:", err);
    }
  };

  return (
    <div className="app">
      <Header account={account} connectWallet={connectWallet} />
      <main className="main-content">
        {contract ? (
          <>
            <BalanceOf balance={balance} />
            <TransferToken
              contract={contract}
              account={account}
              fetchBalance={fetchBalance}
            />
            <RewardMe
              contract={contract}
              account={account}
              fetchBalance={fetchBalance}
            />
          </>
        ) : (
          <p className="info-text">
            Please connect your wallet to use the dApp.
          </p>
        )}
      </main>
    </div>
  );
}

export default App;
