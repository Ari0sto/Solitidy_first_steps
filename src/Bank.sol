// Сборка всех файлов воедино

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Types.sol";
import "./Events.sol";
import "./Errors.sol";

contract Bank {
    // переменная типа  Account
    Account private userAccount;


    // функция для активации аккаунта
    function activate() external {
        userAccount.isActive = true;
    }

    // функция для пополнения баланса
    function deposit(uint256 amount) external {
        if (!userAccount.isActive) {
            revert AccountNotActivated();
        }
        userAccount.balance += amount;
        emit Deposit(amount);
    }

    // функция для снятия средств
    function withdraw(uint256 amount) external {
        if (!userAccount.isActive) {
            revert AccountNotActivated();
        }
        if (amount > userAccount.balance) {
            revert InsufficientFunds();
        }

        userAccount.balance -= amount;
        emit Withdraw(amount);
    }

    // функция для получения баланса
    function getBalance() external view returns (uint256) {
        return userAccount.balance;
    }

    // функция для проверки активации аккаунта
    function isActive() external view returns (bool) {
        return userAccount.isActive;
    }
}