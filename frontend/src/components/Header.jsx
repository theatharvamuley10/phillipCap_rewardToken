import React from "react";
import "./Header.css";

function Header({ account, connectWallet }) {
  const shortAddress = account
    ? `${account.slice(0, 6)}...${account.slice(-4)}`
    : null;

  return (
    <header className="header">
      <h1 className="header-title">Phillip Reward Token</h1>
      {account ? (
        <div className="wallet-address">{shortAddress}</div>
      ) : (
        <button className="connect-btn" onClick={connectWallet}>
          Connect Wallet
        </button>
      )}
    </header>
  );
}

export default Header;
