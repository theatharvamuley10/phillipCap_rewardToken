import React, { useState } from "react";
import { ethers } from "ethers";
import "./RewardMe.css";

function RewardMe({ contract, account, fetchBalance }) {
  const [user, setUser] = useState("");
  const [amount, setAmount] = useState("");
  const [status, setStatus] = useState("Reward Me");

  const handleReward = async () => {
    if (!user || !amount) {
      alert("Enter valid user address and amount");
      return;
    }

    try {
      setStatus("Processing...");
      const tx = await contract.rewardUser(user, ethers.parseUnits(amount, 18));
      await tx.wait();

      setStatus("✅ Transaction Successful!");
      await fetchBalance(contract, account); // Refresh balance

      setTimeout(() => setStatus("Reward Me"), 2000);
    } catch (err) {
      console.error(err);
      alert("Reward transaction failed!");
      setStatus("Reward Me");
    }
  };

  return (
    <div className="reward-box">
      <h2>Reward User</h2>
      <input
        type="text"
        placeholder="User address"
        value={user}
        onChange={(e) => setUser(e.target.value)}
      />
      <input
        type="text"
        placeholder="Amount"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
      />
      <button onClick={handleReward} disabled={status !== "Reward Me"}>
        {status}
      </button>
    </div>
  );
}

export default RewardMe;
