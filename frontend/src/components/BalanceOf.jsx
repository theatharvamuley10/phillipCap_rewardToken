import React from "react";
import "./BalanceOf.css";

function BalanceOf({ balance }) {
  return (
    <div className="balance-card">
      <p className="balance-label">Your Token Balance</p>
      <p className="balance-value">{balance} PRT</p>
    </div>
  );
}

export default BalanceOf;
