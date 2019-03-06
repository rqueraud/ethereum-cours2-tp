pragma solidity ^0.5.4;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/TicTacToe.sol";

contract TestTicTacToe {

    TicTacToe ticTacToe = TicTacToe(DeployedAddresses.TicTacToe());

    function testGamesEmpty() public {
        Assert.equal(ticTacToe.getGamesNumber(), 0, "gamesCount initial value should be 0.");
    }
}