pragma solidity ^0.5.0;

/*
    This contract shows an example of the TicTacToe game written in Solidity.
    Be careful while using it as it may be vulnerable to attacks.
*/
contract TicTacToe {
    address public owner;

    Game[] public games;

    struct Game {
        address winner;
        uint turn;
        uint hostBalance;
        uint opponentBalance;
        address host;
        address opponent;
        mapping(uint => mapping(uint => address)) board;  // (Row, Column) format
    }

    constructor() public {
        owner = msg.sender;
    }

    /*
        Check if the player is registered in the game as the opponent.
    */
    modifier isOpponent(uint gameNumber, address player){
        require(games[gameNumber].opponent == player, "Given player should be the opponent.");
        _;
    }

    /*
        Check if the two players have credited the same amount
    */
    modifier isGameBalanceEqual(uint gameNumber) {
        Game memory game = games[gameNumber];
        require(game.hostBalance == game.opponentBalance, "Balance of players for the game are not equal.");
        _;
    }

    /*
        Check if the player is registered in the game as the host.
    */
    modifier isHost(uint gameNumber, address player) {
        require(games[gameNumber].host == player, "Given player should be the host.");
        _;
    }

    /*
        Check if the player is registered in the game either as the host or the opponent.
    */
    modifier isPlayer(uint gameNumber, address player) {
        require(games[gameNumber].host == player || games[gameNumber].opponent == player, "Given player is not part of the game.");
        _;
    }

    /*
        Host plays on even turns, opponent plays on odd turns.
        Check that the given player can play on the actual turn.
    */
    modifier isPlayerTurn(uint gameNumber, address player){
        if(games[gameNumber].turn%2 == 0 && player == games[gameNumber].host){
            _;
        }
        else if(games[gameNumber].turn%2 == 1 && player == games[gameNumber].opponent){
            _;
        }
    }

    /*
        Check if the cell is playable
    */
    modifier isCellFree(uint gameNumber, uint row, uint column){
        //TODO Valider que la case n'a jamais été jouée
        if(games[gameNumber].board[row][column] == address(0)){
            _;
        }
    }

    modifier isValueProvided(uint value) {
        if(value > 0){
            _;
        }
    }

    function getGamesNumber() public view returns (uint) {
        return games.length;
    }


    function getGamePrice(uint gameNumber) isPlayer(gameNumber, owner) public view returns (uint) {
        return games[gameNumber].hostBalance;
    }

    function isGameEnded(uint gameNumber) isPlayer(gameNumber, owner) public view returns (address) {
        return games[gameNumber].winner;
    }

    function getOppenentAddress(uint gameNumber) isPlayer(gameNumber, owner) public view returns (address) {
        return owner == games[gameNumber].host ? games[gameNumber].opponent : games[gameNumber].host;
    }

    /*
        Returns the game numbers of the connected account
    */
    function getHostGamesIds() public view returns (uint[] memory hostGames) {
        //TODO Retourner un array avec les numéro de jeux auquel le compte EOA appelant la fonction est inscrit.
        hostGames = new uint[](games.length);
        uint counter = 0;
        for (uint i = 0; i < games.length; i++) {
            if(games[i].host == owner || games[i].opponent == owner){
                hostGames[counter] = i;
                counter ++;
            }
        }
        return hostGames;
    }

    /*
        The host can initiate the game for his address. He bet an initial amount of Ether.
    */
    function initGame(address opponent, uint price) isValueProvided(price) public {
        //TODO Créer un jeu et l'ajouter à la liste des jeux. Ce jeu doit enregistrer la mise du joueur le créant, ainsi que son addresse et l'addresse de l'adversaire qui sera passée en parametre.
        Game memory newGame;
        newGame.host = owner;
        newGame.opponent = opponent;
        newGame.hostBalance = price;
        newGame.winner = address(0);

        games.push(newGame);
    }

    /*
        The opponent join the game.
    */
    function joinGame(uint gameNumber, uint price) isOpponent(gameNumber, owner) public {
        //TODO L'adversaire (un compte EOA) rejoint une partie qu'il choisit et sur laquelle il est déjà enregistré comme adversaire. Il doit mettre une mise initiale correspondant à celle mise par le Host.
        if(games[gameNumber].hostBalance == price){
            games[gameNumber].opponentBalance = price;
        }
    }

    /*
        Play on a given cell
    */
    function play(uint gameNumber, uint row, uint column) isPlayer(gameNumber, owner) isPlayerTurn(gameNumber, owner) isCellFree(gameNumber, row, column) public {
        //TODO Un joueur place un pion sur un jeu auquel il s'est enregistré. Les mises des deux joueurs doivent être identiques pour jouer. Il faut également valider que la case n'a jamais été jouée.
        games[gameNumber].board[row][column] = owner;
        games[gameNumber].turn ++;
    }

    function checkWin(uint gameNumber) public {
        // WIN
    }
}