import React from "react";
import "./Header.css";

function Header({ account, connectWallet }) {
  return (
    <header className="header">
      <h1 className="header-title">Phillip Reward Token</h1>
      {account ? (
        <div className="wallet-address">{account}</div>
      ) : (
        <button className="connect-btn" onClick={connectWallet}>
          Connect Wallet
        </button>
      )}
    </header>
  );
}

export default Header;
