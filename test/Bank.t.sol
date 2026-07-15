// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../src/Bank.sol";
import "../src/Errors.sol";

contract BankTest is Test {
    Bank public bank;

    function setUp() public {
        bank = new Bank();
    }
    // Тест на активацию аккаунта
    function test_Activate() public {
        bank.activate();
        assertTrue(bank.isActive());
    }

    // Тест на пополнение баланса
    function test_DepositActiveAccount() public {
        bank.activate();
        bank.deposit(100);

        assertEq(bank.getBalance(), 100);
    }

    // Тест на снятие средств
    function test_WithdrawActiveAccount() public {
        bank.activate();
        bank.deposit(200);
        bank.withdraw(50);

        assertEq(bank.getBalance(), 150);
    }

    // Тест на пополнение баланса неактивного аккаунта
    function test_DepositInactiveAccount() public {
        vm.expectRevert(AccountNotActivated.selector);
        bank.deposit(100);
    }

    // Тест на снятие средств неактивного аккаунта
    function test_WithdrawInactiveAccount() public {
        vm.expectRevert(AccountNotActivated.selector);
        bank.withdraw(50);
    }

    // Тест на снятие средств с недостаточным балансом
    function test_WithdrawInsufficientFunds() public {
        bank.activate();
        bank.deposit(100);

        // Попытка снять больше, чем доступно на балансе
        vm.expectRevert(InsufficientFunds.selector);
        bank.withdraw(150);
    }

    // Корректное изменение баланса после каждой операции
    function test_BalanceChangesCorrectlyAfterMultipleOperations() public {
        bank.activate();
    
        assertEq(bank.getBalance(), 0); // Изначальный баланс 0
    
        bank.deposit(500);
        assertEq(bank.getBalance(), 500); // Баланс после пополнения
    
        bank.withdraw(200);
        assertEq(bank.getBalance(), 300); // Баланс после снятия
    }
}
