import React, { useState } from "react";
import { ethers } from "ethers";
import "./TransferToken.css";

function TransferToken({ contract, account, fetchBalance }) {
  const [to, setTo] = useState("");
  const [amount, setAmount] = useState("");
  const [status, setStatus] = useState("Transfer");

  const handleTransfer = async () => {
    if (!to || !amount) {
      alert("Enter valid address and amount");
      return;
    }

    try {
      setStatus("Processing...");
      const tx = await contract.transfer(to, ethers.parseUnits(amount, 18));
      await tx.wait();

      setStatus("✅ Transaction Successful!");
      await fetchBalance(contract, account); // Refresh balance

      setTimeout(() => setStatus("Transfer"), 2000);
    } catch (err) {
      console.error(err);
      alert("Transfer failed!");
      setStatus("Transfer");
    }
  };

  return (
    <div className="transfer-box">
      <h2>Transfer Tokens</h2>
      <input
        type="text"
        placeholder="Recipient address"
        value={to}
        onChange={(e) => setTo(e.target.value)}
      />
      <input
        type="text"
        placeholder="Amount"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
      />
      <button onClick={handleTransfer} disabled={status !== "Transfer"}>
        {status}
      </button>
    </div>
  );
}

export default TransferToken;
