pragma solidity version ^0.5.4;

/*
    This contract shows an example of the TicTacToe game written in Solidity.
    Be careful while using it as it may be vulnerable to attacks.
*/
contract TicTacToe {

    Game[] public games;

    struct Game {
        uint turn;
        uint hostBalance;
        uint opponentBalance;
        address host;
        address opponent;
        mapping(uint => mapping(uint => address)) board;  // (Row, Column) format
    }

    constructor() public {
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
    modifier isHost(uint gameNumber, address player){
        //TODO De la même manière que isOpponent, valider que le joueur est bien le host de la partie
        require(games[gameNumber].host == player, "Given player should be the host");
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
        require(games[gameNumber].board[row][column] == address(0), "Cells is empty");
        _;
    }

    modifier isValueProvided(uint value) {
        if(value > 0){
            _;
        }
    }

    function getGamesNumber() public view returns (uint) {
        return games.length;
    }

    /*
        Returns the game numbers of the connected account
    */

    uint[] arrayNumber;
    function getHostGamesIds() public returns (uint[] memory){
        //TODO Retourner un array avec les numéro de jeux (getGamesNumber) auquel le compte EOA appelant la fonction est inscrit.
        address host = msg.sender;
        uint[] memory tempArrayNumber;
        arrayNumber = tempArrayNumber;

        for (uint i = 0; i < getGamesNumber(); i++) {
            
            if (games[i].host == host || games[i].opponent == host ){
            arrayNumber.push(i);
            }
      }
      return arrayNumber;
    }


    
    /*
        The host can initiate the game for his address. He bet an initial amount of Ether.
    */
    function initGame(address opponent) payable public {
        //TODO Créer un jeu et l'ajouter à la liste des jeux. Ce jeu doit enregistrer la mise du joueur le créant, 
        //ainsi que son addresse et l'addresse de l'adversaire qui sera passée en parametre.
        games.push(Game(0, msg.value, 0, msg.sender, opponent));

    }


    /*
        The opponent join the game.
    */
    function joinGame(uint gameNumber) isOpponent(gameNumber, msg.sender) public{
        //TODO L'adversaire (un compte EOA) rejoint une partie qu'il choisit et sur laquelle il est déjà enregistré comme adversaire.
        // Il doit mettre une mise initiale correspondant à celle mise par le Host
        games[gameNumber].opponentBalance = games[gameNumber].hostBalance;

    }

    /*
        Play on a given cell
    */
    function play(uint gameNumber, uint row, uint column) public{
        //TODO Un joueur place un pion sur un jeu auquel il s'est enregistré. Les mises des deux joueurs doivent être ident
        // iques pour jouer. Il faut également valider que la case n'a jamais été jouée.
        
    }

}
